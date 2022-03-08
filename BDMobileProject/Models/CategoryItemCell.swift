//
//  CategoryItemCell.swift
//  BDMobileProject
//
//  Created by lpiem on 09/02/2022.
//

import UIKit

class CategoryItemCell: UITableViewCell{
    
    @IBOutlet weak var titleCategory: UILabel!
    @IBOutlet weak var created: UILabel!
    @IBOutlet weak var edited: UILabel!
    var buttonAction : (() -> ())?
    
    @IBAction func editCategory(_ sender: Any) {
        buttonAction?()
    }
}
