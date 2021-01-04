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
}

enum SelectedActivityType: Int {
    case indoor = 3
    case outdoor = 4
}

enum WeatherType: String, CaseIterable {
    case sunny = "sunny"
    case cloudy = "cloudy"
    case sunCloudy = "sunCloudy"
    case rainy = "rainy"
    case foggy = "foggy"
    case snowy = "snowy"
    case stormy = "stormy"
    case windy = "windy"
}

//MARK: - WeatherCell class

class WeatherCell {
    var typeOfWeather: WeatherType
    var name: String? { typeOfWeather.rawValue.capitalizingFirstLetter() }
    var image: UIImage? { UIImage(named: typeOfWeather.rawValue) }
    
    init(type: WeatherType) {
        self.typeOfWeather = type
    }
}

final class FinalDetailsViewController: AddActivityStepViewController, UICollectionViewDelegate, UICollectionViewDataSource, ViewInterface {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak private var titleTextField: UITextField!
    @IBOutlet weak private var descriptionTextField: UITextField!
    @IBOutlet weak private var weathersCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weathersCollectionView.delegate = self
        weathersCollectionView.dataSource = self
        weathersCollectionView.allowsMultipleSelection = true
    }
    
    // MARK: - Properties

    var isSelectedActivityType = false
    var selectedActivityType = SelectedActivityType.indoor
    var selectedSupportedWeathers = [String]()
    
    //MARK: - IBActions
    
    @IBAction func typeOfActivityPressed(_ sender: UIButton) {
        if isSelectedActivityType == true {
            let selectedTag = sender.tag
            guard let current = self.view.viewWithTag(selectedTag), let newCurrent = current as? UIButton else { return }
            sender.selectedOutdoorIndoor(newCurrent)
            
            guard let previous = self.view.viewWithTag(selectedActivityType.rawValue), let newPrevious = previous as? UIButton else { return }
            sender.deselectedOutdoorIndoor(newPrevious)
            
            if selectedTag == SelectedActivityType.indoor.rawValue {
                selectedActivityType = SelectedActivityType.indoor
            } else {
                selectedActivityType = SelectedActivityType.outdoor
            }
        } else {
            let selectedTag = sender.tag
            guard let current = self.view.viewWithTag(sender.tag) else { return }
            sender.selectedOutdoorIndoor(current as! UIButton)
            
            if selectedTag == SelectedActivityType.indoor.rawValue {
                selectedActivityType = SelectedActivityType.indoor
            } else {
                selectedActivityType = SelectedActivityType.outdoor
            }
            isSelectedActivityType = true
        }
    }
    
    @IBAction func addActivityClick(_ sender: UIButton) {
        
        guard
            let title = titleTextField.text,
            let description = descriptionTextField.text
        else { return }
        
        if title.isEmpty || description.isEmpty {
            presentAlert(title: FinalDetailsAlertMessages.textFieldsAlertTitle.rawValue, message: FinalDetailsAlertMessages.textFieldsAlertTMessage.rawValue)
        } else if isSelectedActivityType == false {
            presentAlert(title: FinalDetailsAlertMessages.activityTypeAlertTTitle.rawValue, message: FinalDetailsAlertMessages.activityTypeAlertTMessage.rawValue)
        } else {
            guard
                let flowNavigator = flowNavigator
            else { return }
            flowNavigator.showNextStep(
                from: .finalDetails,
                data: StepData(
                    stepInfo: .finalDetails,
                    data: FinalDetails(
                        title: title,
                        description: description,
                        typeOfActivity: selectedActivityType.rawValue,
                        supportedWeather: selectedSupportedWeathers)
                )
            )
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        guard
            let flowNavigator = flowNavigator
        else { return }
        flowNavigator.showPreviousStep()
    }
    
    
    @IBAction func finalDetailsTextFieldDidBeginEditing(_ sender: UITextField) {
        sender.updateTextAppearanceOnFieldDidBeginEditing(sender)
    }
    
    @IBAction func finalDetailsTextFieldDidEndEditing(_ sender: UITextField) {
        sender.updateTextAppearanceOnFieldDidEndEditing(sender)
    }
    
    //MARK: - CollectionVIew handling
    
    var possibleWeathers: [WeatherCell] {
        [.init(type: .sunny), .init(type: .cloudy), .init(type: .sunCloudy), .init(type: .rainy), .init(type: .foggy), .init(type: .snowy), .init(type: .stormy), .init(type: .windy)]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WeatherType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? WeatherTypeCollectionViewCell else { fatalError() }
        
        var weatherNames = [String]()
        var weatherImages = [UIImage]()
        
        for item in possibleWeathers {
            if let weatherName = item.name {
                weatherNames.append(weatherName)
            }
        }
        for item in possibleWeathers {
            if let weatherImage = item.image {
                weatherImages.append(weatherImage)
            }
        }

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

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

// MARK: - Protocol ViewInteface

extension FinalDetailsViewController {
    
    func setAction(_ actiion: Action, hidden: Bool) {
        #warning("Set it up with proper buttons")
    }
}
