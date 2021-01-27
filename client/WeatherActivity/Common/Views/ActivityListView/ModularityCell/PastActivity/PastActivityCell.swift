//
//  PastActivityCell.swift
//  WeatherActivity
//
//  Created by Infinum on 27.01.2021..
//

import UIKit

class PastActivityCell: UITableViewCell, ActivityCellProtocol {
    
    @IBOutlet weak private var cellBody: UIStackView!
    @IBOutlet weak private var activityImage: UIImageView!
    @IBOutlet weak private var activityTitleLabel: UILabel!
    @IBOutlet weak private var activityLocationLabel: UILabel!
    @IBOutlet weak private var activityDateLabel: UILabel!
    
    let timeDetailsManager = TimeDetailsManager()
    var cell: UITableViewCell { return self }
    
    func configure(with item: ActivityCellItemProtocol) {
        setUpLabels(item: item)
    }
    
    func setUpLabels(item: ActivityCellItemProtocol) {
        activityTitleLabel.text = item.title
        activityDateLabel.text = timeDetailsManager.getCustomFormatFromDate(timestamp: item.startTime, format: DateTimeFormat.dayMonthYear.rawValue)
        activityLocationLabel.text = item.locationName
        activityImage.image = UIImage(named: item.name.lowercased())
    }
}

