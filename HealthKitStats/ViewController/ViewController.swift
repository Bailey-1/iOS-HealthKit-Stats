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
    
    var selectedCategory: Int?
    var selectedRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        statsManager.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        // Run checkAuth and set duration to be all time
        statsManager.checkAuth(duration: 0)
    }
    @IBAction func timeButtonClicked(_ sender: UIBarButtonItem) {
        print("time button clicked")
        showChangeTime()
    }
    
    /*
     Show the actionsheet when the button is clicked.
     Change the nav title and change the duration timeframe
     */
    func showChangeTime() {
        //TODO: Actionsheet causes a constraint break - this is a bug and should be fixed in a updated - can be fixed by disabling animation - https://stackoverflow.com/questions/55653187/swift-default-alertviewcontroller-breaking-constraints
        let alert = UIAlertController(title: "Change Selected Time", message: "Change the selected time period for the stats.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "1 Day", style: .default, handler: { (_) in
            print("1 Day Selected")
            self.title = "1 Day Stats"
            self.statsManager.checkAuth(duration: 1)
        }))
        
        alert.addAction(UIAlertAction(title: "1 Week (7D)", style: .default, handler: { (_) in
            print("1 Week Selected")
            self.title = "1 Week Stats"
            self.statsManager.checkAuth(duration: 7)
        }))
        
        alert.addAction(UIAlertAction(title: "1 Month (30D)", style: .default, handler: { (_) in
            print("1 Month Selected")
            self.title = "1 Month Stats"
            self.statsManager.checkAuth(duration: 30)
        }))
        
        alert.addAction(UIAlertAction(title: "1 Year (365D)", style: .default, handler: { (_) in
            print("1 Year Selected")
            self.title = "1 Year Stats"
            self.statsManager.checkAuth(duration: 365)
        }))
        
        alert.addAction(UIAlertAction(title: "All Time", style: .default, handler: { (_) in
            print("All Time Selected")
            self.title = "All Time Stats"
            self.statsManager.checkAuth(duration: 0)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // Empty on purpose
            print("Actionsheet Dismissed")
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    // Runs before a segue is performed so I can set variables in the VC before it is displayed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.showDetails {
            let destinationVC = segue.destination as! DetailsViewController //Chose the right view controller. - Downcasting
            if let safeSelectedCategory = selectedCategory, let safeSelectedRow = selectedRow {
                destinationVC.statsArrayItem = statsManager.statsArray[safeSelectedCategory][safeSelectedRow]
                destinationVC.navTitle = statsManager.statsArrayTitles[safeSelectedCategory]
            }
        }
    }
}

//MARK: - TableView methods

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statsManager.statsArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel!.text = statsManager.statsArray[indexPath.section][indexPath.row].name
        cell.detailTextLabel!.text = statsManager.statsArray[indexPath.section][indexPath.row].strValue
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return statsManager.statsArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return statsManager.statsArrayTitles[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row at \(indexPath[0]) clicked")
        selectedCategory = indexPath[0]
        selectedRow = indexPath[1]
        self.performSegue(withIdentifier: K.segue.showDetails, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - StatsManagerProtcol

extension ViewController: StatsManagerProtocol {
    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
