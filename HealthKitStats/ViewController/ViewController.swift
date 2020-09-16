//
//  ViewController.swift
//  HealthKitStats
//
//  Created by Bailey Search on 16/09/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let statsManager = StatsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        statsManager.checkAuth()
    }

}

