//
//  LandmarkViewController.swift
//  BDMobileProject
//
//  Created by lpiem on 09/02/2022.
//

import UIKit

class LandmarkViewController: UITableViewController {
    @IBOutlet weak var filterLandmark: UIBarButtonItem!
    
    //MARK: - Properties
    public var category: Category?
    private var landmarks: [Landmark] = []
    let dbManagerInstance = CoreDataManager.sharedInstance
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchConroller = UISearchController(searchResultsController: nil)
        searchConroller.searchResultsUpdater = self
        navigationItem.searchController = searchConroller
        
        landmarks = dbManagerInstance.fetchLandmarks(category: category)
        tableView.reloadData()
        title = category?.title
    }
    
    override func viewDidAppear(_ animated: Bool) {
        filterLandmark.primaryAction = nil
        filterLandmark.menu = generatePullDownMenu()
    }
    
    var titleFilter = true
    var createFilter = false
    var editFilter = false
    
    private func generatePullDownMenu() -> UIMenu{
        let filterTitle = UIAction(title: "Trier par titre",state: titleFilter ? .on : .off) { (action) in
            self.landmarks = self.dbManagerInstance.fetchLandmarks( category: self.category)
            self.tableView.reloadData()
            self.titleFilter = true
            self.createFilter = false
            self.editFilter = false
            self.filterLandmark.menu = self.generatePullDownMenu()
        }
        
        let filterCreate = UIAction(title: "Trier par date de création",state: createFilter ? .on : .off) { (action) in
            self.landmarks = self.dbManagerInstance.fetchLandmarks(category: self.category, filter: "create")
            self.tableView.reloadData()
            self.titleFilter = false
            self.createFilter = true
            self.editFilter = false
            self.filterLandmark.menu = self.generatePullDownMenu()
        }
        
        let filterEdit = UIAction(title: "Trier par date d'édition",state: editFilter ? .on : .off) { (action) in
            self.landmarks = self.dbManagerInstance.fetchLandmarks(category: self.category, filter: "edit")
            self.tableView.reloadData()
            self.titleFilter = false
            self.createFilter = false
            self.editFilter = true
            self.filterLandmark.menu = self.generatePullDownMenu()
        }
        
        let actions = [filterTitle,filterCreate,filterEdit]
            
        let menu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: actions)
                
        return menu
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
        
        cellLandmark.editButtonLandmark.tag = indexPath.row;
        
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
            
        case "editLandmark":
            guard let naviguationController = segue.destination as? UINavigationController,
                  let destination = naviguationController.topViewController as? AddLandmarkViewController else{
                      return
                  }
            destination.delegate = self
            destination.category = category
            destination.landmarkToEdit = landmarks[(sender! as AnyObject).tag]
            destination.title = "Editer un lieu"
            
            
        default:
            fatalError()
        }
    }
}

extension LandmarkViewController: AddLandmarkViewControllerDelegate{
    func AddLandmarkViewControllerCancel(_ controller: AddLandmarkViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func AddLandmarkViewController(_ controller: AddLandmarkViewController) {
        dismiss(animated: true, completion: nil)
        landmarks = dbManagerInstance.fetchLandmarks(category: category)
        tableView.reloadData()
    }
    
}

extension LandmarkViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchQuery = searchController.searchBar.text
        self.landmarks = self.dbManagerInstance.fetchLandmarks(searchQuery: searchQuery, category: self.category)
        tableView.reloadData()
    }
}
