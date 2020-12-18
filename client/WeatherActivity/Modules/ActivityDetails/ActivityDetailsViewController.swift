//
//  ActivityDetailsViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 18.12.2020..
//

import UIKit

class ActivityDetailsViewController: UIViewController {

    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var activityDescription: UILabel!
    @IBOutlet weak var activityLocation: UILabel!
    @IBOutlet weak var activityDate: UILabel!
    @IBOutlet weak var activityTime: UILabel!
    
    var localActivity: ActivityCellItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let localActivity = localActivity else {
            return
        }
        activityTitle.text = localActivity.title
        activityDescription.text = localActivity.description
        activityLocation.text = localActivity.locationName
        activityDate.text = localActivity.startTime
        activityTime.text = localActivity.endTime
    }
    
    func commonInit(activity: ActivityCellItem) {
        localActivity = activity
    }
}
