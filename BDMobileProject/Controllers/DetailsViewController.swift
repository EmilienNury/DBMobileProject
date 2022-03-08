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
    @IBOutlet weak var creationDateLandmark: UILabel!
    @IBOutlet weak var modificationDateLandmark: UILabel!
    @IBOutlet weak var imageLandmark: UIImageView!
    
    @IBAction func Cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descLandmark.text = landmark?.desc ?? "Pas de description"
        longitudeLandmark.text = "longitude: " + String(format: "%1f", landmark!.coordinate!.longitude)
        latitudeLandmark.text = "latitude: " + String(format: "%1f", landmark!.coordinate!.latitude)
        creationDateLandmark.text = "created: " + DateFormatter.localizedString(from: landmark!.creationDate!, dateStyle: .short, timeStyle: .short)
        modificationDateLandmark.text = "modified: " + DateFormatter.localizedString(from: landmark!.modificationDate!, dateStyle: .short, timeStyle: .short)
        imageLandmark.image = UIImage(data: landmark!.image!)
    }
    
}
