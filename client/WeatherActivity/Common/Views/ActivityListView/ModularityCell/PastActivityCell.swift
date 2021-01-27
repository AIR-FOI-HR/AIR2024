//
//  PastActivityCell.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 27.01.2021..
//

import UIKit

class PastActivityCell: UITableViewCell, ActivityCellProtocol {
    var cell: UITableViewCell { return self }
    
    @IBOutlet weak private var cellBody: UIStackView!
    @IBOutlet weak private var activityImage: UIImageView!
    @IBOutlet weak private var activityTitleLabel: UILabel!
    @IBOutlet weak private var activityLocationLabel: UILabel!
    @IBOutlet weak private var activityDateLabel: UILabel!
    
    
    func configure(with item: ActivityCellItemProtocol) {
        cellBody.backgroundColor = item.color
        activityTitleLabel.text = item.title
        activityDateLabel.text = item.startTime
        activityLocationLabel.text = item.locationName
        activityImage.image = UIImage(named: item.name.lowercased())
    }
}
