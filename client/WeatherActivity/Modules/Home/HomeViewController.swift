//
//  HomeViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 23.11.2020..
//

import UIKit

enum HomeNavigation: String {
    case login = "toHome"
}

final class HomeViewController: UIViewController {
    
    @IBAction func backSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        SessionManager.shared.deleteToken()
        navigate(to: .login)
    }
}

private extension HomeViewController {
    func navigate(to path: HomeNavigation) {
        performSegue(withIdentifier: path.rawValue, sender: self)
    }
}
