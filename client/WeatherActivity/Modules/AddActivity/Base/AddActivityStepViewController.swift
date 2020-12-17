//
//  AddActivityStepViewController.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 17.12.2020..
//

import UIKit

// MARK: - Protocol

protocol SetupButtons {
    func hideNextButton()
    func hidePreviousButton()
}

class AddActivityStepViewController: UIViewController {
    
    // MARK: - Properties
    
    var flowNavigator: AddActivityFlowNavigator?
    var setupDelegate: SetupButtons?
    
    // MARK: - Methods
    
    func setupButtons(step: StepInfo) {
        
        guard let flowNavigator = flowNavigator else { return }
        
        if flowNavigator.isLastStep(step: step) {
            #warning("On last step: instead of next -> Submit")
            setupDelegate?.hideNextButton()
        }
        
        if flowNavigator.isFirstStep(step: step) {
            setupDelegate?.hidePreviousButton()
        }
        
    }
}
