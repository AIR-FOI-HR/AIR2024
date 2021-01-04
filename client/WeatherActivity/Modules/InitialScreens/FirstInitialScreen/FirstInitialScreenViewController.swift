//
//  FirstInitialScreenViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 03.01.2021..
//

import UIKit

enum FirstInitialScreenNavigation: String {
    case login = "toLogin"
    case next = "toSecondInitialScreen"
}

final class FirstInitialScreenViewController: UIViewController {
    
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

private extension FirstInitialScreenViewController {
    func navigate(to path: FirstInitialScreenNavigation) {
        performSegue(withIdentifier: path.rawValue, sender: self)
    }
}
