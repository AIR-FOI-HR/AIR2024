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
    
    // MARK: Properties
    
    let dateFormatter = DateFormatter()
    var locationDetails: LocationDetails?
    
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

// MARK: Date time

private extension TimeDetailsViewController {
    
    @objc func datePickerEndEditing() {
        dateFormatter.dateFormat = Constants.defaultDateFormat
        debugPrint(datePicker.date)
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

// MARK: Forecast
