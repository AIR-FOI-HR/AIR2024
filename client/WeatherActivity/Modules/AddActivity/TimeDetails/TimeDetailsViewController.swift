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

enum DateFormat: String {
    case databaseFormat = "YYYY-MM-dd"
}

class TimeDetailsViewController: AddActivityStepViewController, ViewInterface {
    
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
    let weatherManager = ForecastService()
    let timeDetailsManager = TimeDetailsManager()
    let forecastData = ForecastData()
    var timeWeatherDetails: TimeWeatherDetails?
    #warning("Delete dummy location and replace with previous screen data")
    let dummyLocation = LocationDetails(locationName: "Varaždin", latitude: 46.306268, longitude: 16.336089)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(datePickerEndEditing), for: .editingDidEnd)
        fromTimePicker.addTarget(self, action: #selector(fromTimePickerEndEditing), for: .valueChanged)
        setDefault()
        initialForecast()
    }
    
    // MARK: IBActions
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        guard
            let flowNavigator = flowNavigator
        else { return }
        flowNavigator.showNextStep(
            from: .timeDetails,
            data: StepData(
                stepInfo: .timeDetails,
                data: timeWeatherDetails))
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        guard
            let flowNavigator = flowNavigator
        else { return }
        flowNavigator.showPreviousStep()
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
    
    func checkDate() {
        
        let forecastDate = timeDetailsManager.combineDateAndTime(date: datePicker.date, time: fromTimePicker.date)
        if(timeDetailsManager.isDateRangeValid(date: forecastDate)) {
            weatherStackView.isHidden = false
            warningAlertView.isHidden = true
            getForecast(date: forecastDate)
        } else {
            weatherStackView.isHidden = true
            warningAlertView.isHidden = false
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
        temperatureLabel.text = String(temperature)
        temperatureFeelsLikeLabel.text = String(feelsLike)
        windLabel.text = String(windSpeed)
        humidityLabel.text = String(humidity)
        weatherDescriptionLabel.text = String(description.capitalized)
        weatherTypeImageView.image = UIImage(systemName: forecastData.getConditionImage(id: condition))
        
        let formattedDate = timeDetailsManager.getDate(fromDate: datePicker.date)
        timeWeatherDetails = TimeWeatherDetails(
            date: formattedDate,
            fromTime: timeDetailsManager.getTime(fromDate: fromTimePicker.date, timeFormat: .hourClock24),
            untilTime: timeDetailsManager.getTime(fromDate: untilTimePicker.date, timeFormat: .hourClock24),
            weatherIdentifier: forecastData.getConditionId(id: condition),
            temperature: temperature,
            feelsLike: feelsLike,
            wind: windSpeed,
            humidity: humidity
        )
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

// MARK: Date time

private extension TimeDetailsViewController {
    
    @objc func datePickerEndEditing() {
        dateFormatter.dateFormat = Constants.defaultDateFormat
        #warning("Handle if date is not in range")
        checkDate()
    }
    
    @objc func fromTimePickerEndEditing() {
        let suggestedUntilTime = timeDetailsManager.addTime(to: fromTimePicker.date)
        untilTimePicker.date = suggestedUntilTime
        let forecastDate = timeDetailsManager.combineDateAndTime(date: datePicker.date, time: fromTimePicker.date)
        #warning("Handle if date is not in range")
        checkDate()
    }
    
    func setDefault() {
        dateFormatter.dateFormat = TimeFormat.hourClock24.rawValue
        guard let defaultTime = dateFormatter.date(from: Constants.defaultTime) else { return }
        fromTimePicker.date = defaultTime
        untilTimePicker.date = timeDetailsManager.addTime(to: defaultTime)
    }
    
    func initialForecast() {
        
        let forecastDate = timeDetailsManager.combineDateAndTime(date: datePicker.date, time: fromTimePicker.date)
        getForecast(date: forecastDate)
    }
}

// MARK: - Protocol ViewInteface

extension TimeDetailsViewController {
    
    func setAction(_ actiion: Action, hidden: Bool) {
        #warning("Set it up with proper buttons")
    }
}
