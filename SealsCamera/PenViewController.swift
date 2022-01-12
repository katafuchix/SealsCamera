//
//  PenViewController.swift
//  SealsCamera
//
//  Created by cano on 2016/07/02.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit

class PenViewController: UIViewController {

    var delegate : penSelectDelegate?
    
    @IBOutlet weak var eraserButton: UIButton!
    
    @IBOutlet weak var penButton: UIButton!
    
    @IBOutlet weak var penColorView: UIView!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var penBaseView: UIView!
    
    @IBOutlet weak var penImageView: UIImageView!
    
    
    var pData = PublicDatas.getPublicDatas()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //self.view.backgroundColor = UIColor.blackColor()
        
        var width = pData.getFloatForKey("width")
        if width == 0.0 {
            width = 10.0
            pData.setData(10.0, key: "width")
        }
        
        slider.setThumbImage(UIImage(named: "slider_thumb_30.png"), forState: .Normal)
        slider.setMaximumTrackImage(UIImage(named: "skeleton.png"), forState: .Normal)
        slider.setMinimumTrackImage(UIImage(named: "skeleton.png"), forState: .Normal)
        
        slider.minimumValue = 1.0
        slider.maximumValue = 50.0
        let w = pData.getFloatForKey("width")
        if  w > 0.0 {
            slider.value = w
        }else{
            slider.value = 10.0
            pData.setData(10.0, key: "width")
        }
        slider.addTarget(self, action: #selector(PenViewController.onChgSlider(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        //penButton.addTarget(self, action: #selector(PenViewController.onPen(_:)), forControlEvents: .TouchUpInside)
        
        let color = pData.getStringForKey("color")
        if color != "" {
            penBaseView.backgroundColor = UIColor(hex: Int(color)!, alpha: 1.0)
        }else{
            penBaseView.backgroundColor = UIColor.clearColor()
        }
        
        penImageView.userInteractionEnabled = true
        let tapped = UITapGestureRecognizer(target: self, action: #selector(PenViewController.onPen(_:)))
        penImageView.addGestureRecognizer(tapped)
    }

    func onChgSlider(sender:UISlider){
        pData.setData(sender.value, key: "width")
    }
    
    func onPen(sender:AnyObject){
        if (self.delegate?.respondsToSelector("penSelect")) != nil {
            // 実装先のメソッドを実行
            delegate?.penSelect()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol penSelectDelegate : NSObjectProtocol {
    
    func penSelect()
    
}
