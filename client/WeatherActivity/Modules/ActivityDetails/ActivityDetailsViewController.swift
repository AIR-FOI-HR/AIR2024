//
//  ActivityDetailsViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 18.12.2020..
//

import UIKit
import MapKit
import WidgetKit
import SkeletonView

protocol ActivityDetailsViewControllerDelegate: AnyObject {
    func didEditActivity(activity: ActivityCellItemProtocol)
    func didDeleteActivity(deletedActivity: Int)
}

class ActivityDetailsViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak private var mainView: UIView!
    @IBOutlet weak private var editButton: UIButton!
    @IBOutlet weak private var deleteButton: UIButton!
    @IBOutlet weak private var activityTitle: UILabel!
    @IBOutlet weak private var activityDate: UILabel!
    @IBOutlet weak private var activityTime: UILabel!
    @IBOutlet weak private var activityDescription: UILabel!
    @IBOutlet weak private var activityCategory: UILabel!
    @IBOutlet weak private var activityImageView: UIImageView!
    @IBOutlet weak private var activityLocation: UILabel!
    @IBOutlet weak private var activityStatus: UILabel!
    @IBOutlet weak private var locationMapView: MKMapView!
    @IBOutlet weak private var weatherForecastStackView: UIStackView!
    @IBOutlet weak private var locationStackView: UIStackView!
    
    //MARK: Weather IBOutlets
    
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureFeelsLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    //MARK: - Properties
    
    var localActivity: ActivityCellItemProtocol?
    let timeDetailsManager = TimeDetailsManager()
    let weatherManager = ForecastService()
    let forecastData = ForecastData()
    var color: UIColor?
    
    weak var delegate: ActivityDetailsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let localActivity = localActivity else {
            return
        }
        checkDate()
        isLocationNull()
        
        switch localActivity.statusType {
        case .inProgress:
            color = UIColor(red: 102.0/255.0, green: 198.0/255.0, blue: 255.0/255.0, alpha: 1)
        case .future:
            color = UIColor(red: 59.0/255.0, green: 245.0/255.0, blue: 170.0/255.0, alpha: 1)
        case .past:
            color = UIColor(red: 242.0/255.0, green: 146.0/255.0, blue: 97.0/255.0, alpha: 1)
        default:
            color = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
        
        activityTitle.text = localActivity.title
        activityStatus.text = localActivity.statusType.rawValue
        activityStatus.textColor = color
        activityDate.text = timeDetailsManager.getCustomFormatFromDate(timestamp: localActivity.startTime, format: DateTimeFormat.dayMonthYear.rawValue) + " " + timeDetailsManager.getCustomFormatFromDate(timestamp: localActivity.startTime, format: DateTimeFormat.hoursMinutes.rawValue) + " - " + timeDetailsManager.getCustomFormatFromDate(timestamp: localActivity.endTime, format: DateTimeFormat.hoursMinutes.rawValue)
        activityDescription.text = localActivity.description
        activityCategory.text = localActivity.name
        activityImageView.image = UIImage(named: localActivity.type)
        activityLocation.text = localActivity.locationName
        guard
            let latitude = localActivity.latitude,
            let longitude = localActivity.longitude
        else { return }
        zoomMap(lat: latitude, lon: longitude, setMapPoint: true)
    }
    
    func commonInit(activity: ActivityCellItemProtocol) {
        localActivity = activity
    }
    
    func widgetInit(activity: ActivityCellItemProtocol) {
        localActivity = activity
        viewDidLoad()
        mainView.hideSkeleton(transition: .crossDissolve(1))
    }
    
    func showSkeleton() {
        let gradient = SkeletonGradient(baseColor: .silver)
        mainView.showAnimatedGradientSkeleton(usingGradient: gradient)
    }
    
    //MARK: - IBOutlet functions
    
    @IBAction func onEditPressed(_ sender: UIButton) {
        guard let localActivity = self.localActivity else {
            return
        }
        self.dismiss(animated: true, completion: nil)
        delegate?.didEditActivity(activity: localActivity)
    }
    
    @IBAction func onDeletePressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Activity deletion", message: "Do you really want to delete selected activity? This action cannot be undone!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            guard let localActivity = self.localActivity else {
                return
            }
            ActivityService().deleteActivities(activity: localActivity.activityId, success: { response in
                if response {
                    WidgetCenter.shared.reloadAllTimelines()
                    self.dismiss(animated: true, completion: nil)
                    self.delegate?.didDeleteActivity(deletedActivity: localActivity.activityId)
                } else {
                    print("there was an error deleting activity!")
                }
            }, failure: { error in
                print(error)
            })
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(alert, animated: true)
        let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.layer.cornerRadius = 5
        switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                subview.backgroundColor = UIColor(red: (245/255.0), green: (245/255.0), blue: (245/255.0), alpha: 1.0)
            case .dark:
                subview.backgroundColor = UIColor(red: (75/255.0), green: (100/255.0), blue: (120/255.0), alpha: 1.0)
            @unknown default:
                subview.backgroundColor = UIColor(red: (245/255.0), green: (245/255.0), blue: (245/255.0), alpha: 1.0)
        }
    }
    
    //MARK: - Functions
    
    func checkDate() {
        guard
            let localActivityTime = localActivity?.startTime
        else { return }
        let testDate = timeDetailsManager.getRealDateFromString(timestamp: localActivityTime)
        let newDate = timeDetailsManager.combineDateAndTime(date: testDate, time: testDate)
        
        if(timeDetailsManager.isDateRangeValid(date: newDate) && localActivity?.latitude != nil && localActivity?.longitude != nil) {
            getForecast(date: newDate)
            weatherForecastStackView.isHidden = false
        } else {
            weatherForecastStackView.isHidden = true
        }
    }
    
    func isLocationNull() {
        if localActivity?.locationName == "None" {
            locationStackView.isHidden = true
        }
    }
    
    func presentData(weatherData: WeatherList) {
        
        guard let temperature = weatherData.main?.temp,
              let feelsLike = weatherData.main?.feelsLike,
              let windSpeed = weatherData.wind?.speed,
              let humidity = weatherData.main?.humidity,
              let description = weatherData.weather?.first?.weatherDescription,
              let condition = weatherData.weather?.first?.id
        else { return }
        weatherTypeLabel.text = "\(description.prefix(1).capitalized)\(description.dropFirst())"
        temperatureLabel.text = "\(Int(temperature)) °C"
        temperatureFeelsLabel.text = "\(Int(feelsLike)) °C"
        windLabel.text = "\(Int(windSpeed)) km/h"
        humidityLabel.text = "\(humidity) %"
        weatherDescriptionLabel.text = "\(description.prefix(1).capitalized)\(description.dropFirst()), with temperature: \(Int(temperature)) °C"
        weatherImageView.image = UIImage(systemName: forecastData.getConditionImage(id: condition))
    }
}

extension ActivityDetailsViewController {
    
    func zoomMap(lat latitude: CLLocationDegrees, lon longitude: CLLocationDegrees,  setMapPoint setPoint: Bool) {
        
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        locationMapView.setRegion(mRegion, animated: true)
        if setPoint {
            addMapPointAnnotation(lat: latitude, lon: longitude)
        }
    }
    
    func addMapPointAnnotation(lat latitude: CLLocationDegrees, lon longitude: CLLocationDegrees) {
        
        let mapPoint: MKPointAnnotation = MKPointAnnotation()
        mapPoint.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        locationMapView.addAnnotation(mapPoint)
    }
    
    func getForecast(date: Date) {
        guard
            let lat = localActivity?.latitude,
            let long = localActivity?.longitude,
            let name = localActivity?.name
        else { return }
        weatherManager.getWeatherForecast(date: date, locationCoordinates: LocationDetails(locationName: name, latitude: lat, longitude: long)) { weatherData in
            self.getForecastForDate(forDate: date, weatherData: weatherData)
        } failure: { error in
            print(error)
            #warning("Handle error")
        }
    }
    
    func getForecastForDate(forDate date: Date, weatherData data: WeatherInfo) {
        
        guard let dataList = data.weatherList else { return }
        let forecastOnDate = dataList.first { (forecastData) -> Bool in
            
            if let dateTime = forecastData.dateTime {
                let range = Date(timeIntervalSince1970: dateTime)...Date(timeIntervalSince1970: (dateTime + 10800))
                if range.contains(date) {
                    return true
                }
            }
            return false
        }
        if let forecastData = forecastOnDate {
            self.presentData(weatherData: forecastData)
        }
        #warning("If there is not an date inside API response")
    }
}
