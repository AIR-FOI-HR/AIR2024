//
//  LocationChecker.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 26.01.2021..
//

import UIKit
import CoreLocation

enum LocationPermissions: String {
    case never = "Never"
    case notAllowed = "NotAllowed"
    case allowed = "Allowed"
}

struct LocationChecker {
    
    let locationManager = CLLocationManager()
    
    func checkLocationPermission() -> LocationPermissions {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted:
                return LocationPermissions.notAllowed
            case .denied:
                return LocationPermissions.never
            case .authorizedAlways, .authorizedWhenInUse:
                return LocationPermissions.allowed
            default:
                return LocationPermissions.notAllowed
            }
        }
        else {
            return LocationPermissions.never
        }
    }
}
