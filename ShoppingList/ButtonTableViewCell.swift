//
//  ButtonTableViewCell.swift
//  ShoppingList
//
//  Created by Patrick Pahl on 5/27/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var itemLabel: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    weak var delegate: ItemTableViewCellDelegate?

    
    @IBAction func buttonCellButtonTapped(sender: AnyObject) {
        
        delegate?.buttonCellButtonTapped(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func updateWithItem(item: Item){
        itemLabel.text = item.name
        isCompleteValueChanged(item.isComplete.boolValue)
    }
    
    
    func isCompleteValueChanged(value: Bool){
        
        if value == true {
            button.imageView?.image = UIImage(named: "complete")
        } else {
            button.imageView?.image = UIImage(named: "incomplete")
        }
    }
    
}


protocol ItemTableViewCellDelegate: class {
    
    func buttonCellButtonTapped(cell: ButtonTableViewCell)
    
}

