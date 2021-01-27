//
//  FutureActivityCell.swift
//  WeatherActivity
//
//  Created by Infinum on 27.01.2021..
//

import UIKit

class FutureActivityCell: UITableViewCell, ActivityCellProtocol {
    
    @IBOutlet weak private var cellBody: UIStackView!
    @IBOutlet weak private var activityImage: UIImageView!
    @IBOutlet weak private var activityTitleLabel: UILabel!
    @IBOutlet weak private var activityLocationLabel: UILabel!
    @IBOutlet weak private var activityDateLabel: UILabel!
    @IBOutlet weak private var activityTimeLabel: UILabel!
    
    let timeDetailsManager = TimeDetailsManager()
    var cell: UITableViewCell { return self }
    
    func configure(with item: ActivityCellItemProtocol) {
        setUpLabels(item: item)
    }
    
    func setUpLabels(item: ActivityCellItemProtocol) {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date())
        let endDate = calendar.startOfDay(for: timeDetailsManager.getDateFromString(timestamp: item.startTime))
        let inDays = calendar.dateComponents([.day], from: startDate, to: endDate)
        guard let inDaysString = inDays.day else { return }

        activityTitleLabel.text = item.title
        activityDateLabel.text = timeDetailsManager.getCustomFormatFromDate(timestamp: item.startTime, format: DateTimeFormat.dayMonth.rawValue) + " " + timeDetailsManager.getCustomFormatFromDate(timestamp: item.startTime, format: DateTimeFormat.hoursMinutes.rawValue)
        activityTimeLabel.text =  "in \(String(inDaysString)) days"
        activityTimeLabel.textColor = UIColor.CustomGreen
        activityTimeLabel.font = UIFont.boldSystemFont(ofSize: 16)
        activityLocationLabel.text = item.locationName
        activityImage.image = UIImage(named: item.name.lowercased())
    }
}
