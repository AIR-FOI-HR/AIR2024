//
//  FinalDetailsViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 03.12.2020..
//

import UIKit

final class FinalDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak private var titleTextField: UITextField!
    @IBOutlet weak private var descriptionTextField: UITextField!
    @IBOutlet weak private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
    }
    
    // MARK: - Properties

    var selectedOutdoorIndoor = 0
    var selectedSupportedWeathers = [String]()
    
    //MARK: - IBActions
    
    @IBAction func outdoorIndoorPresed(_ sender: UIButton) {
        if(selectedOutdoorIndoor != 0){
            let current = self.view.viewWithTag(sender.tag)
            sender.selectedOutdoorIndoor(current as! UIButton)
            
            let previous = self.view.viewWithTag(selectedOutdoorIndoor)
            sender.deselectedOutdoorIndoor(previous as! UIButton)
            
            selectedOutdoorIndoor = sender.tag
        } else {
            let currentAvatar = self.view.viewWithTag(sender.tag)
            sender.selectedOutdoorIndoor(currentAvatar as! UIButton)
            
            selectedOutdoorIndoor = Int(sender.tag)
        }
    }
    
    @IBAction func addActivityClick(_ sender: UIButton) {
        
        guard let title = titleTextField.text, let description = descriptionTextField.text else { return }
        
        if title.isEmpty || description.isEmpty {
            presentAlert(title: "Err.. It looks like there are some empty fields", message: "Make sure to fill them up so you can have better insight in your activities!")
        } else {
            //proceed with future code
        }
    }
    
    @IBAction func finalDetailsTextFieldDidBeginEditing(_ sender: UITextField) {
        sender.updateTextAppearanceOnFieldDidBeginEditing(sender)
    }
    
    @IBAction func finalDetailsTextFieldDidEndEditing(_ sender: UITextField) {
        sender.updateTextAppearanceOnFieldDidEndEditing(sender)
    }
    
    //MARK: - CollectionVIew handling
    
    let weatherType = ["Sunny", "Cloudy", "Suncloudy", "Rainy", "Foggy", "Snowy", "Stormy", "Windy"]
    
    let weatherTypeImages: [UIImage] = [
        
        UIImage(named: "sunny")!,
        UIImage(named: "cloudy")!,
        UIImage(named: "partlyCloudy")!,
        UIImage(named: "rainy")!,
        UIImage(named: "foggy")!,
        UIImage(named: "snowy")!,
        UIImage(named: "stormy")!,
        UIImage(named: "windy")!
    ]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.weatherLabel.text = weatherType[indexPath.item]
        cell.weatherImageView.image = weatherTypeImages[indexPath.item]
        
        return cell
    }
    
    //MARK: - CollectionVIew: SelectedItems
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isSelected = true
        cell?.layer.borderColor = UIColor(red:115/255, green:204/255, blue:255/255, alpha: 1).cgColor
        cell?.layer.borderWidth = 1.0
        cell?.layer.backgroundColor = UIColor(red:29/255, green:53/255, blue:66/255, alpha: 1).cgColor
        
        selectedSupportedWeathers.append(String(indexPath.item + 1))
    }
    
    //MARK: - CollectionVIew: DeselectedItems
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isSelected = false
        cell?.layer.borderColor = UIColor.white.cgColor
        cell?.layer.borderWidth = 0
        cell?.layer.backgroundColor = UIColor.systemGray6.cgColor
        
        for (index, value) in selectedSupportedWeathers.enumerated(){
            if value == "\(indexPath.item + 1)" {
                selectedSupportedWeathers.remove(at: index)
            }
        }
    }
}
