//
//  CurrentActivityCell.swift
//  WeatherActivity
//
//  Created by Infinum on 27.01.2021..
//

import UIKit

class InProgressActivityCell: UITableViewCell, ActivityCellProtocol {
    
    @IBOutlet weak private var cellBody: UIStackView!
    @IBOutlet weak private var activityImage: UIImageView!
    @IBOutlet weak private var activityTitleLabel: UILabel!
    @IBOutlet weak private var activityLocationLabel: UILabel!
    @IBOutlet weak private var activityDateLabel: UILabel!
    @IBOutlet weak var activityTimeLabel: UILabel!
    @IBOutlet weak private var progressBar: UIProgressView!
    
    let timeDetailsManager = TimeDetailsManager()
    var cell: UITableViewCell { return self }
    
    func configure(with item: ActivityCellItemProtocol) {
        setUpLabels(item: item)
        setProgressBar(item: item)
    }
    
    func setUpLabels(item: ActivityCellItemProtocol) {
        activityTitleLabel.text = item.title
        activityDateLabel.text = timeDetailsManager.getCustomFormatFromDate(timestamp: item.startTime, format: DateTimeFormat.dayMonth.rawValue)
        activityTimeLabel.text = timeDetailsManager.getCustomFormatFromDate(timestamp: item.startTime, format: DateTimeFormat.hoursMinutes.rawValue) + " - " + timeDetailsManager.getCustomFormatFromDate(timestamp: item.endTime, format: DateTimeFormat.hoursMinutes.rawValue)
        activityLocationLabel.text = item.locationName
        activityImage.image = UIImage(named: item.name.lowercased())
    }
    
    func setProgressBar(item: ActivityCellItemProtocol){
        let timestamp = timeDetailsManager.getCorrectDateAsString(from: item.startTime)
        let startDate = timeDetailsManager.getRealDateFromString(timestamp: item.startTime)
        let duration = timeDetailsManager.getRealDateFromString(timestamp: item.endTime).timeIntervalSince(startDate)
        let elapsed = Date().timeIntervalSince(timestamp)
        let percentage = elapsed / duration
        progressBar.progress = Float(percentage)
    }
}
