//
//  SceneDelegate.swift
//  WeatherActivity
//
//  Created by Infinum on 16.11.2020..
//

import UIKit

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
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if !UserDefaultsManager.shared.getUserDefaultBool(key: .firstTime) {
            self.setupInitialStoryboard(storyboard: .firstInitialScreen, viewContoller: .firstInitialScreen)
        } else {
            if let sessionToken = SessionManager.shared.getStringFromKeychain(key: .sessionToken) {
                loginService.checkForToken(token: sessionToken, success: { checkResponse in
                    if(checkResponse.sessionToken == true) {
                        self.setupInitialStoryboard(storyboard: .tabBar, viewContoller: .tabBar)
                        let contexts = connectionOptions.urlContexts
                        self.handleDeepLink(url: contexts)
                    } else {
                        self.setupInitialStoryboard(storyboard: .login, viewContoller: .login)
                    }
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
            let topViewController = UIViewController.topViewController()
        else { return }
        
        if widgetUrl == "add" {
            let viewController = window?.rootViewController as? TabBarViewController
            viewController?.selectedIndex = 2
        } else if !widgetUrl.isEmpty {
            guard let activityId = Int(widgetUrl) else { return }
            topViewController.showActivityDetails(withId: activityId)
        }
    }
}
