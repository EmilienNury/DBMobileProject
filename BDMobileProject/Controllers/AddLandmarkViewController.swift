//
//  AddLandmarkViewController.swift
//  BDMobileProject
//
//  Created by lpiem on 09/02/2022.
//

import UIKit

class AddLandmarkViewController: UIViewController{
    
    @IBOutlet weak var titleLandmark: UITextField!
    @IBOutlet weak var descLandmark: UITextField!
    @IBOutlet weak var imageLandmark: UIImageView!
    @IBOutlet weak var latitudeLandmark: UITextField!
    @IBOutlet weak var longitudeLandmark: UITextField!
    public var category: Category?
    let dbManagerInstance = CoreDataManager.sharedInstance
    
    var delegate: AddLandmarkViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelAddLandmark(_ sender: Any) {
        delegate?.AddLandmarkViewControllerCancel(self)
    }
    
    @IBAction func addLandmark(_ sender: Any) {
        let coordinate = self.dbManagerInstance.createCoordinate(longitude: (longitudeLandmark.text! as NSString).doubleValue, latitude: (latitudeLandmark.text! as NSString).doubleValue)
        self.dbManagerInstance.createLandmark(title: titleLandmark.text!, desc: descLandmark.text!, image: imageLandmark.image?.pngData(), category: category!, coordinate: coordinate)
        
        delegate?.AddLandmarkViewController(self)
    }
}

protocol AddLandmarkViewControllerDelegate: AnyObject{
    func AddLandmarkViewController(_ controller: AddLandmarkViewController)
    func AddLandmarkViewControllerCancel(_ controller: AddLandmarkViewController)
}
