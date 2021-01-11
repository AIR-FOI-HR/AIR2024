//
//  SecondInitialScreenViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 03.01.2021..
//

import UIKit

enum SecondInitialScreenNavigation: String {
    case login = "toLogin"
    case next = "toThirdInitialScreen"
}

final class SecondInitialScreenViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak private var skipButton: UIButton!
    @IBOutlet weak private var nextButton: UIButton!
    
    @IBAction func onSkipClick(_ sender: UIButton) {
        UserDefaultsManager.shared.saveUserDefault(value: true, key: .firstTime)
        navigate(to: .login)
    }
    
    @IBAction func onNextClick(_ sender: UIButton) {
        navigate(to: .next)
    }
}

private extension SecondInitialScreenViewController {
    func navigate(to path: SecondInitialScreenNavigation) {
        performSegue(withIdentifier: path.rawValue, sender: self)
    }
}
