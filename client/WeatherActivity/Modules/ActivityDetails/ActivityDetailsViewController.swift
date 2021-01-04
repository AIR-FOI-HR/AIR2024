//
//  ActivityDetailsViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 18.12.2020..
//

import UIKit

class ActivityDetailsViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak private var activityTitle: UILabel!
    @IBOutlet weak private var activityDate: UILabel!
    @IBOutlet weak private var activityTime: UILabel!
    @IBOutlet weak private var activityDescription: UILabel!
    @IBOutlet weak private var activityCategory: UILabel!
    @IBOutlet weak private var activityImageView: UIImageView!
    @IBOutlet weak private var activityLocation: UILabel!
    @IBOutlet weak private var activityStatus: UILabel!
    @IBOutlet weak private var titleUIView: UIView!
    @IBOutlet weak private var bodyUIView: UIView!
    
    //MARK: - Properties
    
    var localActivity: ActivityCellItem?
    var color: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleUIView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bodyUIView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        switch localActivity?.activityStatusId {
        case 1:
            color = UIColor(red: 59.0/255.0, green: 245.0/255.0, blue: 170.0/255.0, alpha: 1)
        case 2:
            color = UIColor(red: 242.0/255.0, green: 146.0/255.0, blue: 97.0/255.0, alpha: 1)
        default:
            color = UIColor(red: 59.0/255.0, green: 245.0/255.0, blue: 170.0/255.0, alpha: 1)
        }
        
        guard let localActivity = localActivity else {
            return
        }
        activityTitle.text = localActivity.title
        activityStatus.text = String(localActivity.activityStatusId)
        activityStatus.backgroundColor = color
        activityDate.text = getDate(timestamp: localActivity.startTime)
        activityTime.text = getTime(timestamp: localActivity.startTime)
        activityDescription.text = localActivity.description
        activityCategory.text = String(localActivity.categoryId)
        activityImageView.image = UIImage(named: "logoWeather")
        activityLocation.text = localActivity.locationName
    }
    
    //MARK: - Functions
    
    func getDate(timestamp: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy"

        guard let date = dateFormatterGet.date(from: timestamp) else { return "Err" }
        return dateFormatterPrint.string(from: date)
    }
    
    func getTime(timestamp: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "HH:mm:ss"

        guard let time = dateFormatterGet.date(from: timestamp) else { return "Err" }
        return dateFormatterPrint.string(from: time)
    }
    
    func commonInit(activity: ActivityCellItem) {
        localActivity = activity
    }
}
