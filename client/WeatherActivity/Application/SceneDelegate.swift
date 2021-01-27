//
//  SceneDelegate.swift
//  WeatherActivity
//
//  Created by Infinum on 16.11.2020..
//

import UIKit
import CoreLocation

enum initialStoryboard: String {
    case home = "Home"
    case login = "Login"
    case firstInitialScreen = "FirstInitialScreen"
    case tabBar = "TabBar"
}

enum initialViewController: String {
    case home = "HomeViewController"
    case login = "LoginViewController"
    case firstInitialScreen = "FirstInitialScreenViewController"
    case tabBar = "TabBarViewController"
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let loginService = LoginService()
    var locationManager = CLLocationManager()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if !UserDefaultsManager.shared.getUserDefaultBool(key: .firstTime) {
            self.setupInitialStoryboard(storyboard: .firstInitialScreen, viewContoller: .firstInitialScreen)
        } else {
            if let sessionToken = SessionManager.shared.getStringFromKeychain(key: .sessionToken) {
                loginService.checkForToken(token: sessionToken, success: { checkResponse in
                    self.setupInitialStoryboard(storyboard: .tabBar, viewContoller: .tabBar)
                    let contexts = connectionOptions.urlContexts
                    self.handleDeepLink(url: contexts)
                }, failure: { error in
                    self.setupInitialStoryboard(storyboard: .login, viewContoller: .login)
                })
            } else {
                self.setupInitialStoryboard(storyboard: .login, viewContoller: .login)
            }
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        handleDeepLink(url: URLContexts)
    }
}

extension SceneDelegate {
    func setupInitialStoryboard(storyboard: initialStoryboard, viewContoller: initialViewController) {
        self.window?.rootViewController = UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateViewController(identifier: viewContoller.rawValue)
        self.window?.makeKeyAndVisible()
    }
    
    func handleDeepLink(url: Set<UIOpenURLContext>) {
        guard
            let widgetUrl = url.first(where: { $0.url.absoluteString.contains(Constants.widgetURLScheme) })?.url.host?.removingPercentEncoding,
            let topViewController = UIViewController.topViewController(),
            let tabBarController = topViewController.tabBarController
        else { return }
        
        if widgetUrl == "add" {
            tabBarController.selectedIndex = 2
        } else if !widgetUrl.isEmpty {
            tabBarController.selectedIndex = 0
            guard
                let homeVC = tabBarController.selectedViewController as? HomeViewController,
                let activityId = Int(widgetUrl)
            else { return }
            homeVC.openActivityDetails(id: activityId)
        }
    }
}
