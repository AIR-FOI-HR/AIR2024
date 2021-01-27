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
    case databaseFormat = "YYYY-MM-dd HH:mm:ss"
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
    @IBOutlet private weak var weatherTypeLabel: UILabel!
    
    
    // MARK: Properties
    
    let dateFormatter = DateFormatter()
    var locationDetails: LocationDetails?
    let weatherManager = ForecastService()
    let timeDetailsManager = TimeDetailsManager()
    let forecastData = ForecastData()
    var timeDetails: TimeDetails?
    var weatherDetails: WeatherDetails?
    var location: LocationDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(datePickerEndEditing), for: .editingDidEnd)
        fromTimePicker.addTarget(self, action: #selector(fromTimePickerEndEditing), for: .valueChanged)
        untilTimePicker.addTarget(self, action: #selector(untilTimePickerEndEditing), for: .valueChanged)
        setDefault()
        
        guard
            let flowNavigator = flowNavigator
        else { return }
        
        location = flowNavigator.dataFlowManager.getData(forStep: .locationDetails)
        
        if flowNavigator.isEditing {
            guard
                let activityDetails = flowNavigator.editingActivity
            else { return }
            let fromTime = timeDetailsManager.getDateFromString(timestamp: activityDetails.startTime)
            let untilTime = timeDetailsManager.getDateFromString(timestamp: activityDetails.endTime)
            datePicker.date = fromTime
            fromTimePicker.date = fromTime
            untilTimePicker.date = untilTime
        }
        
        checkDate()
    }
    
    // MARK: IBActions
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        setInitialDate()
        guard
            let flowNavigator = flowNavigator,
            let timeDetails = timeDetails
        else { return }
        flowNavigator.showNextStep(
            from: .timeDetails,
            data: StepData(
                stepInfo: .timeDetails,
                data: TimeWeatherStep(
                    timeDetails: timeDetails,
                    weatherDetails: weatherDetails
                )
            )
        )
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
        guard let location = location else {
            return
        }
        weatherManager.getWeatherForecast(date: date, locationCoordinates: location) { weatherData in
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
            setInitialDate()
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
        temperatureFeelsLikeLabel.text = "\(Int(feelsLike)) °C"
        windLabel.text = "\(Int(windSpeed)) km/h"
        humidityLabel.text = "\(humidity) %"
        weatherTypeImageView.image = UIImage(systemName: forecastData.getConditionImage(id: condition))
        weatherDescriptionLabel.text = "\(description.prefix(1).capitalized)\(description.dropFirst()), with temperature: \(Int(temperature)) °C"
        
        setInitialDate()
        
        weatherDetails = WeatherDetails(
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
    
    func setInitialDate() {
        
        let formattedStartDate = timeDetailsManager.getDate(
                fromDate: timeDetailsManager.combineDateAndTime(
                    date: datePicker.date,
                    time: fromTimePicker.date))
        let formattedUntilDate = timeDetailsManager.getDate(
                fromDate: timeDetailsManager.combineDateAndTime(
                    date: datePicker.date,
                    time: untilTimePicker.date))
        timeDetails = TimeDetails(
                date: timeDetailsManager.getDate(fromDate: datePicker.date),
                fromTime: formattedStartDate,
                untilTime: formattedUntilDate)
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
    
    @objc func untilTimePickerEndEditing() {
        
    }
    
    func setDefault() {
        
        dateFormatter.dateFormat = TimeFormat.hourClock24.rawValue
        guard let defaultTime = dateFormatter.date(from: Constants.defaultTime) else { return }
        fromTimePicker.date = defaultTime
        untilTimePicker.date = timeDetailsManager.addTime(to: defaultTime)
        setInitialDate()
    }
}

// MARK: - Protocol ViewInteface

extension TimeDetailsViewController {
    
    func setAction(_ actiion: Action, hidden: Bool) {
        #warning("Set it up with proper buttons")
    }
}
