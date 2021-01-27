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
    @IBOutlet weak private var cellBody: UIStackView!
    @IBOutlet weak private var progressBar: UIProgressView!

    func configure(with item: ActivityCellItemProtocol) {
        let dateFormatter = DateFormatter()
        let dateTime = TimeDetailsManager().getCorrectDateAsString(from: item.startTime)
        guard let timestamp = dateTime else { return }
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.string(from: timestamp)
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: timestamp)
        cellBody.backgroundColor = item.color
        activityTitle.text = item.title
        activityLocation.text = item.locationName
        activityDate.text = date
        activityTime.text = time
        activityImage.image = UIImage(named: item.name.lowercased())
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let startDate = dateFormatter.date(from: item.startTime)!
        print(startDate)
        let duration = dateFormatter.date(from: item.endTime)!.timeIntervalSince(startDate)
        print(duration)
        let elapsed = dateFormatter.date(from: dateFormatter.string(from: Date()))!.timeIntervalSince(timestamp)
        print(elapsed)
        let percentage = elapsed / duration
    
        if(percentage >= 0 && percentage <= 1) {
            progressBar.progress = Float(percentage)
        } else {
            progressBar.isHidden = true
        }
    }
}
