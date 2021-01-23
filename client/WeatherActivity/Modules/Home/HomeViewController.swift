//
//  HomeViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 23.11.2020..
//

import UIKit
import WidgetKit

enum HomeNavigation: String {
    case login = "HomeToLogin"
    case search = "toSearchActivities"
    case calendar = "toCalendar"
}

class HomeViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak private var activitiesContainerView: UIStackView!
    @IBOutlet weak private var weatherTypeLabel: UILabel!
    @IBOutlet weak private var temperatureLabel: UILabel!
    @IBOutlet weak private var temperatureFeelsLabel: UILabel!
    @IBOutlet weak private var windLabel: UILabel!
    @IBOutlet weak private var humidityLabel: UILabel!
    @IBOutlet weak private var todaysDescription: UILabel!
    @IBOutlet weak private var weatherTypeImageView: UIImageView!
    @IBOutlet weak private var helloNameLabel: UILabel!
    @IBOutlet weak private var avatarImageView: UIImageView!
    
    // MARK: Properties
    
    private var activityListView: ActivityListView!
    private let activityService = ActivityService()
    private let forecastService = ForecastService()
    private let forecastData = ForecastData()
    private let dummyLocation = LocationDetails(locationName: "Varaždin", latitude: 46.306268, longitude: 16.336089)
    private var activitiesList: [ActivityCellItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerSetUp()
        setupListView()
        getTodaysForecast()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadActivities()
        print("home will appear")
    }
    
    // MARK: Custom functions
    
    private func getCurrentTimeStamp() -> String {
        let currentDateTime = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let currentTimeStamp = dateFormatter.string(from: currentDateTime)
        return currentTimeStamp
    }
    
    private func headerSetUp() {
        helloNameLabel.text = "Hello " + UserDefaultsManager.shared.getUserDefaultString(key: .userName)
        avatarImageView.image = UIImage(named: UserDefaultsManager.shared.getUserDefaultString(key: .userAvatar))
    }
    
    private func setupListView() {
        let listView = ActivityListView.loadFromXib()
        listView.delegate = self
        activitiesContainerView.addArrangedSubview(listView)
        activityListView = listView
    }
    
    func loadActivities() {
        if activitiesList.isEmpty {
            activityListView.setState(state: .loading)
        } else {
            activitiesList = []
        }
        if let sessionToken = SessionManager.shared.getToken() {
            activityService.getActivities(for: "home", token: sessionToken, success: { (activities) in
                if activities.isEmpty {
                    self.activityListView.setState(state: .noActivities)
                }
                else {
                    for activity in activities {
                        self.activitiesList.append(.init(activityId: activity.activityId, startTime: activity.startTime, endTime: activity.endTime, title: activity.title, description: activity.description, locationName: activity.locationName, latitude: activity.latitude, longitude: activity.longitude, temperature: activity.temperature, feelsLike: activity.feelsLike, wind: activity.wind, humidity: activity.humidity, forecastType: activity.forecastType, name: activity.name, type: activity.type, statusType: activity.statusType))
                    }
                    self.activityListView.setState(state: .normal(items: self.activitiesList))
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
        SessionManager.shared.deleteToken()
        WidgetCenter.shared.reloadAllTimelines()
        navigate(to: .login)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        navigate(to: .search)
        return false
    }
}

private extension HomeViewController {
    func navigate(to path: HomeNavigation) {
        performSegue(withIdentifier: path.rawValue, sender: self)
    }
    
    func openActivityFlow(isEditing: Bool = false, activity: ActivityCellItem?) {
        let navigationController = UINavigationController()
        let steps: [StepInfo] = [.locationDetails, .timeDetails, .categoriesDetails, .finalDetails]
        
        let flowNavigator = AddActivityFlowNavigator(navigationController: navigationController, steps: steps)
        
        flowNavigator.presentFlow(from: self)
        
        flowNavigator.isEditing = isEditing
        flowNavigator.editingActivity = activity
        
        flowNavigator.delegate = self
    }
}

extension HomeViewController: ActivityListViewDelegate, ActivityDetailsViewControllerDelegate, AddActivityFlowNavigatorDelegate {
    func didPressRow(activity: ActivityCellItem) {
        let details = ActivityDetailsViewController(nibName: "ActivityDetailsViewController", bundle: nil)
        details.commonInit(activity: activity)
        self.present(details, animated: true, completion: nil)
        details.delegate = self
    }
    
    func didPressReloadAction() {
        loadActivities()
    }
    
    func didDeleteActivity(deletedActivity: Int) {
        guard let index = activitiesList.firstIndex(where: { $0.activityId == deletedActivity }) else {
            return
        }
        activitiesList.remove(at: index)
        self.activityListView.setState(state: .normal(items: self.activitiesList))
    }
    
    func didEditActivity(activity: ActivityCellItem) {
        openActivityFlow(isEditing: true, activity: activity)
    }
    
    func didFinishFlow() {
        loadActivities()
    }
}

extension HomeViewController {
    
    func getTodaysForecast() {
        
        forecastService.getWeatherForecast(date: Date(), locationCoordinates: dummyLocation) { (weatherInfo) in
            guard
                let weatherList = weatherInfo.weatherList,
                let temperatureForecast = weatherList.first?.main?.temp?.rounded(.up),
                let temperatureFeelsLikeForecast = weatherList.first?.main?.feelsLike?.rounded(.up),
                let windForecast = weatherList.first?.wind?.speed?.rounded(.up),
                let humidityForecast = weatherList.first?.main?.humidity,
                let dataForecast = weatherList.first?.weather,
                let condition = dataForecast.first?.id,
                let forecastDescription = dataForecast.first?.weatherDescription
            else { return }
            
            self.weatherTypeLabel.text = "\(forecastDescription.prefix(1).capitalized)\(forecastDescription.dropFirst())"
            self.temperatureLabel.text = "\(Int(temperatureForecast)) °C"
            self.temperatureFeelsLabel.text = "\(Int(temperatureFeelsLikeForecast)) °C"
            self.windLabel.text = "\(Int(windForecast)) km/h"
            self.humidityLabel.text = "\(humidityForecast) %"
            self.weatherTypeImageView.image = UIImage(systemName: self.forecastData.getConditionImage(id: condition))
            self.todaysDescription.text = "\(forecastDescription.prefix(1).capitalized)\(forecastDescription.dropFirst()), with temperature: \(Int(temperatureForecast)) °C"
        } failure: { (error) in
            print(error)
        }
    }
}
