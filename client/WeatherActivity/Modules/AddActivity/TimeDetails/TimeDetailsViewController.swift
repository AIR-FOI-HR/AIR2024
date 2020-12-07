//
//  TimeDetailsViewController.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 03.12.2020..
//

// MARK: Imports

import UIKit

// MARK: Time formats

enum TimeFormat: String {
    case hourClock24 = "HH:mm"
    case hourClock12 = "h:mm a"
}

class TimeDetailsViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var fromTimePicker: UIDatePicker!
    @IBOutlet private weak var untilTimePicker: UIDatePicker!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var windLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var temperatureFeelsLikeLabel: UILabel!
    @IBOutlet private weak var weatherStackView: UIStackView!
    @IBOutlet private weak var warningAlertView: UIStackView!
    @IBOutlet private weak var weatherTypeImageView: UIImageView!
    @IBOutlet private weak var weatherDescriptionLabel: UILabel!
    
    // MARK: Properties
    
    let dateFormatter = DateFormatter()
    var locationDetails: LocationDetails?
    let weatherManager = WeatherManager()
    let timeDetailsManager = TimeDetailsManager()
    #warning("Delete dummy location and replace with previous screen data")
    let dummyLocation = LocationDetails(latitude: 46.306268, longitude: 16.336089)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.addTarget(self, action: #selector(datePickerEndEditing), for: .editingDidEnd)
        fromTimePicker.addTarget(self, action: #selector(fromTimePickerEndEditing), for: .editingDidEnd)
        setDefault()
    }
    
    // MARK: IBActions
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        let timeDetails = TimeDetails(date: datePicker.date, fromTime: timeDetailsManager.getTime(fromDate: fromTimePicker.date, timeFormat: .hourClock24), untilTime: timeDetailsManager.getTime(fromDate: untilTimePicker.date, timeFormat: .hourClock24))
        let activityDetails = ActivityData(locationDetails: self.locationDetails, timeDetails: timeDetails)
        debugPrint(activityDetails)
        #warning("Pass arguments to next screen")
    }
}

// MARK: Data manager

private extension TimeDetailsViewController {
    
    func getForecast(date: Date) {
        weatherManager.getWeatherForecast(date: date, locationCoordinates: dummyLocation) { weatherData in
            self.getForecastForDate(forDate: date, weatherData: weatherData)
        } failure: { error in
            print(error)
            #warning("Handle error")
        }
    }
}

// MARK: - Forecast presentation

private extension TimeDetailsViewController {
    
    func presentData(weatherData: WeatherList) {
        guard let temperature = weatherData.main?.temp, let feelsLike = weatherData.main?.feelsLike, let windSpeed = weatherData.wind?.speed, let humidity = weatherData.main?.humidity, let description = weatherData.weather?.first?.weatherDescription else { return }
        temperatureLabel.text = String(temperature)
        temperatureFeelsLikeLabel.text = String(feelsLike)
        windLabel.text = String(windSpeed)
        humidityLabel.text = String(humidity)
        weatherDescriptionLabel.text = String(description.capitalized)
    }
    
    func getForecastForDate(forDate date: Date, weatherData data: WeatherData) {
        guard let dataList = data.weatherList else { return }
        for index in 1...dataList.count - 2 {
            let range = Date(timeIntervalSince1970: dataList[index].dt!)...Date(timeIntervalSince1970: dataList[index+1].dt!)
            if range.contains(date) {
                self.presentData(weatherData: dataList[index])
            }
        }
        #warning("If there is not an date inside API response")
    }
}

// MARK: Date time

private extension TimeDetailsViewController {
    
    @objc func datePickerEndEditing() {
        dateFormatter.dateFormat = Constants.defaultDateFormat
        #warning("Handle if date is not in range")
        if(timeDetailsManager.isDateRangeValid(date: datePicker.date)) {
            weatherStackView.isHidden = false
            warningAlertView.isHidden = true
            getForecast(date: datePicker.date)
        } else {
            weatherStackView.isHidden = true
            warningAlertView.isHidden = false
        }
    }
    
    @objc func fromTimePickerEndEditing() {
        let suggestedUntilTime = timeDetailsManager.addTime(to: fromTimePicker.date)
        untilTimePicker.date = suggestedUntilTime
        let newDate = timeDetailsManager.combineDateAndTime(date: datePicker.date, time: fromTimePicker.date)
        #warning("Handle if date is not in range")
        timeDetailsManager.isDateRangeValid(date: newDate) ? getForecast(date: newDate) : print("Not in range")
    }
    
    func setDefault() {
        dateFormatter.dateFormat = TimeFormat.hourClock24.rawValue
        guard let defaultTime = dateFormatter.date(from: Constants.defaultTime) else { return }
        fromTimePicker.date = defaultTime
        untilTimePicker.date = timeDetailsManager.addTime(to: defaultTime)
    }
}
