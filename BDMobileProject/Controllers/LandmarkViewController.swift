//
//  LandmarkViewController.swift
//  BDMobileProject
//
//  Created by lpiem on 09/02/2022.
//

import UIKit

class LandmarkViewController: UITableViewController {

    private var landmarks: [Landmark] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return landmarks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellLandmark = tableView.dequeueReusableCell(withIdentifier: "cellLandmark", for: indexPath) as! LandmarkItemCell
        let landmark = landmarks[indexPath.row]
        cellLandmark.titleLandmark.text = landmark.title
        cellLandmark.descriptionLandmark.text = landmark.description
        //TODO faire pour l'image
        //cellLandmark.imageLandmark =
        return cellLandmark
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let landmark = landmarks[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Supprimer") { [weak self]_, _, completion in
            guard let self = self else{
                return
            }
            
            //self.delete() TODO: Emilien func delete
            self.landmarks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let swipeActionConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeActionConfiguration
    }
    
    

}
