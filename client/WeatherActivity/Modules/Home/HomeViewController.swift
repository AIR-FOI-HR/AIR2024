//
//  HomeViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 23.11.2020..
//

import UIKit
import KeychainSwift

final class HomeViewController: UIViewController {
    
    let keychain = KeychainSwift()
    @IBAction func backSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        keychain.delete("sessionToken")
        self.performSegue(withIdentifier: "HomeToLogin", sender: self)
    }
    
    @IBAction func addActivityButtonPressed(_ sender: UIButton) {
        
        let navigationController = UINavigationController()
        let steps: [StepInfo] = [.locationDetails, .timeDetails, .categoryDetails, .finalDetails]
        
        let flowNavigator = AddActivityFlowNavigator(navigationController: navigationController, steps: steps)
        
        flowNavigator.presentFlow(from: self)
        
    }
    
}
