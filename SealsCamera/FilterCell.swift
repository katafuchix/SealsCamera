//
//  FilterCell.swift
//  SealsCamera
//
//  Created by cano on 2016/06/25.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    //@IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var baseImageView: UIImageView!
    
    override func drawRect(rect: CGRect) {
        
        self.backgroundColor = UIColor.grayColor()
        
    }
}
