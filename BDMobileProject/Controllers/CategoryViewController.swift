//
//  ViewController.swift
//  BDMobileProject
//
//  Created by lpiem on 09/02/2022.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    //MARK: - Properties
    
    private var categories: [Category] = []
    let dbManagerInstance = CoreDataManager.sharedInstance
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

