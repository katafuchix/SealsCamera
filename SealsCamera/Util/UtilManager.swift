//
//  UtilManager.swift
//  PaintLiteSwift
//
//  Created by cano on 2016/06/15.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit

class UtilManager: NSObject {

    // UIViewからUIImageを生成
    static func getUIImageFromUIView(myUIView:UIView) ->UIImage
    {
        print("myUIView : \(myUIView.frame)")
        UIGraphicsBeginImageContextWithOptions(myUIView.frame.size, true, 2.0);//必要なサイズ確保
        let context:CGContextRef = UIGraphicsGetCurrentContext()!;
        CGContextTranslateCTM(context, -myUIView.frame.origin.x, -myUIView.frame.origin.y);
        myUIView.layer.renderInContext(context);
        let renderedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return renderedImage;
    }
    
    // 現在日時
    static func getNowDateTime() -> String {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: NSLocaleLanguageCode)
        formatter.dateFormat = "YYYYMMDDHHmmss"
        return formatter.stringFromDate(NSDate())
    }
}
