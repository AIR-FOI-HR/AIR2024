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
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var fromTimePicker: UIDatePicker!
    @IBOutlet weak var untilTimePicker: UIDatePicker!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureFeelsLikeLabel: UILabel!
    
    // MARK: Properties
    
    let dateFormatter = DateFormatter()
    var locationDetails: LocationDetails?
    let weatherManager = WeatherManager()
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
        let timeDetails = TimeDetails(date: datePicker.date, fromTime: fromTimePicker.date, untilTime: untilTimePicker.date)
        let activityDetails = ActivityData(locationDetails: self.locationDetails, timeDetails: timeDetails)
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

// MARK: - Forecast manager

private extension TimeDetailsViewController {
    
    func presentData(weatherData: WeatherList) {
        guard let temperature = weatherData.main?.temp, let feelsLike = weatherData.main?.feelsLike, let windSpeed = weatherData.wind?.speed, let humidity = weatherData.main?.humidity else { return }
        temperatureLabel.text = String(temperature)
        temperatureFeelsLikeLabel.text = String(feelsLike)
        windLabel.text = String(windSpeed)
        humidityLabel.text = String(humidity)
    }
    
    func getForecastForDate(forDate date: Date, weatherData data: WeatherData) {
        guard let dataList = data.weatherList else { return }
        for index in 1...dataList.count - 2 {
            let range = Date(timeIntervalSince1970: dataList[index].dt!)...Date(timeIntervalSince1970: dataList[index+1].dt!)
            if range.contains(date) {
                self.presentData(weatherData: dataList[index])
            }
        }
    }
}

// MARK: Date time

private extension TimeDetailsViewController {
    
    @objc func datePickerEndEditing() {
        dateFormatter.dateFormat = Constants.defaultDateFormat
        #warning("Handle if date is not in range")
        isDateRangeValid(date: datePicker.date) ? getForecast(date: datePicker.date) : print("Not in range")
    }
    
    @objc func fromTimePickerEndEditing() {
        let suggestedUntilTime = addTime(to: fromTimePicker.date)
        untilTimePicker.date = suggestedUntilTime
        let newDate = combineDateAndTime(date: datePicker.date, time: fromTimePicker.date)
        #warning("Handle if date is not in range")
        isDateRangeValid(date: newDate) ? getForecast(date: newDate) : print("Not in range")
    }
    
    func setDefault() {
        dateFormatter.dateFormat = TimeFormat.hourClock24.rawValue
        guard let defaultTime = dateFormatter.date(from: Constants.defaultTime) else { return }
        fromTimePicker.date = defaultTime
        untilTimePicker.date = addTime(to: defaultTime)
    }
    
    func getTime(fromDate date: Date, timeFormat format: TimeFormat) -> String {
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: date)
    }
    
    func addTime(to toDate: Date, hours hoursValue: Int = Constants.defaultTimeInterval) -> Date {
        guard let modifiedDate = Calendar.current.date(byAdding: .hour, value: hoursValue, to: toDate) else { return toDate }
        return modifiedDate
    }
    
    // Maximum of 5 days apart -> Reason: OpenWeatherMap API Free version gives only forecast for 5 days infront
    func isDateRangeValid(date: Date) -> Bool {
        let nowDate = Date()
        let calendar = Calendar.current
        let nextDate = calendar.date(byAdding: .day, value: Constants.validDateRange, to: nowDate)
        
        let range = nowDate...nextDate!
        if range.contains(date) {
            return true
        }
        return false
    }
    
    func combineDateAndTime(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        
        let timeComponents: DateComponents? = calendar.dateComponents([.hour, .minute, .second], from: time)
        var dateComponents: DateComponents? = calendar.dateComponents([.day, .month, .year], from: date)
        
        dateComponents?.hour = timeComponents?.hour
        dateComponents?.minute = timeComponents?.minute
        dateComponents?.second = timeComponents?.second
        
        if let newDate: Date = calendar.date(from: dateComponents!) {
            return newDate
        }
        return date
    }
}
