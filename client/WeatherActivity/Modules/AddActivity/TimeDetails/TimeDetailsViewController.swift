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
    @IBOutlet weak var aqiLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    // MARK: Properties
    
    let dateFormatter = DateFormatter()
    var locationDetails: LocationDetails?
    let weatherManager = WeatherManager()
    #warning("Delete dummy location")
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
            debugPrint(weatherData)
            self.temperatureLabel.text = String(weatherData.main.temp)
            #warning("Handle succes, weather data object")
        } failure: { error in
            #warning("Handle error")
        }

    }
}

// MARK: Date time

private extension TimeDetailsViewController {
    
    @objc func datePickerEndEditing() {
        dateFormatter.dateFormat = Constants.defaultDateFormat
        debugPrint(datePicker.date)
        getForecast(date: datePicker.date)
        // GET FORECAST
    }
    
    @objc func fromTimePickerEndEditing() {
        let suggestedUntilTime = addTime(to: fromTimePicker.date)
        untilTimePicker.date = suggestedUntilTime
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
}
