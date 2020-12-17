//
//  WeatherTypeCollectionViewCell.swift
//  WeatherActivity
//
//  Created by Infinum on 04.12.2020..
//

import UIKit

class WeatherTypeCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    
    //MARK: - Selected cells text handling
    
    override var isSelected: Bool {
        didSet {
            weatherLabel.textColor = isSelected ? .white : .black
        }
    }
    
}
