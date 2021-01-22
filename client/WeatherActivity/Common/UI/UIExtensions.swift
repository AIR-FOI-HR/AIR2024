//
//  UIExtensions.swift
//  WeatherActivity
//
//  Created by Infinum on 26.11.2020..
//

import UIKit

// MARK: - Text field handling

extension UIViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension UIViewController {
    static func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController,
           let selected = tabController.selectedViewController {
            return topViewController(controller: selected)
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UIViewController {
    func showActivityDetails(withId id: Int) {
        let details = ActivityDetailsViewController(nibName: "ActivityDetailsViewController", bundle: nil)
        self.present(details, animated: true, completion: nil)
        details.showSkeleton()
        
        ActivityService().getWidgetActivityDetails(activity: id, success: { activity in
            var pActivity: ActivityCellItemP
            switch(activity.statusType) {
            case .inProgress:
                pActivity = InProgressActivityCellItem(activityId: activity.activityId, startTime: activity.startTime, endTime: activity.endTime, title: activity.title, description: activity.description, locationName: activity.locationName, latitude: activity.latitude, longitude: activity.longitude, temperature: activity.temperature, feelsLike: activity.feelsLike, wind: activity.wind, humidity: activity.humidity, forecastType: activity.forecastType, name: activity.name, type: activity.type, statusType: activity.statusType.rawValue)
                break;
            default:
                pActivity = DefaultActivityCellItem(activityId: activity.activityId, startTime: activity.startTime, endTime: activity.endTime, title: activity.title, description: activity.description, locationName: activity.locationName, latitude: activity.latitude, longitude: activity.longitude, temperature: activity.temperature, feelsLike: activity.feelsLike, wind: activity.wind, humidity: activity.humidity, forecastType: activity.forecastType, name: activity.name, type: activity.type, statusType: activity.statusType.rawValue)
            }
            print("P ACTIVITY HOME: ", pActivity)
            let fetchedActivity = pActivity
            details.widgetInit(activity: fetchedActivity)
        }, failure: { error in
            print(error)
        })
    }
    
    func openAddActivityFlow(topViewController: UIViewController, isEditing: Bool = false, activity: ActivityCellItemP?) {
        let navigationController = UINavigationController()
        let steps: [StepInfo] = [.locationDetails, .timeDetails, .categoriesDetails, .finalDetails]
        
        let flowNavigator = AddActivityFlowNavigator(navigationController: navigationController, steps: steps)
        
        flowNavigator.presentFlow(from: self)
        
        flowNavigator.isEditing = isEditing
        flowNavigator.editingActivity = activity
    }
}
