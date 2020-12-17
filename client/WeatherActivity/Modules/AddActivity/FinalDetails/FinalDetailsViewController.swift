//
//  FinalDetailsViewController.swift
//  WeatherActivity
//
//  Created by Infinum on 03.12.2020..
//

import UIKit

//MARK: - Enums

enum FinalDetailsAlertMessages: String {
    case textFieldsAlertTitle = "Err.. It looks like there are some empty fields"
    case textFieldsAlertTMessage = "Make sure to fill them up so you can have better insight in your activities!"
    case activityTypeAlertTTitle = "Err.. It looks like you didnt select activity type"
    case activityTypeAlertTMessage = "Make sure to do it so you can have better insight in your activities!"
    case supportedWeatherAlertTTitle = "Err.. It looks like you didnt select any supported weathers"
    case supportedWeatherAlertTMessage = "Make sure to select them so we can let you know when the weather changes"
}

enum SelectedActivityType: Int {
    case indoor = 3
    case outdoor = 4
}

enum WeatherType: String, CaseIterable {
    case sunny = "Sunny"
    case cloudy = "Cloudy"
    case sunCloudy = "SunCloudy"
    case rainy = "Rainy"
    case foggy = "Foggy"
    case snowy = "Snowy"
    case stormy = "Stormy"
    case windy = "Windy"
}

//MARK: - Weather class

class Weather {
    var typeOfWeather: WeatherType
    var name: String? { typeOfWeather.rawValue }
    var image: UIImage? { UIImage(named: typeOfWeather.rawValue) }
    
    init(type: WeatherType) {
        self.typeOfWeather = type
    }
}

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

    var isSelectedActivityType = false
    var selectedActivityType = SelectedActivityType.indoor.rawValue
    var selectedSupportedWeathers = [String]()
    
    //MARK: - IBActions
    
    @IBAction func typeOfActivityPressed(_ sender: UIButton) {
        if isSelectedActivityType == true {
            let selectedTag = sender.tag
            let current = self.view.viewWithTag(selectedTag)
            sender.selectedOutdoorIndoor(current as! UIButton)
            
            let previous = self.view.viewWithTag(selectedActivityType)
            sender.deselectedOutdoorIndoor(previous as! UIButton)
            
            if selectedTag == SelectedActivityType.indoor.rawValue {
                selectedActivityType = SelectedActivityType.indoor.rawValue
            } else {
                selectedActivityType = SelectedActivityType.outdoor.rawValue
            }
        } else {
            let selectedTag = sender.tag
            let current = self.view.viewWithTag(sender.tag)
            sender.selectedOutdoorIndoor(current as! UIButton)
            
            if selectedTag == SelectedActivityType.indoor.rawValue {
                selectedActivityType = SelectedActivityType.indoor.rawValue
            } else {
                selectedActivityType = SelectedActivityType.outdoor.rawValue
            }
            isSelectedActivityType = true
        }
    }
    
    @IBAction func addActivityClick(_ sender: UIButton) {
        
        guard let title = titleTextField.text, let description = descriptionTextField.text else { return }
        
        if title.isEmpty || description.isEmpty {
            presentAlert(title: FinalDetailsAlertMessages.textFieldsAlertTitle.rawValue, message: FinalDetailsAlertMessages.textFieldsAlertTMessage.rawValue)
        } else if isSelectedActivityType == false {
            presentAlert(title: FinalDetailsAlertMessages.activityTypeAlertTTitle.rawValue, message: FinalDetailsAlertMessages.activityTypeAlertTMessage.rawValue)
        } else if selectedSupportedWeathers.isEmpty {
            presentAlert(title: FinalDetailsAlertMessages.supportedWeatherAlertTTitle.rawValue, message: FinalDetailsAlertMessages.supportedWeatherAlertTMessage.rawValue)
        }
        else {
            print(selectedActivityType)
            #warning("Proceed with future code")
        }
    }
    
    @IBAction func finalDetailsTextFieldDidBeginEditing(_ sender: UITextField) {
        sender.updateTextAppearanceOnFieldDidBeginEditing(sender)
    }
    
    @IBAction func finalDetailsTextFieldDidEndEditing(_ sender: UITextField) {
        sender.updateTextAppearanceOnFieldDidEndEditing(sender)
    }
    
    //MARK: - CollectionVIew handling
    
    let sunny = Weather(type: .sunny)
    let cloudy = Weather(type: .cloudy)
    let sunCloudy = Weather(type: .sunCloudy)
    let rainy = Weather(type: .rainy)
    let foggy = Weather(type: .foggy)
    let snowy = Weather(type: .snowy)
    let stormy = Weather(type: .stormy)
    let windy = Weather(type: .windy)
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WeatherType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? WeatherTypeCollectionViewCell else { fatalError() }
        
        let weatherNames = [sunny.name, cloudy.name, sunCloudy.name, rainy.name, foggy.name, snowy.name, stormy.name, windy.name]
        let weatherImages = [sunny.image, cloudy.image, sunCloudy.image, rainy.image, foggy.image, snowy.image, stormy.image, windy.image]
        
        cell.weatherLabel.text = weatherNames[indexPath.item]
        cell.weatherImageView.image = weatherImages[indexPath.item]
        
        return cell
    }
    
    //MARK: - CollectionVIew: SelectedItems
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.isSelected = true
        cell.layer.borderColor = UIColor(red:115/255, green:204/255, blue:255/255, alpha: 1).cgColor
        cell.layer.borderWidth = 1.0
        cell.layer.backgroundColor = UIColor(red:29/255, green:53/255, blue:66/255, alpha: 1).cgColor
        
        selectedSupportedWeathers.append(String(indexPath.item + 1))
    }
    
    //MARK: - CollectionVIew: DeselectedItems
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.isSelected = false
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 0
        cell.layer.backgroundColor = UIColor.systemGray6.cgColor
        
        guard let removeAt = selectedSupportedWeathers.firstIndex(of: "\(indexPath.item + 1)") else { return }
        selectedSupportedWeathers.remove(at: removeAt)
    }
}
