//
//  CategoryDetailsViewController.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 16.12.2020..
//

import UIKit

class CategoryDetailsViewController: AddActivityStepViewController, SetupButtons {
    
    // MARK: - Properties
    
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var inputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate = self
        setupButtons(step: .categoryDetails)
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        guard let flowNavigator = flowNavigator else { return }
        flowNavigator.showNextStep(
            from: .categoryDetails,
            data: StepData(
                stepInfo: .categoryDetails,
                data: CategoryDetailsModel(
                    category: "Some category"
                )
            )
        )
    }
    
    @IBAction func previousButtonPressed(_ sender: UIButton) {
        
        guard let flowNavigator = flowNavigator else { return }
        flowNavigator.showPreviousStep()
    }
}

// MARK: - Setup Buttons Delegate

extension CategoryDetailsViewController {
    
    func hideNextButton() {
        
        nextButton.isHidden = true
    }
    
    func hidePreviousButton() {
        
        backButton.isHidden = true
    }
}
