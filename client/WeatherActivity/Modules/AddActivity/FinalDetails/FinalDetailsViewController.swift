//
//  FinalDetailsViewController.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 16.12.2020..
//

import UIKit

class FinalDetailsViewController: AddActivityStepViewController, SetupButtons {
    
    // MARK: - Properties
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate = self
        setupButtons(step: .finalDetails)
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        guard let flowNavigator = flowNavigator else { return }
        flowNavigator.showNextStep(
            from: .finalDetails,
            data: StepData(
                stepInfo: .finalDetails,
                data: FinalDetailsModel(
                    latitude: "some latitude in finals"
                )
            )
        )
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        guard let flowNavigator = flowNavigator else { return }
        flowNavigator.showPreviousStep()
    }
}

// MARK: - Setup Buttons Delegate

extension FinalDetailsViewController {
    
    func hideNextButton() {
        
        nextButton.isHidden = true
    }
    
    func hidePreviousButton() {
        
        backButton.isHidden = true
    }
}
