//
//  DetailsViewController.swift
//  BDMobileProject
//
//  Created by lpiem on 09/02/2022.
//

import UIKit

class DetailsViewController: UIViewController{
    var landmark: Landmark?
    @IBOutlet weak var descLandmark: UILabel!
    @IBOutlet weak var longitudeLandmark: UILabel!
    @IBOutlet weak var latitudeLandmark: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
