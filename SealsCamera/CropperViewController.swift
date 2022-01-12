//
//  CropperViewController.swift
//  SealsCamera
//
//  Created by cano on 2016/06/20.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit

class CropperViewController: UIViewController, AKImageCropperViewDelegate {

    var _image: UIImage!
    
    @IBOutlet weak var cropView: AKImageCropperView!
    
    @IBOutlet weak var cropFrameBarButton: UIBarButtonItem!
    @IBOutlet weak var cropBarButton: UIBarButtonItem!
    
    var delegate : imageSelectDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        cropView.image = _image
        cropView.delegate = self
        
        cropFrameBarButton.action = "onCropFrame:"
        cropBarButton.action = "onCrop:"
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func onCrop(sender:AnyObject) {
        print(self.parentViewController)
        
        // デリゲートが実装されていたら呼ぶ
        if (self.delegate?.respondsToSelector("selectImage:")) != nil {
            // 実装先のdidClose:メソッドを実行
            delegate?.selectImage(cropView.croppedImage())
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onCropFrame(sender:AnyObject){
        if cropView.overlayViewIsActive {
            
            //cropFrameBarButton.setTitle("Show Crop Frame", forState: UIControlState.Normal)
            
            cropView.dismissOverlayViewAnimated(true) { () -> Void in
                
                print("Frame disabled")
            }
        } else {
            
            //cropFrameBarButton.setTitle("Hide Crop Frame", forState: UIControlState.Normal)
            
            cropView.showOverlayViewAnimated(true, withCropFrame: nil, completion: { () -> Void in
                
                print("Frame active")
            })
        }
    }
    
    func cropRectChanged(rect: CGRect) {
        print("New crop rectangle: \(rect)")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        /**
         If you use programmatically initalization
         Switch 'cropView' to 'cropViewProgrammatically'\
         Example: cropViewProgrammatically.refresh()
         */
        cropView.refresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

protocol imageSelectDelegate : NSObjectProtocol {
    
    func selectImage(image:UIImage)
    
}
