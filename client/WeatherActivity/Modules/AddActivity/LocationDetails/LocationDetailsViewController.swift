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
import CHDropDownTextField

class LocationDetailsViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationTextField: CHDropDownTextField!
    
    
    // MARK: Properties
    
    var locationManager = CLLocationManager()
    var searchCompleter = MKLocalSearchCompleter()
    var searchSuggestions = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCompleter.delegate = self
        
        locationTextField.addTarget(self, action: #selector(textFieldDidChangeValue), for: .editingChanged)
        
        locationTextField.dropDownTableVisibleRowCount = 3
        locationTextField.dropDownDelegate = self
        
        
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: IBActions
    
    @IBAction func currentLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

// MARK: CLLocationManagerDelegate

extension LocationDetailsViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
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
        let mapPoint: MKPointAnnotation = MKPointAnnotation()
        mapPoint.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        mapView.addAnnotation(mapPoint)
    }
}

// MARK: Search completer

extension LocationDetailsViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        for res in completer.results {
            self.searchSuggestions.append(res.title)
        }
        self.locationTextField.dropDownTableTitlesArray = self.searchSuggestions
    }
    
    private func completer(completer: MKLocalSearchCompleter, didFailWithError error: NSError) {
        print("NOPE")
        #warning("Handle error")
    }
}

// MARK: Text field manager

extension LocationDetailsViewController {
    
    @objc func textFieldDidChangeValue() {
        if(locationTextField.text!.count > 3) {
            searchCompleter.queryFragment = locationTextField.text!
        }
    }
}

// MARK: CHDropDown delegate

extension LocationDetailsViewController: CHDropDownTextFieldDelegate {
    
    func dropDownTextField(_ dropDownTextField: CHDropDownTextField!, didChooseDropDownOptionAt index: UInt) {
        self.locationTextField.text = self.searchSuggestions[Int(index)]
    }
}
