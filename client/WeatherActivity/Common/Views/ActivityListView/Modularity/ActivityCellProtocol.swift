//
//  ActivityCellProtocol.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 27.01.2021..
//

import UIKit

enum Identifier: String {
    case defaultIdentifier = "ActivityCell"
    case pastIdentifier = "PastActivityCell"
    case futureIdentifier = "FutureActivityCell"
    case inProgressIdentifier = "InProgressActivityCell"
}

protocol ActivityCellProtocol {
    var cell: UITableViewCell { get }
    func configure(with item: ActivityCellItemProtocol)
}
