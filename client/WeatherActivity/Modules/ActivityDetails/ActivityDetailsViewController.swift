//
//  ActivityDetailsViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 18.12.2020..
//

import UIKit
import MapKit

protocol ActivityDetailsViewControllerDelegate: AnyObject {
    func didEditActivity(activity: ActivityCellItem)
    func didDeleteActivity(deletedActivity: Int)
}

class ActivityDetailsViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak private var activityTitle: UILabel!
    @IBOutlet weak private var activityDate: UILabel!
    @IBOutlet weak private var activityTime: UILabel!
    @IBOutlet weak private var activityDescription: UILabel!
    @IBOutlet weak private var activityCategory: UILabel!
    @IBOutlet weak private var activityImageView: UIImageView!
    @IBOutlet weak private var activityLocation: UILabel!
    @IBOutlet weak private var activityStatus: UILabel!
    @IBOutlet weak private var titleUIView: UIView!
    @IBOutlet weak private var bodyUIView: UIView!
    @IBOutlet weak private var locationMapView: MKMapView!
    @IBOutlet weak private var weatherForecastStackView: UIStackView!
    
    //MARK: Weather IBOutlets
    
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureFeelsLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    //MARK: - Properties
    
    var localActivity: ActivityCellItem?
    let timeDetailsManager = TimeDetailsManager()
    let weatherManager = ForecastService()
    let forecastData = ForecastData()
    var color: UIColor?
    
    weak var delegate: ActivityDetailsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkDate()
        
        titleUIView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bodyUIView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        guard let localActivity = localActivity else {
            return
        }
        
        switch localActivity.statusType {
        case "In progress":
            color = UIColor(red: 59.0/255.0, green: 245.0/255.0, blue: 170.0/255.0, alpha: 1)
        case "Delayed":
            color = UIColor(red: 242.0/255.0, green: 146.0/255.0, blue: 97.0/255.0, alpha: 1)
        case "Canceled":
            color = UIColor(red: 242.0/255.0, green: 146.0/255.0, blue: 97.0/255.0, alpha: 1)
        case "Completed":
            color = UIColor(red: 242.0/255.0, green: 146.0/255.0, blue: 97.0/255.0, alpha: 1)
        default:
            color = UIColor(red: 59.0/255.0, green: 245.0/255.0, blue: 170.0/255.0, alpha: 1)
        }
        
        activityTitle.text = localActivity.title
        activityStatus.text = localActivity.statusType
        activityStatus.backgroundColor = color
        activityDate.text = getDate(timestamp: localActivity.startTime)
        activityTime.text = getTime(timestamp: localActivity.startTime)
        activityDescription.text = localActivity.description
        activityCategory.text = localActivity.name
        activityImageView.image = UIImage(named: localActivity.type)
        activityLocation.text = localActivity.locationName
        
        zoomMap(lat: localActivity.latitude, lon: localActivity.longitude, setMapPoint: true)
    }
    
    func commonInit(activity: ActivityCellItem) {
        localActivity = activity
    }
    
    func widgetInit(activity: ActivityCellItem) {
        localActivity = activity
        
        viewDidLoad()
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
    }
    
    //MARK: - Functions
    
    func getDate(timestamp: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy"

        guard let date = dateFormatterGet.date(from: timestamp) else { return "Err" }
        return dateFormatterPrint.string(from: date)
    }
    
    func getRealDate(timestamp: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        guard let date = dateFormatter.date(from: timestamp) else { return Date() }
        return date
    }
    
    func getTime(timestamp: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "HH:mm:ss"

        guard let time = dateFormatterGet.date(from: timestamp) else { return "Err" }
        return dateFormatterPrint.string(from: time)
    }
    
    func checkDate() {
        guard let localActivityTime = localActivity?.startTime else { return }
        let testDate = getRealDate(timestamp: localActivityTime)
        let newDate = timeDetailsManager.combineDateAndTime(date: testDate, time: testDate)
        
        if(timeDetailsManager.isDateRangeValid(date: newDate)) {
            getForecast(date: newDate)
            weatherForecastStackView.isHidden = false
        } else {
            weatherForecastStackView.isHidden = true
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
