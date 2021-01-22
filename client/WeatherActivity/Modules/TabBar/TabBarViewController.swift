//
//  TabBarViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 21.01.2021..
//

import UIKit


final class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.tintColor = UIColor(named: "CustomMainButton")
    
        let navigationController = initNavigationController()
        self.viewControllers?.append(navigationController)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 3 {
            self.viewControllers?[3] = initNavigationController()
        }
    }

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
