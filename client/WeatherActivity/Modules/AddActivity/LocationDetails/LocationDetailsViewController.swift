//
//  LocationDetailsViewController.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 03.12.2020..
//

// MARK: Imports

import UIKit
import CoreLocation
import MapKit
import DropDown

class LocationDetailsViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationTextField: UITextField!
    
    // MARK: Properties
    
    var locationManager = CLLocationManager()
    var searchCompleter = MKLocalSearchCompleter()
    var searchSuggestions = [String]()
    let geoCoder = CLGeocoder()
    var locationDetails: LocationDetails?
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        searchCompleter.delegate = self
        setupLocationTextField()
        setupMapGestureRecognizer()
        setupLocationManager()
        setupDropDown()
    }
    
    // MARK: IBActions
    
    @IBAction func currentLocationPressed(_ sender: UIButton) {
        
        locationManager.startUpdatingLocation()
    }
}

// MARK: CLLocationManagerDelegate

extension LocationDetailsViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            self.locationManager.stopUpdatingLocation()
            zoomMap(lat: location.coordinate.latitude, lon: location.coordinate.longitude, setMapPoint: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        #warning("Handle error")
    }
}

// MARK: Map manipulation

private extension LocationDetailsViewController {
    
    func zoomMap(lat latitude: CLLocationDegrees, lon longitude: CLLocationDegrees,  setMapPoint setPoint: Bool) {
        
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(mRegion, animated: true)
        if setPoint {
            addMapPointAnnotation(lat: latitude, lon: longitude)
        }
    }
    
    func addMapPointAnnotation(lat latitude: CLLocationDegrees, lon longitude: CLLocationDegrees) {
        
        removeAnnotations()
        let mapPoint: MKPointAnnotation = MKPointAnnotation()
        mapPoint.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        mapView.addAnnotation(mapPoint)
        let coordinates = CLLocation(latitude: latitude, longitude: longitude)
        geoDecodeFromCoordinates(locationCoordinates: coordinates)
    }
    
    func removeAnnotations() {
        
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
    }
}

// MARK: Search completer

extension LocationDetailsViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.searchSuggestions = []
        for res in completer.results {
            self.searchSuggestions.append(res.title)
        }
        self.dropDown.dataSource = self.searchSuggestions
    }
    
    private func completer(completer: MKLocalSearchCompleter, didFailWithError error: NSError) {
        #warning("Handle error")
    }
}

// MARK: Text field manager

extension LocationDetailsViewController {
    
    @objc func shouldShowDropDown() {
        if let locationInput = locationTextField.text {
            if(locationInput.count >= 3) {
                dropDown.show()
                searchCompleter.queryFragment = locationInput
            } else {
                dropDown.hide()
                self.searchSuggestions = []
            }
        }
        
    }
}

// MARK: DropDown Selection

extension LocationDetailsViewController {

    func dropDownValueSelected(selected: String) {
        
        self.locationTextField.text = selected
        self.geoCoder.geocodeAddressString(selected) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                return
            }
            self.zoomMap(lat: location.coordinate.latitude, lon: location.coordinate.longitude, setMapPoint: true)
        }
    }
}

// MARK: Gesture Recognizer delegate

extension LocationDetailsViewController: UIGestureRecognizerDelegate {
    
    @objc func longTap(gestureRecognizer: UILongPressGestureRecognizer) {
        
        let location = gestureRecognizer.location(in: self.mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: self.mapView)
        self.addMapPointAnnotation(lat: coordinate.latitude, lon: coordinate.longitude)
        let coordinates = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geoDecodeFromCoordinates(locationCoordinates: coordinates)
    }
}

// MARK: Geo coder

extension LocationDetailsViewController {
    
    func geoDecodeFromCoordinates(locationCoordinates cords: CLLocation) {
        
        geoCoder.reverseGeocodeLocation(cords) { (placemark, error) in
            guard
                let loc = placemark?.first,
                let locationName = loc.name,
                let latitude = loc.location?.coordinate.latitude,
                let longitude = loc.location?.coordinate.longitude
            else { return }
            self.saveLocationData(locationName: locationName, latitude: latitude, longitude: longitude)
        }
    }
}

// MARK: Location details manager

extension LocationDetailsViewController {
    
    func saveLocationData(locationName name: String, latitude lat: CLLocationDegrees, longitude lon: CLLocationDegrees) {
        
        self.locationDetails = LocationDetails(locationName: name, latitude: lat, longitude: lon)
        print(self.locationDetails)
        #warning("Handle location details struct")
    }
}

// MARK: - viewDidLoad Setups

private extension LocationDetailsViewController {
    
    func setupLocationTextField() {
     
        locationTextField.clearButtonMode = .whileEditing
        locationTextField.clearsOnBeginEditing = true
        locationTextField.addTarget(self, action: #selector(shouldShowDropDown), for: .allEvents)
    }
    
    func setupDropDown() {
        
        dropDown.anchorView = locationTextField
        if let bounds = dropDown.anchorView?.plainView.bounds.height {
            dropDown.bottomOffset = CGPoint(x: 0, y: (bounds))
            dropDown.selectionAction = { (index: Int, item: String) in
                self.dropDownValueSelected(selected: item)
            }
        }
    }
    
    func setupMapGestureRecognizer() {
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(longTap))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    func setupLocationManager() {
        
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
    }
}
