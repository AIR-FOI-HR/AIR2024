//
//  ActivityCellProtocol.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 27.01.2021..
//

import UIKit

protocol ActivityCellProtocol {
    var cell: UITableViewCell { get }
    func configure(with item: ActivityCellItemProtocol)
}
