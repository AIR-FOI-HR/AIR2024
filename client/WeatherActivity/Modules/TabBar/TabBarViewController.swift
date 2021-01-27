//
//  TabBarViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 21.01.2021..
//

import UIKit

final class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: Properties
    
    private let newActivityIndex = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.tintColor = UIColor(named: "CustomMainButton")
        
        let navigationController = initNavigationController()
        self.viewControllers?.insert(navigationController, at: newActivityIndex)
    }
    
    // MARK: Tab Bar handling
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == newActivityIndex {
            self.viewControllers?[newActivityIndex] = initNavigationController()
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let transitionFrom = selectedViewController?.view, let transitionTo = viewController.view else {
            return false
        }
        if transitionFrom != transitionTo {
            UIView.transition(from: transitionFrom, to: transitionTo, duration: 0.25, options: [.transitionCrossDissolve], completion: nil)
        }
        return true
    }
    
    // MARK: Custom methods
    
    private func initNavigationController()  -> UINavigationController{
        let navigationController = UINavigationController()
        let steps: [StepInfo] = [.locationDetails, .timeDetails, .categoriesDetails, .finalDetails]
        
        let flowNavigator = AddActivityFlowNavigator(navigationController: navigationController, steps: steps)
        let storyboard = UIStoryboard(name: flowNavigator.initialStep.rawValue, bundle: nil)
        guard
            let stepViewController = storyboard.instantiateViewController(identifier: flowNavigator.initialStep.rawValue) as? AddActivityStepViewController
        else { fatalError() }
        stepViewController.flowNavigator = flowNavigator
        navigationController.viewControllers = [stepViewController]
        return navigationController
    }
}
