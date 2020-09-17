//
//  EquivalentStatsManager.swift
//  HealthKitStats
//
//  Created by Bailey Search on 17/09/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import Foundation

class EquivalentObjects {
    var description: String
    var units: String
    var size: Double // The size of the measured unit e.g. length of a marathon
    
    var wholeNum: Bool
    var rawValue: Double
    
    var strResult: String {

        var result: String
        
        if (wholeNum) {
            result = String(format: "%.0f", rawValue / size)
        } else {
            result = String(format: "%.2f", (rawValue / size)*100)
        }
        
        return description.replacingOccurrences(of: "$", with: result)
    }
    
    init(rawValue: Double, wholeNum: Bool,description: String, units: String, size: Double) {
        self.rawValue = rawValue
        self.wholeNum = wholeNum
        self.description = description
        self.units = units
        self.size = size
    }
}

class EquivalentStatsManager {
    
    var completedResults: [EquivalentObjects] = []
    
    func calculate(value: Double, unit: String){
        switch(unit){
        case "miles":
            completedResults = milesStats(value: value)
            break
        default:
            fatalError("Error: Invalid Unit Type")
            break
        }
    }
    
    func milesStats(value: Double) -> [EquivalentObjects]{
        
        struct test {
            
        }
    
        return [
            EquivalentObjects(rawValue: value, wholeNum: true, description: "$ Standard Marathons", units: "miles", size: 26.2),
            EquivalentObjects(rawValue: value, wholeNum: false, description: "Distance around $% of the Earth", units: "miles", size: 24901.451),
            EquivalentObjects(rawValue: value, wholeNum: false, description: "Desc", units: "miles", size: 75.00),

        ]
    }
}
