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
    
    @IBOutlet private var activityListView: UITableView!
    static private let cellIdentifier = "ActivityCell"
    static private let xibFileName = "ActivityListView"
    
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
    
    func showLoading() {
        activityListView.showAnimatedGradientSkeleton()
    }
    
    func reload(with items: [ActivityCellItem]) {
        dataSource = items
        activityListView.hideSkeleton(reloadDataAfter: true)
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
