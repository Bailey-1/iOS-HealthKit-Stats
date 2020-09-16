//
//  StatsManager.swift
//  HealthKitStats
//
//  Created by Bailey Search on 16/09/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import Foundation
import HealthKit

class StatsManager {
    
    let healthStore = HKHealthStore()
    
    func checkAuth(){
        // Set required properties to be read from HealthKit https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier
        let healthKitTypes: Set = [ HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.flightsClimbed)!]
        
        // Request read only access to users healthkit data
        healthStore.requestAuthorization(toShare: nil, read: healthKitTypes) { (bool, error) in
            if let safeError = error {
                // This runs if an error occurs with auth
                print("ERROR: \(safeError)")
                
            } else {
                // This runs if auth is ok
                self.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!, unit: "meter", completion: {(value) -> Void in
                    print("Meters \(value)")
                })
                
                self.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .stepCount)!, unit: "count", completion: {(value) -> Void in
                    print("Steps \(value)")
                })
                self.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .flightsClimbed)!, unit: "count", completion: {(value) -> Void in
                    print("Flights \(value)")
                })
            }
        }
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
                        
                        if (unit == "meter") {
                            value = quantity.doubleValue(for: HKUnit.meter())
                        } else if (unit == "count"){
                            value = quantity.doubleValue(for: HKUnit.count())
                        }
                        
                        total += value
//                        let date = statistics.endDate
//                        print("\(date): value = \(value)")
                    }
                } //end block
                completion(total)
            } //end if let
//            print("Value \(total)")
        }
        healthStore.execute(stepsQuery)
    }
}
