//
//  ActivityDetailsViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 18.12.2020..
//

import UIKit

class ActivityDetailsViewController: UIViewController {

    @IBOutlet weak private var activityTitle: UILabel!
    @IBOutlet weak private var activityDate: UILabel!
    @IBOutlet weak private var activityTime: UILabel!
    @IBOutlet weak private var activityDescription: UILabel!
    @IBOutlet weak private var activityCategory: UILabel!
    @IBOutlet weak private var activityImageView: UIImageView!
    @IBOutlet weak private var activityLocation: UILabel!
    @IBOutlet weak private var titleUIView: UIView!
    @IBOutlet weak private var bodyUIView: UIView!
    
    
    var localActivity: ActivityCellItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleUIView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bodyUIView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        guard let localActivity = localActivity else {
            return
        }
        activityTitle.text = localActivity.title
//        activityDate.text = localActivity.startTime
//        activityTime.text = localActivity.endTime
        activityDescription.text = localActivity.description
        activityCategory.text = String(localActivity.categoryId)
        activityImageView.image = UIImage(named: "logoWeather")
        activityLocation.text = localActivity.locationName
    }
    
    func commonInit(activity: ActivityCellItem) {
        localActivity = activity
    }
}
