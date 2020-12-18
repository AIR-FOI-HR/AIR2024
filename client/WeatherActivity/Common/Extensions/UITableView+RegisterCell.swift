//
//  UITableView+RegisterCell.swift
//  WeatherActivity
//
//  Created by Infinum on 06.12.2020..
//

import UIKit

extension UITableView {
    func registerXibCell(fileName: String, withReuseIdentifier identifier: String) {
        let nib = UINib(nibName: fileName, bundle: nil)
        register(nib, forCellReuseIdentifier: identifier)
    }
}
