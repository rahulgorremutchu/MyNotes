//
//  EditorTableViewCell.swift
//  MyNotes
//
//  Created by Mahin on 12/04/18.
//  Copyright © 2018 Quickeans. All rights reserved.
//

import UIKit

class EditorTableViewCell: UITableViewCell {

    @IBOutlet weak var txtViewEditor: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
