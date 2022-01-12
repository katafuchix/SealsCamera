//
//  StampBase.swift
//  SealsCamera
//
//  Created by cano on 2016/07/05.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit

class StampBase: UIView, ZDStickerViewDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    func addStamp(image:UIImage){
        /*
         if currentlyEditingView != nil {
         currentlyEditingView?.hideEditingHandles()
         }
         */
        let gripFrame1 : CGRect = CGRectMake( 30 ,  30 , 150, 150)
        let contentView : UIView = UIView(frame:gripFrame1)
        contentView.backgroundColor = UIColor.clearColor()
        
        let imageView1 = UIImageView(image: image)
        contentView.addSubview(imageView1)
        
        let userResizableView1 : ZDStickerView = ZDStickerView(frame: gripFrame1)
        
        userResizableView1.tag = 0
        userResizableView1.stickerViewDelegate = self
        userResizableView1.contentView = contentView
        userResizableView1.preventsPositionOutsideSuperview = false
        userResizableView1.translucencySticker = false
        userResizableView1.showEditingHandles()
        self.addSubview(userResizableView1)
        /*
        currentlyEditingView = userResizableView1
        ZDStickerViews?.append(userResizableView1)
        
        let stampBase = StampBase(frame:self.imageView.frame)
        stampBase.backgroundColor = UIColor.lightGrayColor()
        self.imageView.addSubview(stampBase)
        
        userResizableView1.stickerViewDelegate = stampBase
        stampBase.addSubview(userResizableView1)
        */
    }
    
    func stickerViewDidLongPressed(sticker:ZDStickerView){
        
        if sticker.isEditingHandlesHidden() == true {
            sticker.showEditingHandles()
        }else{
            sticker.hideEditingHandles()
        }
    }
    
    func stickerViewDidClose(sticker: ZDStickerView!) {
        print(sticker.tag)
    }
    
    func stickerViewDidCustomButtonTap(sticker: ZDStickerView!) {
        print(sticker.tag)
    }
}
