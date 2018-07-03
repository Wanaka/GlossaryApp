//
//  blueButton.swift
//  glossaryApp
//
//  Created by Jonas Haag on 2018-07-03.
//  Copyright © 2018 Jonas Haag. All rights reserved.
//

import UIKit

class BlueButton : UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 8.0
        self.layer.borderColor = UIColor.red as! CGColor
        self.layer.backgroundColor = UIColor.red as! CGColor
        
    }
    
}
