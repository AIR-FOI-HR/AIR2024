//
//  AddActivityFlowDataManager.swift
//  WeatherActivity
//
//  Created by Kevin Bogdan on 17.12.2020..
//

import Foundation

class AddActivityFlowDataManager {
    
    var stepsData: [StepData] = []
    
    func saveData(data: StepData) {
        
        stepsData.append(data)
        dataToJson()
    }
    
    func dataToJson() {
        #warning("Preparing, ignore")
        var dictionary = [String:Any]()
        stepsData.forEach { (stepData) in
            if let dictionaryInfo = try? stepData.data.asDictionary() {
                dictionary[stepData.stepInfo.rawValue] = dictionaryInfo
            }
        }
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .fragmentsAllowed)
        let json = String(data: data!, encoding: .ascii)
        print("Dictionary: \(dictionary)")
        print("Json: \(json)")
    }
}
