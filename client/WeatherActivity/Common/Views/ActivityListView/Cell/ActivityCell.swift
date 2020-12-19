//
//  ActivityCell.swift
//  WeatherActivity
//
//  Created by Infinum on 06.12.2020..
//

import UIKit

struct ActivityCellItem {
    let activityId: Int
    let startTime: String
    let endTime: String
    let title: String
    let description: String
    let locationName: String
    let forecastId: Int
    let categoryId: Int
    let activityStatusId: Int
}

class ActivityCell: UITableViewCell {

    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var activityLocation: UILabel!
    @IBOutlet weak var activityTime: UILabel!
    @IBOutlet weak var activityDate: UILabel!
    @IBOutlet weak var activityImage: UIImageView!
    
    func configure(with item: ActivityCellItem) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let timestamp = dateFormatter.date(from: item.startTime)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.string(from: timestamp!)
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: timestamp!)
        
        activityTitle.text = item.title
        activityLocation.text = item.locationName
        activityDate.text = date
        activityTime.text = time
        #warning("adjust image")
    }
}