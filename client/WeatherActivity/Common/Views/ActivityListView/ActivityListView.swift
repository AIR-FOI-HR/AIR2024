//
//  ActivityListView.swift
//  WeatherActivity
//
//  Created by Infinum on 06.12.2020..
//

import Foundation
import UIKit
import SkeletonView

class ActivityListView: UIView {
    
    enum State {
        case loading
        case error
        case normal(items: [ActivityCellItem])
        case noActivities
    }
    
    @IBOutlet private var activityListView: UITableView!
    @IBOutlet private var messageView: UIView!
    @IBOutlet private var message: UILabel!
    @IBOutlet private var button: UIButton!
    
    static private let cellIdentifier = "ActivityCell"
    static private let xibFileName = "ActivityListView"
    
    var state: State?
    
    var delegateHomeViewController: HomeViewController?
    
    private var dataSource = [ActivityCellItem]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupActivityListView()
    }
    
    private func setupActivityListView() {
        activityListView.registerXibCell(fileName: Self.cellIdentifier, withReuseIdentifier: Self.cellIdentifier)
        activityListView.rowHeight = 100
        activityListView.estimatedRowHeight = 100
        activityListView.isSkeletonable = true
        activityListView.dataSource = self
    }
    
    func setState(state: State) {
        self.state = state
        switch state {
        case .error:
            messageView.isHidden = false
            message.text = "Errr... there seems to be something missing here... try refreshing"
            button.setTitle("Refresh", for: .normal)
            stopLoading()
        case .loading:
            messageView.isHidden = true
            showLoading()
        case .normal(items: let items):
            messageView.isHidden = true
            reload(with: items)
        case .noActivities:
            messageView.isHidden = false
            message.text = "Looks like you don't have any activities. Try adding some"
            button.setTitle("Add activity", for: .normal)
            stopLoading()
        }
    }
    
    private func showLoading() {
        activityListView.showAnimatedGradientSkeleton()
    }
    
    private func stopLoading() {
        activityListView.hideSkeleton()
    }
    
    private func reload(with items: [ActivityCellItem]) {
        dataSource = items
        activityListView.hideSkeleton(reloadDataAfter: true)
    }
    
    @IBAction func didClickButton(_ sender: UIButton) {
        switch state {
        case .error:
            delegateHomeViewController?.loadActivities()
        case .loading:
            break
        case .normal(items: _):
            break
        case .noActivities:
            #warning("addActivityFunction")
        default:
            break
        }
    }
}

extension ActivityListView: SkeletonTableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return Self.cellIdentifier
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath) as! ActivityCell
        let item = dataSource[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}

extension ActivityListView {
    static func loadFromXib() -> Self {
        return UINib(nibName: Self.xibFileName, bundle: Bundle(for: Self.self))
            .instantiate(withOwner: self, options: nil)
            .first as! Self
    }
}
