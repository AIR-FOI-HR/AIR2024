//
//  HomeViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 23.11.2020..
//

import UIKit

final class HomeViewController: UIViewController {
    @IBAction func backSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            dismiss(animated: true, completion: nil)
        }
    }
}
