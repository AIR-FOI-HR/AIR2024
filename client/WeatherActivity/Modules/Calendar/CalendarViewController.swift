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
    @IBOutlet weak var activitiesStackView: UIStackView!
    
    // MARK: Properties
    
    private let activityService = ActivityService()
    private var allActivities = [Activities]()
    private var activityListView: ActivityListView!
    private let responseDateFormatter = DateFormatter()
    private let calendarDateFormatter = DateFormatter()
    private var formattedActivityDates = [Date]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.delegate = self
        calendarDateFormatter.dateFormat = "yyyy-MM-dd"
        responseDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        loadAllActivities()
        setupListView()
    }
    
    // MARK: - IBActions

    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Custom functions
    
    func convertResponseDateStringToCalendarDate(responseDateString: String) -> Date? {
        guard let formattedResponseDate = responseDateFormatter.date(from: responseDateString) else { return nil }
        let calendarDateString = calendarDateFormatter.string(from: formattedResponseDate)
        guard let calendarDate = calendarDateFormatter.date(from: calendarDateString) else { return nil }
        return calendarDate
    }
    
    private func loadAllActivities() {
        guard let userToken = SessionManager.shared.getToken() else {
            self.activityListView.setState(state: .error)
            return
        }
        activityService.getActivities(for: "calendar", token: userToken, success: { (activities) in
            self.allActivities = activities
            for activity in self.allActivities {
                guard let activityDate = self.convertResponseDateStringToCalendarDate(responseDateString: activity.startTime) else { break }
                self.formattedActivityDates.append(activityDate)
            }
            self.calendarView.reloadData()
        }, failure: { error in
            self.activityListView.setState(state: .error)
        })
    }
    
    private func setupListView() {
        let listView = ActivityListView.loadFromXib()
        listView.delegate = self
        activitiesStackView.addArrangedSubview(listView)
        activityListView = listView
        updateActivityListView(withDate: Date())
    }
    
    private func updateActivityListView(withDate date: Date) {
        let filteredActivities = allActivities.filter {
            guard let formattedDate = convertResponseDateStringToCalendarDate(responseDateString: $0.startTime) else { return false }
            return date == formattedDate
        }
        
        if filteredActivities.isEmpty {
            activityListView.setState(state: .noActivitiesOnDate)
        }
        else {
            var activitiesList: [ActivityCellItem] = []
            for activity in filteredActivities {
                activitiesList.append(.init(activityId: activity.activityId, startTime: activity.startTime, endTime: activity.endTime, title: activity.title, description: activity.description, locationName: activity.locationName, latitude: activity.latitude, longitude: activity.longitude, temperature: activity.temperature, feelsLike: activity.feelsLike, wind: activity.wind, humidity: activity.humidity, forecastType: activity.forecastType, name: activity.name, type: activity.type, statusType: activity.statusType))
            }
            activityListView.setState(state: .normal(items: activitiesList))
            activityListView.activityListView.reloadData()
        }
    }
    
    
    //MARK: - CalendarView handling
    
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

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        updateActivityListView(withDate: date)
    }
    
}

//MARK: - Extensions

extension CalendarViewController: ActivityListViewDelegate {
    func didPressRow(activity: ActivityCellItem) {
        let details = ActivityDetailsViewController(nibName: "ActivityDetailsViewController", bundle: nil)
        details.commonInit(activity: activity)
        self.present(details, animated: true, completion: nil)
    }
    
    func didPressReloadAction() {
        loadAllActivities()
    }
}
