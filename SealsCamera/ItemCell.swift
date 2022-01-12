//
//  ItemCell.swift
//  View
//
//

import UIKit

class ItemCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func drawRect(rect: CGRect) {
        //self.layer.borderColor = UIColor.grayColor().CGColor
        //self.layer.borderWidth = 5.0
        
        // セルの背景色を白に指定
        self.backgroundColor = UIColor.clearColor()
        
        // 選択時に表示するビューを指定
        //self.selectedBackgroundView = UIView(frame: self.bounds)
        //self.selectedBackgroundView!.backgroundColor = UIColor.redColor()
    }
}
