//
//  HomeViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 23.11.2020..
//

import UIKit
import KeychainSwift

class HomeViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet private var activitiesContainerView: UIStackView!
    
    // MARK: Properties
    
    private var activityListView: ActivityListView!
    private let activityService = ActivityService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupListView()
        loadActivities()
    }
    
    // MARK: Custom functions
    
    private func setupListView() {
        let listView = ActivityListView.loadFromXib()
        listView.delegate = self
        activitiesContainerView.addArrangedSubview(listView)
        activityListView = listView
    }
    
    func loadActivities() {
        activityListView.setState(state: .loading)
        var activitiesList: [ActivityCellItem] = []
        if let sessionToken = SessionManager.shared.getToken() {
            activityService.getActivities(token: sessionToken, success: { (activities) in
                if activities.isEmpty {
                    self.activityListView.setState(state: .noActivities)
                }
                else {
                    for activity in activities {
                        activitiesList.append(.init(activityId: activity.activityId, startTime: activity.startTime, endTime: activity.endTime, title: activity.title, description: activity.description, locationName: activity.locationName, forecastId: activity.forecastId, categoryId: activity.categoryId, activityStatusId: activity.activityStatusId))
                    }
                    self.activityListView.setState(state: .normal(items: activitiesList))
                }
            }, failure: { error in
                self.activityListView.setState(state: .error)
            })
        } else {
            self.activityListView.setState(state: .error)
        }
    }
    
    // MARK: IBActions
    
    @IBAction func backSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        KeychainSwift().delete("sessionToken")
        self.performSegue(withIdentifier: "HomeToLogin", sender: self)
    }
    
    @IBAction func addActivityButtonPressed(_ sender: UIButton) {
        
        let navigationController = UINavigationController()
        let steps: [StepInfo] = [.locationDetails, .timeDetails, .categoryDetails, .finalDetails]
        
        let flowNavigator = AddActivityFlowNavigator(navigationController: navigationController, steps: steps)
        
        flowNavigator.presentFlow(from: self)
        
    }
    
}

extension HomeViewController: ActivityListViewDelegate {
    func didPressReloadAction() {
        loadActivities()
    }
}
