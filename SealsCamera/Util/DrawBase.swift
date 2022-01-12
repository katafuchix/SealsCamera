//
//  DrawBase.swift
//  PaintLiteSwift
//
//  Created by cano on 2016/06/16.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit

class DrawBase: UIView {

    let pData = PublicDatas.getPublicDatas()
    
    var touchPoint:CGPoint?
    var currentPath:UIBezierPath?
    var drawColor:UIColor?
    
    var paths:Array<UIBezierPath>   = Array<UIBezierPath>()
    var paths2:Array<UIBezierPath>  = Array<UIBezierPath>()
    var widthArray:Array<CGFloat>   = Array<CGFloat>()
    var colorArray:Array<UIColor>   = Array<UIColor>()
    
    var drawFlg = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //drawColor = pData.getUIColorForKey("color")
        //drawColor?.set()
        
    }
    
    //描画処理
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        //drawColor = CommonUtil.getSettingThemaColor()
        /*
        let color = pData.getStringForKey("color")
        if color != "" {
            drawColor = UIColor(hex: Int(color)!, alpha: 1.0)
        }else{
            drawColor = UIColor.whiteColor()
        }
        drawColor?.set()
        */
        for (index, path) in paths.enumerate() {
            let color = colorArray[index]
            color.set()
            
            path.lineWidth = widthArray[index]
            path.miterLimit = 10
            path.lineCapStyle = .Round//kCGLineCapRound
            path.lineJoinStyle = .Round//kCGLineJoinRound
            
            //UIColor.blackColor().setFill()
            //path.fill()
            path.stroke()
            if color == UIColor.clearColor() {
                path.strokeWithBlendMode(.Clear, alpha: 0)//kCGBlendModeClear, alpha: 0)
            }
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        if !drawFlg { return }
        
        //print("start")
        currentPath = UIBezierPath()
        currentPath!.lineWidth = 3.0
        
        if let touch = touches.first {
            currentPath?.moveToPoint(touch.locationInView(self))
            paths.append(currentPath!)
            paths2.append(currentPath!)
            widthArray.append(CGFloat(pData.getFloatForKey("width")))
            
            let c = pData.getBoolForKey("clear")
            if c == true {
                drawColor = UIColor.clearColor()
            }else{
                let color = pData.getStringForKey("color")
                if color != "" {
                    drawColor = UIColor(hex: Int(color)!, alpha: 1.0)
                }else{
                    drawColor = UIColor.whiteColor()
                }
            }
            colorArray.append(drawColor!)
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //print("move")
        
        if !drawFlg { return }
        
        if let touch = touches.first {
            currentPath?.addLineToPoint(touch.locationInView(self))
            self.setNeedsDisplay()
        }
    }
    
    func undoButtonClicked() {
        if paths.count > 0 {
            paths.removeLast()
        }
        self.setNeedsDisplay()
    }
}
