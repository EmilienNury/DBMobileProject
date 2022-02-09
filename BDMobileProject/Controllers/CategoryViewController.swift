//
//  ViewController.swift
//  BDMobileProject
//
//  Created by lpiem on 09/02/2022.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    private var categories: [Category] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
            
            //self.createItem(title: textField.text!)
            //self.categories = self.fetchCategories()
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
            
            //self.delete() TODO: Emilien func delete
            self.categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let swipeActionConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeActionConfiguration
    }
    
    

}

