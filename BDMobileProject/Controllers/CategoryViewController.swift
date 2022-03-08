//
//  ViewController.swift
//  BDMobileProject
//
//  Created by lpiem on 09/02/2022.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    @IBOutlet weak var filterCategory: UIBarButtonItem!
    
    //MARK: - Properties
    
    private var categories: [Category] = []
    let dbManagerInstance = CoreDataManager.sharedInstance
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchConroller = UISearchController(searchResultsController: nil)
        searchConroller.searchResultsUpdater = self
        navigationItem.searchController = searchConroller
        
        categories = dbManagerInstance.fetchCategories(ascent: true)
        tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        filterCategory.primaryAction = nil
        filterCategory.menu = generatePullDownMenu()
    }
    
    var filter = Filter.title
    var ascent = true
    
    private func generatePullDownMenu() -> UIMenu{
 
        
        let filterTitle = UIAction(title: "Trier par titre",
                                   image: filter == .title  ? ascent ? UIImage(systemName: "chevron.up"): UIImage(systemName: "chevron.down") : nil,
                                   state: filter == .title  ? .on : .off) { (action) in
            self.filter = Filter.title
            self.ascent = self.ascent ? false : true
            self.filterCategory.menu = self.generatePullDownMenu()
            self.categories = self.dbManagerInstance.fetchCategories(ascent: self.ascent)
            self.tableView.reloadData()
        }
        
        let filterCreate = UIAction(title: "Trier par date de création",
                                    image: filter == .create ? ascent ? UIImage(systemName: "chevron.up"): UIImage(systemName: "chevron.down") : nil,
                                    state: filter == .create ? .on : .off) { (action) in
            self.filter = Filter.create
            self.ascent = self.ascent ? false : true
            self.filterCategory.menu = self.generatePullDownMenu()
            self.categories = self.dbManagerInstance.fetchCategories(ascent: self.ascent,filter: "create")
            self.tableView.reloadData()
        }
        
        let filterEdit = UIAction(title: "Trier par date d'édition",
                                  image: filter == .edit ? ascent ? UIImage(systemName: "chevron.up"): UIImage(systemName: "chevron.down") : nil,
                                  state: filter == .edit ? .on : .off) { (action) in
            self.filter = Filter.edit
            self.ascent = self.ascent ? false : true
            self.filterCategory.menu = self.generatePullDownMenu()
            self.categories = self.dbManagerInstance.fetchCategories(ascent: self.ascent,filter: "edit")
            self.tableView.reloadData()
        }
        
        let actions = [filterTitle,filterCreate,filterEdit]
            
        let menu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: actions)
                
        return menu
    }
    

    
    @IBAction func AddBarButtonItemAction(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Nouvelle catégorie", message: "Ajouter une catégorie à la liste", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Titre…"
        }
        
        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
        
        let saveAction = UIAlertAction(title: "Sauvegarder", style: .default) { [weak self]_ in
            guard let self = self,
                let textField  = alertController.textFields?.first else{
                return
            }
            
            self.dbManagerInstance.createCategory(title: textField.text!)
            self.categories = self.dbManagerInstance.fetchCategories(ascent: true)
            self.tableView.reloadData()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        present(alertController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellCategory = tableView.dequeueReusableCell(withIdentifier: "cellCategory", for: indexPath) as! CategoryItemCell
        let category = categories[indexPath.row]
        cellCategory.titleCategory.text = category.title
        cellCategory.created.text = DateFormatter.localizedString(from: category.creationDate!, dateStyle: .short, timeStyle: .short)
        cellCategory.edited.text = DateFormatter.localizedString(from: category.modificationDate!, dateStyle: .short, timeStyle: .short)
        
        cellCategory.buttonAction = {
            let alertController = UIAlertController(title: "Éditer la catégorie", message: "", preferredStyle: .alert)
            alertController.addTextField { textField in
                textField.text = category.title
            }
            
            let cancelAction = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
            
            let saveAction = UIAlertAction(title: "Sauvegarder", style: .default) { [weak self]_ in
                guard let self = self,
                    let textField  = alertController.textFields?.first else{
                    return
                }
                
                self.dbManagerInstance.editCategory(category: category, newTitle: textField.text!)
                self.categories = self.dbManagerInstance.fetchCategories(ascent: true)
                self.tableView.reloadData()
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)
            
            self.present(alertController, animated: true)
        }
        
        return cellCategory
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let category = categories[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Supprimer") { [weak self]_, _, completion in
            guard let self = self else{
                return
            }
            
            self.dbManagerInstance.deleteCategory(category: category)
            self.categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let swipeActionConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeActionConfiguration
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "landmarks":
            (segue.destination as! LandmarkViewController).category = categories[tableView.indexPath(for: sender as! UITableViewCell)?.item ?? 0]
            
        default:
            fatalError()
        }
    }

}

extension CategoryViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchQuery = searchController.searchBar.text
        self.categories = self.dbManagerInstance.fetchCategories(ascent: true, searchQuery: searchQuery)
        tableView.reloadData()
    }
}

enum Filter: Equatable{
    case title
    case create
    case edit
}

