//
//  UIViewController+Alert.swift
//  WeatherActivity
//
//  Created by Infinum on 30.11.2020..
//

import UIKit

extension UIViewController {
    
    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
        let subview = (alertController.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.layer.cornerRadius = 5
        switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                subview.backgroundColor = UIColor(red: (245/255.0), green: (245/255.0), blue: (245/255.0), alpha: 1.0)
            case .dark:
                subview.backgroundColor = UIColor(red: (75/255.0), green: (100/255.0), blue: (120/255.0), alpha: 1.0)
            @unknown default:
                subview.backgroundColor = UIColor(red: (245/255.0), green: (245/255.0), blue: (245/255.0), alpha: 1.0)
        }
    }
    
    func presentAlertMessage(title: String, message: String, length: Double) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alertController, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + length) {
                alertController.dismiss(animated: true, completion: nil)
            }
        }
        let subview = (alertController.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.layer.cornerRadius = 5
        switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                subview.backgroundColor = UIColor(red: (245/255.0), green: (245/255.0), blue: (245/255.0), alpha: 1.0)
            case .dark:
                subview.backgroundColor = UIColor(red: (75/255.0), green: (100/255.0), blue: (120/255.0), alpha: 1.0)
            @unknown default:
                subview.backgroundColor = UIColor(red: (245/255.0), green: (245/255.0), blue: (245/255.0), alpha: 1.0)
        }
    }
}
