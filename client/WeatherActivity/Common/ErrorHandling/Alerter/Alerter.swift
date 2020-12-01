//
//  Alerter.swift
//  WeatherActivity
//
//  Created by Infinum on 30.11.2020..
//

import Foundation
import UIKit

class Alerter {
    
    // MARK: Properties
    
    var alerter: UIAlertController
    
    init(title: String = "Oops!", message: String = "Something has gone wrong"){
        self.alerter = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    }

    func addAction(title: String){
        self.alerter.addAction(UIAlertAction(title: title, style: .default, handler: { (_) in
            self.alerter.dismiss(animated: true, completion: nil)
        }))
    }
    
    func setAlerterData(title: String, message: String){
        self.alerter.title = title
        self.alerter.message = message
    }
}
