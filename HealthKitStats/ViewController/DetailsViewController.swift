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
        
        if let safeValue = statsArrayItem?.rawValue, let safeUnits = statsArrayItem?.units {
            equivalentStatsManager.calculate(value: safeValue, unit: safeUnits)
        }
    }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return equivalentStatsManager.completedResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel!.text = equivalentStatsManager.completedResults[indexPath.row].description
        cell.detailTextLabel!.text = String(equivalentStatsManager.completedResults[indexPath.row].result)
        return cell
    }
}
