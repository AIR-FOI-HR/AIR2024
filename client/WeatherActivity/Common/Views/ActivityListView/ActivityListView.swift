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
    func didPressRow(activity: ActivityCellItemProtocol)
}

class ActivityListView: UIView, UITableViewDelegate {
    
    enum State {
        case loading
        case error
        case normal(items: [ActivityCellItemProtocol])
        case noActivities
        case noFilteredActivities
        case noActivitiesOnDate
    }
    
    @IBOutlet var activityListView: UITableView!
    @IBOutlet private var messageView: UIView!
    @IBOutlet private var message: UILabel!
    @IBOutlet private var button: UIButton!
    
    static private let cellIdentifier = "ActivityCell"
    static private let xibFileName = "ActivityListView"
    
    var state: State?
    
    weak var delegate: ActivityListViewDelegate?
    
    private var dataSource = [ActivityCellItemProtocol]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupActivityListView()
        activityListView.separatorStyle = .none
        activityListView.showsVerticalScrollIndicator = false
    }
    
    private func setupActivityListView() {
        activityListView.registerXibCell(fileName: "ActivityCell", withReuseIdentifier: "ActivityCell")
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
            showMessage(messageText: "Looks like you don't have any activities. Try adding some", buttonText: "")
            button.isHidden = true
        case .noFilteredActivities:
            showMessage(messageText: "Looks like your search didn't find anything... hmm try something else!", buttonText: "")
            button.isHidden = true
        case .noActivitiesOnDate:
            showMessage(messageText: "Looks like you don't have any activities on selected date. Try adding some", buttonText: "")
            button.isHidden = true
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
    
    private func reload(with items: [ActivityCellItemProtocol]) {
        dataSource = items
        if !activityListView.isSkeletonActive {
            showLoading()
        }
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
            break
        case .noActivitiesOnDate:
            break
        case .noFilteredActivities:
            break
        default:
            break
        }
    }
}

extension ActivityListView: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return Self.cellIdentifier
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ActivityCellProtocol
        let item = dataSource[indexPath.section]
        switch(item.statusType){
        case .past:
            let identifier = Identifier.pastIdentifier.rawValue
            activityListView.registerXibCell(fileName: identifier, withReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! PastActivityCell
        case .future:
            let identifier = Identifier.futureIdentifier.rawValue
            activityListView.registerXibCell(fileName: identifier, withReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! FutureActivityCell
        case .inProgress:
            let identifier = Identifier.inProgressIdentifier.rawValue
            activityListView.registerXibCell(fileName: identifier, withReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! InProgressActivityCell
        default:
            let identifier = Identifier.defaultIdentifier.rawValue
            print(item.title)
            activityListView.registerXibCell(fileName: identifier, withReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ActivityCell
        }
        
        cell.configure(with: item)
        return cell.cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.tintColor = .clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = delegate else {
            return
        }
        delegate.didPressRow(activity: dataSource[indexPath.section])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ActivityListView {
    static func loadFromXib() -> Self {
        return UINib(nibName: Self.xibFileName, bundle: Bundle(for: Self.self))
            .instantiate(withOwner: self, options: nil)
            .first as! Self
    }
}
