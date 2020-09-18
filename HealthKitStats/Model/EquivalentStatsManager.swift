//
//  EquivalentStatsManager.swift
//  HealthKitStats
//
//  Created by Bailey Search on 17/09/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import Foundation

// Each stat will use its own object which defines description and the size of it
class EquivalentObjects {
    var description: String
    var size: Double // The size of the measured unit e.g. length of a marathon
    var isPercentage: Bool
    var rawValue: Double
    
    init(rawValue: Double, isPercentage: Bool,description: String, size: Double) {
        self.rawValue = rawValue
        self.isPercentage = isPercentage
        self.description = description
        self.size = size
    }

    // Calculate result of the division and return whole number or decimal depending on wholeNum variable
    var result: String {
        var result: String
        
        if (isPercentage) {
            result = String(format: "%.2f", (rawValue / size)*100)
        } else {
            result = String(format: "%.0f", rawValue / size)
        }
        return result
    }
    
    // Calculate a string which replaces dollar signs with the calculated result
    var strResult: String {
        return description.replacingOccurrences(of: "$", with: String(result))
    }
}

class EquivalentStatsManager {
    
    var completedResults: [EquivalentObjects] = []
    
    func calculate(value: Double, unit: String){
        // Check for the units so you know what the stat can be measured against eg miles vs flights of stairs
        switch(unit){
        case "miles":
            completedResults = milesStats(value: value)
            break
        case "flights":
            completedResults = flightsStats(value: value)
            break
        case "hours":
            completedResults = hourStats(value: value)
            break
        default:
//            fatalError("Error: Invalid Unit Type")
            print("Error: Invalid Unit Type")
            break
        }
        
        // Sort the array so the results are ordered from most number of things to least
        completedResults = completedResults.sorted(by: {Double($0.result) ?? 0.0 > Double($1.result) ?? 0.0})
    }
    
    /*
     Functions below return an array of equivalent stats objects which is calculated based on the unit and the value passed in.
     */
    func milesStats(value: Double) -> [EquivalentObjects]{
        return [
            EquivalentObjects(rawValue: value, isPercentage: false, description: "$ Standard Marathons", size: 26.2),
            EquivalentObjects(rawValue: value, isPercentage: true, description: "Distance around $% of the Earth", size: 24901.451),
        ]
    }
    
    func flightsStats(value: Double) -> [EquivalentObjects]{
        // Stairs in a flight = 12 steps
        return [
            EquivalentObjects(rawValue: value, isPercentage: false, description: "$ Burj Khalifas", size: 242), // 2909 stairs to level 160
            EquivalentObjects(rawValue: value, isPercentage: false, description: "$ Eiffel Towers", size: 56), // 674 steps to the 2nd floor
            EquivalentObjects(rawValue: value, isPercentage: false, description: "$ Empire State Building", size: 131), // 1576 steps
        ]
    }

    func hourStats(value: Double) -> [EquivalentObjects]{
        // Stairs in a flight = 12 steps
        return [
            EquivalentObjects(rawValue: value, isPercentage: false, description: "$ Days", size: 24), // 24 hours
            EquivalentObjects(rawValue: value, isPercentage: false, description: "$ Weeks", size: 168), // 24 * 7
            EquivalentObjects(rawValue: value, isPercentage: false, description: "$ Years", size: 8760), // 24 * 365
        ]
    }
}
