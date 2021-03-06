//
//  AddLandmarkViewController.swift
//  BDMobileProject
//
//  Created by lpiem on 09/02/2022.
//

import UIKit
import PhotosUI

class AddLandmarkViewController: UIViewController, PHPickerViewControllerDelegate{
    
    @IBOutlet weak var titleLandmark: UITextField!
    @IBOutlet weak var descLandmark: UITextField!
    @IBOutlet weak var imageLandmark: UIImageView!
    @IBOutlet weak var latitudeLandmark: UITextField!
    @IBOutlet weak var longitudeLandmark: UITextField!
    @IBOutlet weak var validateButton: UIButton!
    
    var landmarkToEdit: Landmark?
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
        if (results.count > 0) {
            results[0].itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    if let image = image as? UIImage {
                         self.imageLandmark.image = image
                    }
                }
            }
        }
    }
    
    public var category: Category?
    let dbManagerInstance = CoreDataManager.sharedInstance
    
    var delegate: AddLandmarkViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if landmarkToEdit != nil {
            titleLandmark.text = landmarkToEdit!.title
            descLandmark.text = landmarkToEdit!.desc
            imageLandmark.image = UIImage(data: landmarkToEdit!.image!)
            latitudeLandmark.text = String(format: "%1f", landmarkToEdit!.coordinate!.latitude)
            longitudeLandmark.text = String(format: "%1f", landmarkToEdit!.coordinate!.longitude)
            validateButton.setTitle("Modifier", for: .normal)
        }
    }
    
    @IBAction func cancelAddLandmark(_ sender: Any) {
        delegate?.AddLandmarkViewControllerCancel(self)
    }
    
    @IBAction func addLandmark(_ sender: Any) {
        if landmarkToEdit == nil {
            if (!longitudeLandmark.text!.isEmpty && !latitudeLandmark.text!.isEmpty && !titleLandmark.text!.isEmpty) {
                let coordinate = self.dbManagerInstance.createCoordinate(longitude: (longitudeLandmark.text! as NSString).doubleValue, latitude: (latitudeLandmark.text! as NSString).doubleValue)
                self.dbManagerInstance.createLandmark(title: titleLandmark.text!, desc: descLandmark.text!, image: imageLandmark.image?.pngData(), category: category!, coordinate: coordinate)
                delegate?.AddLandmarkViewController(self)
            } else {
                let alertController = UIAlertController(title: "Champs obligatoires", message: "Veuillez renseigner au minimum le titre et les coordonn??es", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                present(alertController, animated: true)
            }
        } else {
            let coordinate = self.dbManagerInstance.createCoordinate(longitude: (longitudeLandmark.text! as NSString).doubleValue, latitude: (latitudeLandmark.text! as NSString).doubleValue)
            self.dbManagerInstance.editLandmark(landmark: landmarkToEdit!, newTitle: titleLandmark.text!, newDesc: descLandmark.text!, newImage: (imageLandmark.image?.pngData())!, newCoordinate: coordinate)
            delegate?.AddLandmarkViewController(self)
        }
    }
    
    @IBAction func importImage(_ sender: Any) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
}

protocol AddLandmarkViewControllerDelegate: AnyObject{
    func AddLandmarkViewController(_ controller: AddLandmarkViewController)
    func AddLandmarkViewControllerCancel(_ controller: AddLandmarkViewController)
}
