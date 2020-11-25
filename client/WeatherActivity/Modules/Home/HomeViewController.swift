//
//  HomeViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 23.11.2020..
//

import UIKit

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Asd.kev/dev")
    }
    
    
    @IBAction func backSwipe(_ sender: UISwipeGestureRecognizer) {
        
        if sender.state == .ended {
            print("Performing back swipe - Left")
            dismiss(animated: true, completion: nil)
//            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    
//    @IBAction func backSwipe(_ sender: UIScreenEdgePanGestureRecognizer) {
//        if (sender.state == UIGestureRecognizer.State.ended) {
//            print("haha idemo zapalit")
//        }
//    }
}
