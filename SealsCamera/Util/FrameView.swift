//
//  FrameView.swift
//  SealsCamera
//
//  Created by cano on 2016/07/05.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit

class FrameView: UIView {
    var image : UIImage?
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func setFrameImage(image:UIImage){
        self.backgroundColor = UIColor.clearColor()
        let imageView = UIImageView(frame:self.bounds)
        imageView.image = image
        self.addSubview(imageView)
    }

}
