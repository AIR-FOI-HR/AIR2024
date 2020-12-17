//
//  AddActivityFlowNavigator.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 17.12.2020..
//

import UIKit

class AddActivityFlowNavigator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController?
    let steps: [StepInfo]
    let initialStep: StepInfo
    let dataFlowManager = AddActivityFlowDataManager()
    
    init(navigationController: UINavigationController, steps: [StepInfo]) {
        self.steps = steps
        self.initialStep = steps[0]
        self.navigationController = navigationController
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Methods
    
    func presentFlow(from: UIViewController) {
        
        let storyboard = UIStoryboard(name: initialStep.rawValue, bundle: nil)
        guard
            let stepViewController = storyboard.instantiateViewController(identifier: initialStep.rawValue) as? AddActivityStepViewController
        else { return }
        stepViewController.flowNavigator = self
        navigationController?.viewControllers = [stepViewController]
        from.present(navigationController!, animated: true, completion: nil)
    }
    
    func showNextStep(from: StepInfo, data: StepData) {
        #warning("Handle if last step -> submit data")
        dataFlowManager.saveData(data: data)
        
        guard let currentStep = steps.firstIndex(of: from) else { return }
        let nextStep = steps[currentStep + 1]
        let storyboard = UIStoryboard(name: nextStep.rawValue, bundle: nil)
        let stepViewController = storyboard.instantiateViewController(identifier: nextStep.rawValue) as! AddActivityStepViewController
        stepViewController.flowNavigator = self
        navigationController?.pushViewController(stepViewController, animated: true)
    }
    
    func showPreviousStep() {
        
        navigationController?.popViewController(animated: true)
    }
    
    func dismissFlow() {
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func isLastStep(step: StepInfo) -> Bool {
        
        return steps.firstIndex(of: step) == steps.count - 1
    }
    
    func isFirstStep(step: StepInfo) -> Bool {
        
        return steps.firstIndex(of: step) == 0
    }
}
