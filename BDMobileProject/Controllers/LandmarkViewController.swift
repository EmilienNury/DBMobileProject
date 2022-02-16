//
//  LandmarkViewController.swift
//  BDMobileProject
//
//  Created by lpiem on 09/02/2022.
//

import UIKit

class LandmarkViewController: UITableViewController {

    //MARK: - Properties
    public var category: Category?
    private var landmarks: [Landmark] = []
    let dbManagerInstance = CoreDataManager.sharedInstance
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        landmarks = dbManagerInstance.fetchLandmarks()
        tableView.reloadData()
        title = category?.title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return landmarks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellLandmark = tableView.dequeueReusableCell(withIdentifier: "cellLandmark", for: indexPath) as! LandmarkItemCell
        let landmark = landmarks[indexPath.row]
        cellLandmark.titleLandmark.text = landmark.title
        cellLandmark.descriptionLandmark.text = landmark.desc
        cellLandmark.imageLandmark.image = UIImage(data: landmark.image!)
        
        return cellLandmark
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let landmark = landmarks[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Supprimer") { [weak self]_, _, completion in
            guard let self = self else{
                return
            }
            
            self.dbManagerInstance.deleteLandmark(landmark: landmark)
            self.landmarks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let swipeActionConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeActionConfiguration
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "addLandmark":
            guard let naviguationController = segue.destination as? UINavigationController,
                  let destination = naviguationController.topViewController as? AddLandmarkViewController else{
                      return
                  }
            destination.delegate = self
            destination.category = category
            destination.title = "Ajouter un lieu"
            
        case"detailLandmark":
            guard let naviguationController = segue.destination as? UINavigationController,
                  let destination = naviguationController.topViewController as? DetailsViewController else{
                      return
                  }
            
            destination.landmark = landmarks[tableView.indexPath(for: sender as! UITableViewCell)?.row ?? 0]
            destination.title = destination.landmark?.title
            
        default:
            fatalError()
        }
    }
}

extension LandmarkViewController: AddLandmarkViewControllerDelegate{
    func AddLandmarkViewController(_ controller: AddLandmarkViewController) {
        dismiss(animated: true, completion: nil)
        landmarks = dbManagerInstance.fetchLandmarks()
        tableView.reloadData()
        print(landmarks[0].desc!)
    }
    
}
