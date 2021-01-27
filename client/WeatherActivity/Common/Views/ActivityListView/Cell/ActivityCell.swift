//
//  ActivityCell.swift
//  WeatherActivity
//
//  Created by Infinum on 06.12.2020..
//

import UIKit

class ActivityCell: UITableViewCell, ActivityCellProtocol {
    var cell: UITableViewCell { return self }
    static var reuseIdentifier: String { return "ActivityCell" }

    @IBOutlet weak private var activityTitle: UILabel!
    @IBOutlet weak private var activityLocation: UILabel!
    @IBOutlet weak private var activityTime: UILabel!
    @IBOutlet weak private var activityDate: UILabel!
    @IBOutlet weak private var activityImage: UIImageView!
    @IBOutlet weak private var cellBody: UIView!
    
    func configure(with item: ActivityCellItemProtocol) {
        let dateFormatter = DateFormatter()
        let timestamp = TimeDetailsManager().getCorrectDateAsString(from: item.startTime)
//        guard let timestamp = dateTime else { return }
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.string(from: timestamp)
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: timestamp)
        activityTitle.text = item.title
        activityLocation.text = item.locationName
        activityDate.text = date
        activityTime.text = time
        activityImage.image = UIImage(named: item.name.lowercased())
    }
}
