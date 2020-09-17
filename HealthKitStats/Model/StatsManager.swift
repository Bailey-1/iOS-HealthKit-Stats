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
    
    func checkAuth(){
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
                
                // Activity totals
                self.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .stepCount)!, unit: "count", completion: {(value) -> Void in
                    print("Steps \(value)")
                    self.addStatsObject(category: 0, name: "👟 Step Count:", strValue: "\(Int(value)) Steps", rawValue: value, units: "steps")
                })
                
                self.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .flightsClimbed)!, unit: "count", completion: {(value) -> Void in
                    print("Flights \(value)")
                    self.addStatsObject(category: 0, name: "🏢 No. of Flights of Stairs:", strValue: "\(Int(value)) Flights", rawValue: value, units: "flights")
                })
                
                self.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .appleStandTime)!, unit: "hour", completion: {(value) -> Void in
                    print("Time Standing \(value)")
                    self.addStatsObject(category: 0, name: "🧍‍♂️ Time Standing:", strValue: "\(Int(value)) Hours", rawValue: value, units: "hours")
                })
                
                // Walking
                self.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!, unit: "mile", completion: {(value) -> Void in
                    print("Meters \(value)")
                    self.addStatsObject(category: 1, name: "🏃‍♀️ Distance Walk/Running:", strValue: "\(Int(value)) Miles", rawValue: value, units: "miles")
                })
                
                self.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .appleExerciseTime)!, unit: "hour", completion: {(value) -> Void in
                    print("Hour \(value)")
                    self.addStatsObject(category: 1, name: "⏱ Time exercising:", strValue: "\(Int(value)) Hours", rawValue: value, units: "hours")
                })
                
                //Swimming
                self.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .swimmingStrokeCount)!, unit: "count", completion: {(value) -> Void in
                    print("Count \(value)")
                    self.addStatsObject(category: 2, name: "🏊‍♂️ Swimming Stroke Count:", strValue: "\(Int(value)) Strokes", rawValue: value, units: "strokes")
                })
                
                self.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .distanceSwimming)!, unit: "miles", completion: {(value) -> Void in
                    print("Miles \(value)")
                    self.addStatsObject(category: 2, name: "🌊 Swimming Distance:", strValue: "\(Int(value)) Miles", rawValue: value, units: "miles")
                })
                
                // Wheel chair use
                self.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .pushCount)!, unit: "count", completion: {(value) -> Void in
                    print("Count \(value)")
                    self.addStatsObject(category: 3, name: "👩‍🦽 Wheel chair push count:", strValue: "\(Int(value)) Pushes", rawValue: value, units: "pushes")
                })
                
                self.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .distanceWheelchair)!, unit: "miles", completion: {(value) -> Void in
                    print("Count \(value)")
                    self.addStatsObject(category: 3, name: "👨‍🦼 Wheel chair Distance:", strValue: "\(Int(value)) Miles", rawValue: value, units: "miles")
                })
                
                self.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .distanceCycling)!, unit: "miles", completion: {(value) -> Void in
                    print("Count \(value)")
                    self.addStatsObject(category: 4, name: "🚴‍♀️ Distance Cycling:", strValue: "\(Int(value)) Miles", rawValue: value, units: "miles")
                })
                
                self.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .distanceDownhillSnowSports)!, unit: "miles", completion: {(value) -> Void in
                    print("Count \(value)")
                    self.addStatsObject(category: 5, name: "⛷ Distance Snow Sports:", strValue: "\(Int(value)) Miles", rawValue: value, units: "miles")
                })
            }
        }
    }
    
    func addStatsObject(category: Int, name: String, strValue: String, rawValue: Double, units: String) {
        //TODO: Add error handling and text formatting here
        var newStatsObject = statsObject()
        newStatsObject.name = name
        newStatsObject.strValue = strValue
        newStatsObject.rawValue = rawValue
        newStatsObject.units = units
        
        statsArray[category].append(newStatsObject)
        
        delegate?.updateTableView()
    }
    
    func fetchData(identifier: HKQuantityType, unit: String, completion: @escaping (_ value:Double) -> ()){
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
            let startDate = Date(timeIntervalSince1970: 0)
            
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
