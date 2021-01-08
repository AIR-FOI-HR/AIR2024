//
//  SearchActivitiesViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 21.12.2020..
//

import UIKit

//MARK: - Categories enum

enum Categories: String, CaseIterable {
    case food = "Food"
    case sport = "Sports"
    case family = "Family"
    case romance = "Romance"
    case business = "Business"
    case studying = "Studying"
    case shopping = "Shopping"
    case entertainment = "Entertainment"
}

//MARK: - Classes

class CategoryCell {
    var categoryType: Categories
    var name: String? { categoryType.rawValue }
    
    init(type: Categories) {
        self.categoryType = type
    }
}

//MARK: - ViewController class

class SearchActivitiesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    enum SelectedTime {
        case all
        case past
        case future
    }
    
    //MARK: - IBOutlets
    
    @IBOutlet weak private var activitiesStackView: UIStackView!
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var searchBar: UISearchBar!
    
    //MARK: - Properties
    
    private var selectedTime: SelectedTime?
    private var previous = 0
    private var selectedCategory: String? = ""
    private var activityListView: ActivityListView!
    private var activitiesList: [ActivityCellItem] = []
    private var filteredActivitiesList: [ActivityCellItem] = []
    private let activityService = ActivityService()
    private var categoryNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        setupListView()
        loadActivities()
    }
    
    //MARK: - Current time function
    
    private func getCurrentTimeStamp() -> String {
        let currentDateTime = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let currentTimeStamp = dateFormatter.string(from: currentDateTime)
        return currentTimeStamp
    }
    
    //MARK: - Search bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        activityListView.setState(state: .loading)
        
        let filteredActivitiesBySearch = filteredActivitiesList.filter { activity in
            return activity.title.lowercased().contains(searchText.lowercased())
        }
        
        if searchText.isEmpty {
            activityListView.setState(state: .normal(items: filteredActivitiesList))
        } else if filteredActivitiesBySearch.isEmpty {
            activityListView.setState(state: .noFilteredActivities)
        } else {
            activityListView.setState(state: .normal(items: filteredActivitiesBySearch))
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            selectedTime = .all
        case 1:
            selectedTime = .past
        case 2:
            selectedTime = .future
        default:
            break
        }
        handleFilter()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        handleFilter()
    }
    
    //MARK: - CollectionVIew handling
    
    var categories: [CategoryCell] {
        [.init(type: .food), .init(type: .sport), .init(type: .family), .init(type: .romance), .init(type: .business), .init(type: .studying), .init(type: .shopping), .init(type: .entertainment)]
    }
    
    
    let categoryColors = [UIColor.Food, UIColor.Sport, UIColor.Family, UIColor.Romance, UIColor.Business, UIColor.Studying, UIColor.Shopping, UIColor.Entertainment]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Categories.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCollectionViewCell else { fatalError() }
        
        for item in categories {
            if let categoryName = item.name {
                categoryNames.append(categoryName)
            }
        }
        
        cell.categoryLabel.text = categoryNames[indexPath.item]
        cell.backgroundColor = categoryColors[indexPath.item]
        return cell
    }
    
    //MARK: - CollectionVIew: SelectedItems
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        if selectedCategory == categoryNames[indexPath.item] {
            cell.backgroundColor = categoryColors[indexPath.item]
            selectedCategory = ""
        } else {
            cell.isSelected = true
            cell.backgroundColor = categoryColors[indexPath.item].withAlphaComponent(1.0)
            selectedCategory = categoryNames[indexPath.item]
        }
        handleFilter()
    }
    
    //MARK: - CollectionVIew: DeselectedItems
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.backgroundColor = categoryColors[indexPath.item]
        selectedCategory = ""
        activityListView.setState(state: .loading)
    }
    
    // MARK: - Custom functions
    
    private func handleFilter() {
        activityListView.setState(state: .loading)
        
        var filter: [(ActivityCellItem) -> Bool] = []
        
        if searchBar.text != "" {
            guard let searchText = searchBar.text?.lowercased() else {
                return
            }
            filter.append({$0.title.lowercased().contains(searchText)})
        }
        
        if selectedTime == .past {
            filter.append({$0.startTime < self.getCurrentTimeStamp()})
        } else if selectedTime == .future {
            filter.append({$0.startTime > self.getCurrentTimeStamp()})
        }
        
        if selectedCategory != "" {
            filter.append({$0.name == self.selectedCategory})
        }
        
        filteredActivitiesList = activitiesList.filter { activity in
            filter.reduce(true) {
                $0 && $1(activity)
            }
        }
        
        if filteredActivitiesList.isEmpty {
            activityListView.setState(state: .noFilteredActivities)
        } else {
            activityListView.setState(state: .normal(items: filteredActivitiesList))
        }
    }
    
    private func setupListView() {
        let listView = ActivityListView.loadFromXib()
        listView.delegate = self
        activitiesStackView.addArrangedSubview(listView)
        activityListView = listView
    }
    
    func loadActivities() {
        activityListView.setState(state: .loading)
        if let sessionToken = SessionManager.shared.getToken() {
            activityService.getActivities(token: sessionToken, success: { (activities) in
                if activities.isEmpty {
                    self.activityListView.setState(state: .noActivities)
                }
                else {
                    for activity in activities {
                        self.activitiesList.append(.init(activityId: activity.activityId, startTime: activity.startTime, endTime: activity.endTime, title: activity.title, description: activity.description, locationName: activity.locationName, latitude: activity.latitude, longitude: activity.longitude, temperature: activity.temperature, feelsLike: activity.feelsLike, wind: activity.wind, humidity: activity.humidity, forecastType: activity.forecastType, name: activity.name, type: activity.type, statusType: activity.statusType))
                    }
                    self.filteredActivitiesList = self.activitiesList
                    self.activityListView.setState(state: .normal(items: self.activitiesList))
                }
            }, failure: { error in
                self.activityListView.setState(state: .error)
            })
        } else {
            self.activityListView.setState(state: .error)
        }
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - Extensions

extension SearchActivitiesViewController: ActivityListViewDelegate {
    func didPressRow(activity: ActivityCellItem) {
        let details = ActivityDetailsViewController(nibName: "ActivityDetailsViewController", bundle: nil)
        details.commonInit(activity: activity)
        self.present(details, animated: true, completion: nil)
    }
    
    func didPressReloadAction() {
        loadActivities()
    }
}
