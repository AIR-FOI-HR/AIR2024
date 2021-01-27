//
//  CalendarViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 04.01.2021..
//


import UIKit
import SwiftUI
import FSCalendar


final class CalendarViewController: UIViewController , FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var activitiesStackView: UIStackView!
    
    // MARK: Properties
    
    private let activityService = ActivityService()
    private var allActivities = [ActivityCellItemProtocol]()
    private var activityListView: ActivityListView!
    private let responseDateFormatter = DateFormatter()
    private let calendarDateFormatter = DateFormatter()
    private var formattedActivityDates = [Date]()
    private let activityItemHelper = ActivityItemHelper()
    private var activitiesList: [ActivityCellItemProtocol] = []
    private var selectedDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.delegate = self
        calendarDateFormatter.dateFormat = "yyyy-MM-dd"
        responseDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        setupListView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadAllActivities()
    }

    // MARK: Custom functions
    
    func convertResponseDateStringToCalendarDate(responseDateString: String) -> Date? {
        guard let formattedResponseDate = responseDateFormatter.date(from: responseDateString) else { return nil }
        let calendarDateString = calendarDateFormatter.string(from: formattedResponseDate)
        guard let calendarDate = calendarDateFormatter.date(from: calendarDateString) else { return nil }
        return calendarDate
    }
    
    private func loadAllActivities() {
        guard let userToken = SessionManager.shared.getStringFromKeychain(key: .sessionToken) else {
            self.activityListView.setState(state: .error)
            return
        }
        activityService.getActivities(for: "calendar", token: userToken, success: { (activities) in
            let activityItems = self.activityItemHelper.getActivityCellItems(activities: activities)
            self.allActivities = activityItems
            self.formattedActivityDates = []
            for activity in self.allActivities {
                guard let activityDate = self.convertResponseDateStringToCalendarDate(responseDateString: activity.startTime) else { break }
                self.formattedActivityDates.append(activityDate)
            }
            self.updateActivityListView(withDate: self.selectedDate)
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
            var activitiesList: [ActivityCellItemProtocol] = []
            for activity in filteredActivities {
                activitiesList.append(activity)
            }
            activityListView.setState(state: .normal(items: activitiesList))
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
            return UIColor(named: "LightDarkBlue")
        }
        else {
            return nil
        }
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        updateActivityListView(withDate: date)
    }
    
    func openActivityFlow(isEditing: Bool = false, activity: ActivityCellItemProtocol?) {
        let navigationController = UINavigationController()
        let steps: [StepInfo] = [.locationDetails, .timeDetails, .categoriesDetails, .finalDetails]
        
        let flowNavigator = AddActivityFlowNavigator(navigationController: navigationController, steps: steps)
        
        flowNavigator.presentFlow(from: self)
        
        flowNavigator.isEditing = isEditing
        flowNavigator.editingActivity = activity
        
        flowNavigator.delegate = self
    }
    
}

//MARK: - Extensions

extension CalendarViewController: ActivityListViewDelegate, ActivityDetailsViewControllerDelegate, AddActivityFlowNavigatorDelegate {
    
    func didFinishFlow() {
        loadAllActivities()
    }
    
    func didEditActivity(activity: ActivityCellItemProtocol) {
        openActivityFlow(isEditing: true, activity: activity)
        
    }
    
    func didDeleteActivity(deletedActivity: Int) {
        loadAllActivities()
    }
    
    func didPressRow(activity: ActivityCellItemProtocol) {
        let details = ActivityDetailsViewController(nibName: "ActivityDetailsViewController", bundle: nil)
        details.commonInit(activity: activity)
        self.present(details, animated: true, completion: nil)
        details.delegate = self
    }
    
    func didPressReloadAction() {
        loadAllActivities()
    }
}
