//
//  ViewController.swift
//  HealthKitStats
//
//  Created by Bailey Search on 16/09/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let statsManager = StatsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        statsManager.delegate = self
        tableView.dataSource = self
        
        statsManager.checkAuth()
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statsManager.statsArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel!.text = statsManager.statsArray[indexPath.section][indexPath.row].name
        cell.detailTextLabel!.text = statsManager.statsArray[indexPath.section][indexPath.row].value
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return statsManager.statsArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return statsManager.statsArrayTitles[section]
    }
}

extension ViewController: StatsManagerProtocol {
    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
