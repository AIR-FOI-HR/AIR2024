//
//  CalendarViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 04.01.2021..
//


import UIKit
import FSCalendar


final class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var calendarView: FSCalendar!
    
    // MARK: Properties
    
    let activityService = ActivityService()
    var allActivities = [Activities]()
    let responseDateFormatter = DateFormatter()
    let calendarDateFormatter = DateFormatter()
    var formattedActivityDates = [Date]()

    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.delegate = self
        calendarDateFormatter.dateFormat = "yyyy-MM-dd"
        responseDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        setAllActivities()
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let currentFormattedDateString = calendarDateFormatter.string(from: date)
        guard let currentFormattedDate = calendarDateFormatter.date(from: currentFormattedDateString) else { return nil }
        if formattedActivityDates.contains(currentFormattedDate) {
            return .white
        }
        else {
            return nil
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let currentFormattedDateString = calendarDateFormatter.string(from: date)
        guard let currentFormattedDate = calendarDateFormatter.date(from: currentFormattedDateString) else { return nil }
        if formattedActivityDates.contains(currentFormattedDate) {
            return .darkGray
        }
        else {
            return nil
        }
    }
    
    func setAllActivities() {
        guard let userToken = SessionManager.shared.getToken() else {
            return
        }
        activityService.getActivities(token: userToken, success: { apiResponse in
            self.allActivities = apiResponse
            for activity in self.allActivities {
                guard let activityDate = self.responseDateFormatter.date(from: activity.startTime) else { return }
                self.formattedActivityDates.append(self.convertResponseDateToCalendarDate(responseDate: activityDate))
            }
            self.calendarView.reloadData()
        }, failure: { error in
            self.presentAlert(title: "Oops!", message: "Couldn't get your activities")
        })
    }

    func convertResponseDateToCalendarDate(responseDate: Date) -> Date {
        let responseDateString = responseDateFormatter.string(from: responseDate)
        guard let formattedResponseDate = responseDateFormatter.date(from: responseDateString) else { return responseDate }
        let calendarDateString = calendarDateFormatter.string(from: formattedResponseDate)
        guard let calendarDate = calendarDateFormatter.date(from: calendarDateString) else { return responseDate }
        return calendarDate
    }
    
}

