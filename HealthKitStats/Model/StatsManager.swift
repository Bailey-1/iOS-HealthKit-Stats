//
//  StatsManager.swift
//  HealthKitStats
//
//  Created by Bailey Search on 16/09/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import Foundation
import HealthKit

struct statsObject {
    var name: String = "" // Description
    var strValue: String = "" // For displaying raw value
    var rawValue: Double = 0.0 // For calculating with raw value
    var units: String = "" // For determining comparisons
    var position: Int = 0;
}

protocol StatsManagerProtocol {
    func updateTableView()
}

class StatsManager {
    
    let healthStore = HKHealthStore()
    
    // 2D array for each of the unique sections
    var statsArray: [[statsObject]] = [[],[],[],[],[],[]]
    var statsArrayTitles = ["Activity", "Walking / Running", "Swimming", "Wheelchair Use", "Cycling", "Downhill Sports"]
    
    var delegate: StatsManagerProtocol?
    
    func checkAuth(duration: Int){
        // Set required properties to be read from HealthKit https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier
        let healthKitTypes: Set = [ HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.flightsClimbed)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.appleStandTime)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.appleExerciseTime)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceSwimming)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.swimmingStrokeCount)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.pushCount)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWheelchair)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceCycling)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceDownhillSnowSports)!,
        ]
        
        // Request read only access to users healthkit data
        healthStore.requestAuthorization(toShare: nil, read: healthKitTypes) { (bool, error) in
            if let safeError = error {
                // This runs if an error occurs with auth
                print("ERROR: \(safeError)")
                
            } else {
                // This runs if auth is ok
                
                self.statsArray = [[],[],[],[],[],[]]
                
                //TODO: Make nicer area for data modelling - new file or something
                // Activity totals
                self.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .stepCount)!, unit: "count", duration: duration, completion: {(value) -> Void in
                    print("Steps \(value)")
                    self.addStatsObject(
                        category: 0,
                        position: 0,
                        name: "👟 Steps:",
                        strValue: "\(Int(value)) Steps",
                        rawValue: value,
                        units: "steps")
                })
                
                self.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .flightsClimbed)!, unit: "count", duration: duration, completion: {(value) -> Void in
                    print("Flights \(value)")
                    self.addStatsObject(
                        category: 0,
                        position: 1,
                        name: "🏢 Flights of Stairs:",
                        strValue: "\(Int(value)) Flights",
                        rawValue: value,
                        units: "flights")
                })
                
                self.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .appleStandTime)!, unit: "hour", duration: duration, completion: {(value) -> Void in
                    print("Time Standing \(value)")
                    self.addStatsObject(
                        category: 0,
                        position: 2,
                        name: "🧍‍♂️ Time Standing:",
                        strValue: "\(Int(value)) Hours",
                        rawValue: value,
                        units: "hours")
                })
                
                self.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .appleExerciseTime)!, unit: "hour", duration: duration, completion: {(value) -> Void in
                    print("Hour \(value)")
                    self.addStatsObject(
                        category: 0,
                        position: 3,
                        name: "⏱ Time Exercising:",
                        strValue: "\(Int(value)) Hours",
                        rawValue: value,
                        units: "hours")
                })

                // Walking
                self.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!, unit: "mile", duration: duration, completion: {(value) -> Void in
                    print("Meters \(value)")
                    self.addStatsObject(
                        category: 1,
                        position: 0,
                        name: "🏃‍♀️ Distance Walk/Running:",
                        strValue: "\(Int(value)) Miles",
                        rawValue: value,
                        units: "miles")
                })
                
                //Swimming
                self.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .distanceSwimming)!, unit: "miles", duration: duration, completion: {(value) -> Void in
                    print("Miles \(value)")
                    self.addStatsObject(
                        category: 2,
                        position: 0,
                        name: "🌊 Distance Swimming:",
                        strValue: "\(Int(value)) Miles",
                        rawValue: value,
                        units: "miles")
                })
                
                self.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .swimmingStrokeCount)!, unit: "count", duration: duration, completion: {(value) -> Void in
                    print("Count \(value)")
                    self.addStatsObject(
                        category: 2,
                        position: 1,
                        name: "🏊‍♂️ Swimming Strokes:",
                        strValue: "\(Int(value)) Strokes",
                        rawValue: value,
                        units: "strokes")
                })
                
                // Wheel chair use
                self.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .distanceWheelchair)!, unit: "miles", duration: duration, completion: {(value) -> Void in
                    print("Count \(value)")
                    self.addStatsObject(
                        category: 3,
                        position: 0,
                        name: "👨‍🦼 Distance of Wheel Chair:",
                        strValue: "\(Int(value)) Miles",
                        rawValue: value,
                        units: "miles")
                })
                
                self.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .pushCount)!, unit: "count", duration: duration, completion: {(value) -> Void in
                    print("Count \(value)")
                    self.addStatsObject(
                        category: 3,
                        position: 1,
                        name: "👩‍🦽 Wheel Chair Pushes:",
                        strValue: "\(Int(value)) Pushes",
                        rawValue: value,
                        units: "pushes")
                })
                
                self.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .distanceCycling)!, unit: "miles", duration: duration, completion: {(value) -> Void in
                    print("Count \(value)")
                    self.addStatsObject(
                        category: 4,
                        position: 0,
                        name: "🚴‍♀️ Distance Cycling:",
                        strValue: "\(Int(value)) Miles",
                        rawValue: value,
                        units: "miles")
                })
                
                self.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .distanceDownhillSnowSports)!, unit: "miles", duration: duration, completion: {(value) -> Void in
                    print("Count \(value)")
                    self.addStatsObject(
                        category: 5,
                        position: 0,
                        name: "⛷ Distance doing Snow Sports:",
                        strValue: "\(Int(value)) Miles",
                        rawValue: value,
                        units: "miles")
                })
            }
        }
    }
    
    func addStatsObject(category: Int, position: Int, name: String, strValue: String, rawValue: Double, units: String) {
        //TODO: Add error handling and text formatting here
        var newStatsObject = statsObject()
        newStatsObject.name = name
        newStatsObject.strValue = strValue
        newStatsObject.rawValue = rawValue
        newStatsObject.units = units
        newStatsObject.position = position
        
        var newStatsArray = statsArray[category]
        newStatsArray.append(newStatsObject)
        
        statsArray[category] = newStatsArray.sorted(by: {$0.position < $1.position})

        delegate?.updateTableView()
    }
    
    /*
     fetchData - fetch data from healthkit
     =====================================
     identifier: property to fetch
     unit: measuring unit to return result in
     duration: over what time period (0 is all time, rest is number of days to include)
     completion: run completed code when done
     */
    func fetchData(identifier: HKQuantityType, unit: String, duration: Int, completion: @escaping (_ value:Double) -> ()){
        let calendar = NSCalendar.current
        let interval = NSDateComponents()
        interval.day = 1
        
        var anchorComponents = calendar.dateComponents([.day, .month, .year], from: NSDate() as Date)
        anchorComponents.hour = 0
        let anchorDate = calendar.date(from: anchorComponents)
        
        // Define 1-day intervals starting from 0:00
        let stepsQuery = HKStatisticsCollectionQuery(quantityType: identifier, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: interval as DateComponents)
        
        // Set the results handler
        stepsQuery.initialResultsHandler = {query, results, error in
            let endDate = NSDate()
            
            var startDate  = Date()
            
            if(duration == 0) {
                startDate = Date(timeIntervalSince1970: 0)
            } else {
                startDate = Date().addingTimeInterval(TimeInterval(-3600 * 24 * duration))
            }
            
            var total = 0.0;
            
            if let myResults = results{
                myResults.enumerateStatistics(from: startDate, to: endDate as Date) { statistics, stop in
                    if let quantity = statistics.sumQuantity(){
//                        print(statistics)
                        
                        var value: Double = 0
                        
                        switch(unit) {
                        case "count":
                            value = quantity.doubleValue(for: HKUnit.count())
                            break
                        case "hour":
                            value = quantity.doubleValue(for: HKUnit.hour())
                            break
                        case "meter":
                            value = quantity.doubleValue(for: HKUnit.meter())
                            break
                        case "mile":
                            value = quantity.doubleValue(for: HKUnit.mile())
                            break
                        default:
                            print("Error unit not specified")
                            fatalError("Unit not specified")
                        }
                        
                        total += value
                        // Get date for each day if required
                        //let date = statistics.endDate
                        //print("\(date): value = \(value)")
                    }
                } //end block
                completion(total) // return after loop has ran
            } //end if let
        }
        healthStore.execute(stepsQuery)
    }
}
