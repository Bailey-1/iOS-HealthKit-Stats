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
    
    var rawValue: Double
    
    var result: Double {
        return (rawValue / size)
    }
    
    init(rawValue: Double, description: String, units: String, size: Double) {
        self.rawValue = rawValue
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
            completedResults = milesStats()
            break
        default:
            fatalError("Error: Invalid Unit Type")
            break
        }
    }
    
    func milesStats() -> [EquivalentObjects]{
        return [
            EquivalentObjects(rawValue: 200.00, description: "Desc", units: "miles", size: 10.00),
            EquivalentObjects(rawValue: 200.00, description: "Desc", units: "miles", size: 100.00),
            EquivalentObjects(rawValue: 200.00, description: "Desc", units: "miles", size: 75.00),

        ]
    }
}
