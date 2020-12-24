//
//  FinalDetailsViewController.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 16.12.2020..
//

import UIKit

class FinalDetailsViewController: AddActivityStepViewController, ViewInterface {
    
    // MARK: - Properties
    
    @IBOutlet private weak var inputTextField: UITextField!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var locationDataLabel: UILabel!
    @IBOutlet private weak var timeDataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate = self
        setupButtons(step: .finalDetails)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard
            let flowNavigator = flowNavigator,
            let locationData: LocationDetailsModel = flowNavigator.dataFlowManager.getData(forStep: .locationDetails),
            let timeData: TimeDetailsModel = flowNavigator.dataFlowManager.getData(forStep: .timeDetails)
        else { return }
        locationDataLabel.text = locationData.latitude
        timeDataLabel.text = timeData.time
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
