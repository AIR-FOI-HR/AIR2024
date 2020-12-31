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
    case sport = "Sport"
    case family = "Family"
    case romance = "Romance"
    case business = "Business"
    case studying = "Studying"
    case shopping = "Shopping"
    case entertainment = "Entertainment"
}

//MARK: - CategoryCell class

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
    private var selectedCategory: Int? = 0
    private var activityListView: ActivityListView!
    private var activitiesList: [ActivityCellItem] = []
    private var filteredActivitiesList: [ActivityCellItem] = []
    private let activityService = ActivityService()
    
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
        self.activityListView.setState(state: .loading)
        
        let filteredActivitiesBySearch = filteredActivitiesList.filter { activity in
            return activity.title.lowercased().contains(searchText.lowercased())
        }
        
        if searchText.isEmpty {
            self.activityListView.setState(state: .normal(items: filteredActivitiesList))
        } else if filteredActivitiesBySearch.isEmpty {
            self.activityListView.setState(state: .noActivities)
        } else {
            self.activityListView.setState(state: .normal(items: filteredActivitiesBySearch))
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
        
        var categoryNames = [String]()
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
        cell.isSelected = true
        cell.backgroundColor = categoryColors[indexPath.item].withAlphaComponent(1.0)
        
        selectedCategory = indexPath.item + 1
        handleFilter()
    }
    
    //MARK: - CollectionVIew: DeselectedItems
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.backgroundColor = categoryColors[indexPath.item]
        
//        selectedCategory = 0
//        handleFilter()
    }
    
    @IBAction func discardFilters(_ sender: UIButton) {
        self.activityListView.setState(state: .loading)
        selectedCategory = 0
        self.activityListView.setState(state: .normal(items: activitiesList))
    }
    
    // MARK: - Custom functions
    
    private func handleFilter() {
        self.activityListView.setState(state: .loading)
        
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
        
        if selectedCategory != 0 {
            filter.append({$0.categoryId == self.selectedCategory})
        }
        
        filteredActivitiesList = activitiesList.filter { activity in
            filter.reduce(true) {
                $0 && $1(activity)
            }
        }
        
        if filteredActivitiesList.isEmpty {
            self.activityListView.setState(state: .noActivities)
        } else {
            self.activityListView.setState(state: .normal(items: filteredActivitiesList))
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
                        self.activitiesList.append(.init(activityId: activity.activityId, startTime: activity.startTime, endTime: activity.endTime, title: activity.title, description: activity.description, locationName: activity.locationName, forecastId: activity.forecastId, categoryId: activity.categoryId, activityStatusId: activity.activityStatusId))
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
}

//MARK: - Extensions

extension SearchActivitiesViewController: ActivityListViewDelegate {
    func didPressReloadAction() {
        loadActivities()
    }
}
