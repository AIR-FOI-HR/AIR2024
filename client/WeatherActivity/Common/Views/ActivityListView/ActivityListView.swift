//
//  ActivityListView.swift
//  WeatherActivity
//
//  Created by Infinum on 06.12.2020..
//

import Foundation
import UIKit
import SkeletonView

protocol ActivityListViewDelegate: AnyObject {
    func didPressReloadAction()
}

class ActivityListView: UIView, UITableViewDelegate {
    
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
    
    weak var delegate: ActivityListViewDelegate?
    
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
        activityListView.delegate = self
    }
    
    func setState(state: State) {
        self.state = state
        switch state {
        case .error:
            showMessage(messageText: "Errr... there seems to be something missing here... try refreshing", buttonText: "Refresh")
        case .loading:
            messageView.isHidden = true
            showLoading()
        case .normal(items: let items):
            messageView.isHidden = true
            reload(with: items)
        case .noActivities:
            showMessage(messageText: "Looks like you don't have any activities. Try adding some", buttonText: "Add activity")
        }
    }
    
    private func showMessage(messageText: String, buttonText: String) {
        messageView.isHidden = false
        message.text = messageText
        button.setTitle(buttonText, for: .normal)
        activityListView.hideSkeleton()
    }
    
    private func showLoading() {
        activityListView.showAnimatedGradientSkeleton()
    }
    
    private func reload(with items: [ActivityCellItem]) {
        dataSource = items
        activityListView.hideSkeleton(reloadDataAfter: true)
    }
    
    @IBAction func didClickButton(_ sender: UIButton) {
        guard let delegate = delegate else {
            return
        }
        
        switch state {
        case .error:
            delegate.didPressReloadAction()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(dataSource[indexPath.row])
    }
}

extension ActivityListView {
    static func loadFromXib() -> Self {
        return UINib(nibName: Self.xibFileName, bundle: Bundle(for: Self.self))
            .instantiate(withOwner: self, options: nil)
            .first as! Self
    }
}
