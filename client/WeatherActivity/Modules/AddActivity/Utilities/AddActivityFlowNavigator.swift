//
//  AddActivityFlowNavigator.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 17.12.2020..
//

import UIKit

protocol AddActivityFlowNavigatorDelegate: AnyObject {
    func didFinishInsert()
}

class AddActivityFlowNavigator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController?
    let steps: [StepInfo]
    let initialStep: StepInfo
    let dataFlowManager = AddActivityFlowDataManager()
    
    weak var delegate: AddActivityFlowNavigatorDelegate?
    
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
        
        if (isLastStep(step: from)) {
            dataFlowManager.saveData(data: data)
            guard
                let jsonData = dataFlowManager.dataToJson()
            else { return }
            ActivityService().insertActivities(activityData: jsonData) { (provjera) -> Void in
                print(provjera)
                self.dismissFlow()
                self.delegate?.didFinishInsert()
            } failure: { (error) in
                print(error)
            }
            
        }
        else {
            dataFlowManager.saveData(data: data)
            
            guard let currentStep = steps.firstIndex(of: from) else { return }
            let nextStep = steps[currentStep + 1]
            let storyboard = UIStoryboard(name: nextStep.rawValue, bundle: nil)
            guard
                let stepViewController = storyboard.instantiateViewController(identifier: nextStep.rawValue) as? AddActivityStepViewController
            else { return }
            stepViewController.flowNavigator = self
            navigationController?.pushViewController(stepViewController, animated: true)
        }
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
