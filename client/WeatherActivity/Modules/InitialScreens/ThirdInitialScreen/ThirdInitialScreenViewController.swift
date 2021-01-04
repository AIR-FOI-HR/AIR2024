//
//  ThirdInitialScreenViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 03.01.2021..
//

import UIKit

enum ThirdInitialScreenNavigation: String {
    case login = "toLogin"
}

final class ThirdInitialScreenViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak private var getStartedButton: UIButton!
    
    @IBAction func onButtonClick(_ sender: UIButton) {
        UserDefaultsManager.shared.saveUserDefault(value: true, key: .firstTime)
        navigate(to: .login)
    }
}

private extension ThirdInitialScreenViewController {
    func navigate(to path: ThirdInitialScreenNavigation) {
        performSegue(withIdentifier: path.rawValue, sender: self)
    }
}
