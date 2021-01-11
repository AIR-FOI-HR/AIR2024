//
//  HomeViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 23.11.2020..
//

import UIKit

enum HomeNavigation: String {
    case login = "HomeToLogin"
    case search = "toSearchActivities"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerSetUp()
        setupListView()
        loadActivities()
        getTodaysForecast()
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
        activityListView.setState(state: .loading)
        let currentTime = getCurrentTimeStamp()
        var activitiesList: [ActivityCellItem] = []
        if let sessionToken = SessionManager.shared.getToken() {
            activityService.getActivities(token: sessionToken, success: { (activities) in
                if activities.isEmpty {
                    self.activityListView.setState(state: .noActivities)
                }
                else {
                    for activity in activities {
                        if activity.startTime > currentTime {
                            activitiesList.append(.init(activityId: activity.activityId, startTime: activity.startTime, endTime: activity.endTime, title: activity.title, description: activity.description, locationName: activity.locationName, latitude: activity.latitude, longitude: activity.longitude, temperature: activity.temperature, feelsLike: activity.feelsLike, wind: activity.wind, humidity: activity.humidity, forecastType: activity.forecastType, name: activity.name, type: activity.type, statusType: activity.statusType))
                        }
                    }
                    if activitiesList.isEmpty {
                        self.activityListView.setState(state: .noActivities)
                    } else {
                        self.activityListView.setState(state: .normal(items: activitiesList))
                    }
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
        navigate(to: .login)
    }
    
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        navigate(to: .search)
    }
}

private extension HomeViewController {
    func navigate(to path: HomeNavigation) {
        performSegue(withIdentifier: path.rawValue, sender: self)
    }
    
    @IBAction func addActivityButtonPressed(_ sender: UIButton) {
        
        let navigationController = UINavigationController()
        let steps: [StepInfo] = [.locationDetails, .timeDetails, .categoriesDetails, .finalDetails]
        
        let flowNavigator = AddActivityFlowNavigator(navigationController: navigationController, steps: steps)
        
        flowNavigator.presentFlow(from: self)
        
        flowNavigator.delegate = self
    }
}

extension HomeViewController: ActivityListViewDelegate {
    func didPressRow(activity: ActivityCellItem) {
        let details = ActivityDetailsViewController(nibName: "ActivityDetailsViewController", bundle: nil)
        details.commonInit(activity: activity)
        self.present(details, animated: true, completion: nil)
    }
    
    func didPressReloadAction() {
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
            self.temperatureLabel.text = "\(Int(temperatureForecast)) ° C"
            self.temperatureFeelsLabel.text = "\(Int(temperatureFeelsLikeForecast)) ° C"
            self.windLabel.text = "\(Int(windForecast)) km/h"
            self.humidityLabel.text = "\(humidityForecast) %"
            self.weatherTypeImageView.image = UIImage(systemName: self.forecastData.getConditionImage(id: condition))
            self.todaysDescription.text = "\(forecastDescription.prefix(1).capitalized)\(forecastDescription.dropFirst()), with temperature: \(Int(temperatureForecast)) ° C"
        } failure: { (error) in
            print(error)
        }
    }
}

extension HomeViewController: AddActivityFlowNavigatorDelegate {
    func didFinishInsert() {
        loadActivities()
    }
}
