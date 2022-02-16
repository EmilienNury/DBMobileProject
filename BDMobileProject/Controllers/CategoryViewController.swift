//
//  ViewController.swift
//  BDMobileProject
//
//  Created by lpiem on 09/02/2022.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    @IBOutlet weak var filter: UIBarButtonItem!
    
    //MARK: - Properties
    
    private var categories: [Category] = []
    let dbManagerInstance = CoreDataManager.sharedInstance
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = dbManagerInstance.fetchCategories()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
                
        let filterTitle = UIAction(title: "Trier par titre") { (action) in
            self.categories = self.dbManagerInstance.fetchCategories(searchQuery: "title")
            self.tableView.reloadData()
        }
        
        let filterCreate = UIAction(title: "Trier par date de création") { (action) in
            self.categories = self.dbManagerInstance.fetchCategories(searchQuery: "create")
            self.tableView.reloadData()
        }
        
        let filterEdit = UIAction(title: "Trier par date d'édition") { (action) in
            self.categories = self.dbManagerInstance.fetchCategories(searchQuery: "edit")
            self.tableView.reloadData()
        }
        
        let actions = [filterTitle,filterCreate,filterEdit]
                
        let menu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: actions)
                
        filter.primaryAction = nil
        filter.menu = menu
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
            self.categories = self.dbManagerInstance.fetchCategories()
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

