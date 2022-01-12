//
//  ColorPickerViewController.swift
//  SealsCamera
//
//  Created by cano on 2016/07/03.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController {

    @IBOutlet weak var colorWall: ColorWell!
    @IBOutlet weak var colorPicker: ColorPicker!
    //@IBOutlet weak var huePicker: SwiftHUEColorPicker!
    @IBOutlet weak var huePicker: HuePicker!
    
    var pickerController : ColorPickerController?
    var pData = PublicDatas.getPublicDatas()
    
    var delegate : colorPickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.5)
        
        pickerController = ColorPickerController(svPickerView: colorPicker!, huePickerView: huePicker!, colorWell: colorWall!)
        
        let color = pData.getStringForKey("color")
        if color != "" {
            pickerController?.color = UIColor(hex: Int(color)!, alpha: 1.0)
        }else{
            pickerController?.color = UIColor.whiteColor()
        }
        
        // get color updates:
        pickerController?.onColorChange = {(color, finished) in
            if finished {
                //self.colorWall.color = color
                //self.view.backgroundColor = UIColor.whiteColor() // reset background color to white
                //self.pData.setData(color, key: "color")
                //print("color : \(color)")
                //print("color : \(String(UIColor.toInt32(color)))")
                
                self.pData.setData(String(UIColor.toInt32(color)), key: "color")
                
                if (self.delegate?.respondsToSelector("colorSelect")) != nil {
                    // 実装先のメソッドを実行
                    self.delegate?.colorSelect()
                }
                
            } else {
                //self.colorWall.color = color
                //self.view.backgroundColor = color // set background color to current selected color (finger is still down)
            }
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func onClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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

protocol colorPickerDelegate : NSObjectProtocol {
    
    func colorSelect()
    
}
