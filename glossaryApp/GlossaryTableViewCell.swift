//
//  glossaryTableViewCell.swift
//  glossaryApp
//
//  Created by Jonas Haag on 2018-02-23.
//  Copyright © 2018 Jonas Haag. All rights reserved.
//

import UIKit

class GlossaryTableViewCell: UITableViewCell {

    @IBOutlet weak var firstWord: UILabel!
    
    @IBOutlet weak var secondWord: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
