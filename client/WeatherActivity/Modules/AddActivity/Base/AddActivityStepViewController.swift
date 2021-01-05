//
//  AddActivityStepViewController.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 17.12.2020..
//

import UIKit

// MARK: - Buttons actions

enum Action {
    case previous
    case next
    case submit
}

// MARK: - Protocol

protocol ViewInterface {
    
    func setAction(_ action: Action, hidden: Bool)
}

class AddActivityStepViewController: UIViewController {
    
    // MARK: - Properties
    
    var flowNavigator: AddActivityFlowNavigator?
    var setupDelegate: ViewInterface?
    
    // MARK: - Methods
    
    func setupButtons(step: StepInfo) {
        
        guard let flowNavigator = flowNavigator else { return }
        
        if flowNavigator.isLastStep(step: step) {
            
            setupDelegate?.setAction(.submit, hidden: true)
        }
        
        if flowNavigator.isFirstStep(step: step) {
            
            setupDelegate?.setAction(.previous, hidden: true)
        }
        
    }
}
