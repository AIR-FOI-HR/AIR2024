//
//  LocationDetailsViewController.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 16.12.2020..
//

import UIKit

class LocationDetailsViewController: AddActivityStepViewController, ViewInterface {
    
    // MARK: - Properties
    
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var inputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate = self
        setupButtons(step: .locationDetails)
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        guard let flowNavigator = flowNavigator else { return }
        flowNavigator.showPreviousStep()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        guard let flowNavigator = flowNavigator else { return }
        flowNavigator.showNextStep(
            from: .locationDetails,
            data: StepData(
                stepInfo: .locationDetails,
                data: LocationDetailsModel(
                    latitude: inputTextField.text ?? "22.33")
            )
        )
    }
}

// MARK: - Setup Buttons Delegate

extension LocationDetailsViewController {
    
    func setAction(_ action: Action, hidden: Bool) {
        switch(action) {
        case .next:
            nextButton.isHidden = hidden
        case .previous:
            backButton.isHidden = hidden
        case .submit:
            nextButton.setTitle("Submit", for: .normal)
        }
    }
}
