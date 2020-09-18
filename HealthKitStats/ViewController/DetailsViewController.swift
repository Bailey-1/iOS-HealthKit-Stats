//
//  DetailsViewController.swift
//  HealthKitStats
//
//  Created by Bailey Search on 17/09/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var navTitle: String?
    var statsArrayItem: statsObject?
    
    var equivalentStatsManager = EquivalentStatsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        print("Details View Loaded")
        self.title = navTitle
        
        // Pass in stat value and the unit it is measured in
        if let safeValue = statsArrayItem?.rawValue, let safeUnits = statsArrayItem?.units {
            equivalentStatsManager.calculate(value: safeValue, unit: safeUnits)
        }
    }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Statically define number of items in each section - top section only has the clicked on property
        if(section == 0){
            return 1
        } else {
            return equivalentStatsManager.completedResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatsCell", for: indexPath)
            cell.textLabel!.text = statsArrayItem?.name
            cell.detailTextLabel!.text = statsArrayItem?.strValue
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

            cell.textLabel!.text = equivalentStatsManager.completedResults[indexPath.row].strResult
            return cell
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let titles = ["Your Statistics:", "Equivalent Stats:"]
        return titles[section]
    }
}
