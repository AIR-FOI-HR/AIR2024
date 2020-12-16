//
//  HomeViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 23.11.2020..
//

import UIKit
import KeychainSwift

final class HomeViewController: UIViewController {
    
    let nc = UINavigationController()
    
    let keychain = KeychainSwift()
    @IBAction func backSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nc.interactivePopGestureRecognizer?.isEnabled = false
        nc.navigationBar.isHidden = true
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        keychain.delete("sessionToken")
        self.performSegue(withIdentifier: "HomeToLogin", sender: self)
    }
    
    @IBAction func addActivityButtonPressed(_ sender: UIButton) {
    
        let timeDetailsStoryboard = UIStoryboard(name: "TimeDetails", bundle: nil)
        let viewController = timeDetailsStoryboard.instantiateViewController(identifier: "TimeDetails")
        
        nc.pushViewController(viewController, animated: true)
        self.present(nc, animated: true, completion: nil)
        nc.dismiss(animated: true, completion: nil)
    }
    
}
