//
//  HomeViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 23.11.2020..
//

import UIKit
import WidgetKit
import CoreLocation

class HomeViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak private var mainView: UIView!
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
    @IBOutlet weak private var weatherForecastView: UIStackView!
    @IBOutlet weak private var weatherForecastMessage: UILabel!
    @IBOutlet weak private var weatherDescriptionLabel: UILabel!
    
    // MARK: Properties
    
    private var activityListView: ActivityListView!
    private let activityService = ActivityService()
    private let forecastService = ForecastService()
    private let userService = UserService()
    private let forecastData = ForecastData()
    private var currentLocation: LocationDetails?
    private var activitiesList: [ActivityCellItemProtocol] = []
    private var activityItemHelper = ActivityItemHelper()
    private var locationManager = CLLocationManager()
    private var locationChecker = LocationChecker()
    
    private let dummyLocation = LocationDetails(locationName: "Varaždin", latitude: 46.306268, longitude: 16.336089)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupListView()
        getTodaysForecast()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserData()
        loadActivities()
    }
    
    // MARK: Custom functions
    
    private func setupListView() {
        let listView = ActivityListView.loadFromXib()
        listView.delegate = self
        activitiesContainerView.addArrangedSubview(listView)
        activityListView = listView
    }
    
    private func getUserData() {
        mainView.showAnimatedGradientSkeleton()
        userService.getUserHomeData(success: { data in
            self.helloNameLabel.text = "Hello " + data.firstName
            self.avatarImageView.image = UIImage(named: data.avatarName)
            self.mainView.hideSkeleton()
        }, failure: { error in
            print(error)
        })
    }
    
    func loadActivities() {
        if activitiesList.isEmpty {
            activityListView.setState(state: .loading)
        } else {
            activitiesList = []
        }
        if let sessionToken = SessionManager.shared.getStringFromKeychain(key: .sessionToken) {
            activityService.getActivities(for: "home", token: sessionToken, success: { (activities) in
                if activities.isEmpty {
                    self.activityListView.setState(state: .noActivities)
                }
                else {
                    let activityItems = self.activityItemHelper.getActivityCellItems(activities: activities)
                    self.activitiesList = activityItems
                    self.activityListView.setState(state: .normal(items: self.activitiesList))
                }
            }, failure: { error in
                self.activityListView.setState(state: .error)
            })
        } else {
            self.activityListView.setState(state: .error)
        }
    }
    
    func openActivityDetails(id: Int) {
        let details = ActivityDetailsViewController(nibName: "ActivityDetailsViewController", bundle: nil)
        self.present(details, animated: true, completion: nil)
        details.showSkeleton()
        
        ActivityService().getWidgetActivityDetails(activity: id, success: { activity in
            let fetchedActivity = DefaultActivityCellItem(activityId: activity.activityId, startTime: activity.startTime, endTime: activity.endTime, title: activity.title, description: activity.description, locationName: activity.locationName, latitude: activity.latitude, longitude: activity.longitude, temperature: activity.temperature, feelsLike: activity.feelsLike, wind: activity.wind, humidity: activity.humidity, forecastType: activity.forecastType, name: activity.name, type: activity.type, statusType: activity.statusType, color: UIColor.red)
            details.widgetInit(activity: fetchedActivity)
        }, failure: { error in
            print(error)
        })
        details.delegate = self
    }
}

private extension HomeViewController {
    @IBAction func addActivityButtonPressed(_ sender: UIButton) {
        openActivityFlow(activity: nil)
    }
    
    func openActivityFlow(isEditing: Bool = false, activity: ActivityCellItemProtocol?) {
        let navigationController = UINavigationController()
        let steps: [StepInfo] = [.locationDetails, .timeDetails, .categoriesDetails, .finalDetails]
        
        let flowNavigator = AddActivityFlowNavigator(navigationController: navigationController, steps: steps)
        
        flowNavigator.presentFlow(from: self)
        
        flowNavigator.isEditing = isEditing
        flowNavigator.editingActivity = activity
        
        flowNavigator.delegate = self
    }
}

// MARK: Protocols

extension HomeViewController: ActivityListViewDelegate, ActivityDetailsViewControllerDelegate, AddActivityFlowNavigatorDelegate {
    func didPressRow(activity: ActivityCellItemProtocol) {
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
        if activitiesList.isEmpty {
            self.activityListView.setState(state: .noActivities)
        } else {
            self.activityListView.setState(state: .normal(items: self.activitiesList))
        }
    }
    
    func didEditActivity(activity: ActivityCellItemProtocol) {
        openActivityFlow(isEditing: true, activity: activity)
    }
    
    func didFinishFlow() {
        loadActivities()
    }
}

extension HomeViewController {
    func getTodaysForecast() {
        guard
            let location = currentLocation
        else {
            print("Cant get location")
            return
        }
        forecastService.getWeatherForecast(date: Date(), locationCoordinates: location) { (weatherInfo) in
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

// MARK: CLLocationManagerDelegate

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.locationManager.stopUpdatingLocation()
            currentLocation = LocationDetails(locationName: "", latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            print("CURR LOC: ", currentLocation!.latitude)
            
            weatherForecastView.isHidden = false
            weatherDescriptionLabel.isHidden = false
            getTodaysForecast()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        #warning("Handle error")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
          case .restricted, .denied:
            weatherForecastView.isHidden = true
            weatherDescriptionLabel.isHidden = true
            setupLocation()
          case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
          case .notDetermined:
             setupLocation()
       }
    }
    
    func setupLocation() {
        locationManager.delegate = self
        let locationPermissionStatus = locationChecker.checkLocationPermission()
        switch(locationPermissionStatus) {
        case .never:
            let alertVC = UIAlertController(title: "Geolocation is not enabled", message: "For using geolocation you need to enable it in Settings", preferredStyle: .actionSheet)
            alertVC.addAction(UIAlertAction(title: "Open Settings", style: .default) { value in
                let path = UIApplication.openSettingsURLString
                if let settingsURL = URL(string: path), UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.openURL(settingsURL)
                }
                
            })
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
            self.present(alertVC, animated: true, completion: nil)
            weatherForecastView.isHidden = true
            weatherDescriptionLabel.isHidden = true
        case .notAllowed:
            locationManager.requestWhenInUseAuthorization()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.requestLocation()
    }
}
