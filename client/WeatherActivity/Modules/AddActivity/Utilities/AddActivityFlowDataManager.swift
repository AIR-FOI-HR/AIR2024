//
//  AddActivityFlowDataManager.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 17.12.2020..
//

import Foundation

class AddActivityFlowDataManager {
    
    // MARK: - Properties
    
    var stepsData: [StepData] = []
    
    // MARK: - Methods
    
    func saveData(data: StepData) {
        
        stepsData.removeAll(where: { $0.stepInfo == data.stepInfo })
        stepsData.append(data)
    }
    
    func dataToJson() -> String? {
        
        var dictionary = [String:Any]()
        stepsData.forEach { (stepData) in
            if let dictionaryInfo = try? stepData.data.asDictionary() {
                dictionary[stepData.stepInfo.rawValue] = dictionaryInfo
            }
        }
        #warning("Handle if failed to parse to JSON")
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .fragmentsAllowed) else { return nil }
        let json = String(data: data, encoding: .ascii)
        return json
    }
    
    func getData<T>(forStep step: StepInfo) -> T? {
        
        guard let data = stepsData
                .first(where: { $0.stepInfo == step })
                .map({ $0.data })
        else { return nil }
        return data as? T
    }
}
