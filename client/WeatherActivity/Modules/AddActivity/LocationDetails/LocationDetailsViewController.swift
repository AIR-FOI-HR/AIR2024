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

class LocationDetailsViewController: AddActivityStepViewController {
    
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
    let locationChecker = LocationChecker()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        searchCompleter.delegate = self
        setupLocationTextField()
        setupMapGestureRecognizer()
        setupLocationManager()
        setupDropDown()
        
        guard
            let flowNavigator = flowNavigator
        else { return }
        
        if flowNavigator.isEditing {
            guard
                let activityDetails = flowNavigator.editingActivity
            else { return }
            zoomMap(lat: activityDetails.latitude, lon: activityDetails.longitude, setMapPoint: true)
        }
    }
    
    // MARK: IBActions
    
    @IBAction func currentLocationPressed(_ sender: UIButton) {
        
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        guard
            let flowNavigator = flowNavigator
        else { return }
        flowNavigator.showNextStep(
            from: .locationDetails,
            data: StepData(
                stepInfo: .locationDetails,
                data: locationDetails
            )
        )
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
            self.locationTextField.text = locationName
            self.saveLocationData(locationName: locationName, latitude: latitude, longitude: longitude)
        }
    }
}

// MARK: Location details manager

extension LocationDetailsViewController {
    
    func saveLocationData(locationName name: String, latitude lat: CLLocationDegrees, longitude lon: CLLocationDegrees) {
        
        self.locationDetails = LocationDetails(locationName: name, latitude: lat, longitude: lon)
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
        let locationPermissionStatus = locationChecker.checkLocationPermission()
        
        switch(locationPermissionStatus) {
        case .never:
            let alertVC = UIAlertController(title: "Geolocation is not enabled", message: "For using geolocation you need to enable it in Settings", preferredStyle: .actionSheet)
            alertVC.addAction(UIAlertAction(title: "Open Settings", style: .default) { value in
                let path = UIApplication.openSettingsURLString
                if let settingsURL = URL(string: path), UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.canOpenURL(settingsURL)
                }
            })
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
            self.present(alertVC, animated: true, completion: nil)
        case .notAllowed:
            locationManager.requestWhenInUseAuthorization()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.requestLocation()
        
        guard
            let flowNavigator = flowNavigator
        else { return }
        if !flowNavigator.isEditing {
            locationManager.requestLocation()
        }
    }
}

