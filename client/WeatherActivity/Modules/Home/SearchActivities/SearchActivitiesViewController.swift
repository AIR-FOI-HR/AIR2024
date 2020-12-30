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
    
    //MARK: - IBOutlets
    
    @IBOutlet weak private var activitiesStackView: UIStackView!
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var searchBar: UISearchBar!
    
    //MARK: - Properties
    
    private var selectedCategory: Int?
    private var activityListView: ActivityListView!
    private var activitiesList: [ActivityCellItem] = []
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
        let filteredActivities = activityListView.getDataSource().filter { activity in
            return activity.title.lowercased().contains(searchText.lowercased())
        }
        
        if searchText.isEmpty {
            self.activityListView.setState(state: .normal(items: activitiesList))
            
        } else if filteredActivities.isEmpty {
            self.activityListView.setState(state: .noActivities)
        }
        else {
            self.activityListView.setState(state: .normal(items: filteredActivities))
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        self.activityListView.setState(state: .loading)
        
        switch selectedScope {
        case 0:
            self.activityListView.setState(state: .normal(items: activitiesList))
        case 1:
            let selectedPastScopeActivities = activitiesList.filter { activity in
                return activity.startTime < getCurrentTimeStamp()
            }
            self.activityListView.setState(state: .normal(items: selectedPastScopeActivities))
        case 2:
            let selectedFutureScopeActivities = activitiesList.filter { activity in
                return activity.startTime > getCurrentTimeStamp()
            }
            self.activityListView.setState(state: .normal(items: selectedFutureScopeActivities))
        default:
            print("case default")
        }
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
        
        self.activityListView.setState(state: .loading)
        let selectedCategoryActivities = activitiesList.filter { activity in
            
            return activity.categoryId == selectedCategory
        }
        self.activityListView.setState(state: .normal(items: selectedCategoryActivities))
    }
    
    //MARK: - CollectionVIew: DeselectedItems
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.backgroundColor = categoryColors[indexPath.item]
        
    }
    
    @IBAction func discardFilters(_ sender: UIButton) {
//        let previousCategory = selectedCategory
        selectedCategory = 0
        self.activityListView.setState(state: .loading)
        self.activityListView.setState(state: .normal(items: activitiesList))
    }
    
    // MARK: - Custom functions
    
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
