//
//  CommonUtil.swift
//  SealsCamera
//
//  Created by cano on 2016/07/31.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit

class CommonUtil {

    // アラートコントローラーの作成
    static func createAlert(message: String, title: String = "", handler: (((action:UIAlertAction!) -> Void)?) = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: NSLocalizedString("CommonUtil_ok", comment: ""), style: .Default, handler: handler)
        alertController.addAction(defaultAction)
        return alertController
    }
    
    // キャンセル時の動作を指定する場合
    static func createAlertOKCancel(message: String, okAction: UIAlertAction, cancelAction: UIAlertAction, title: String = "") -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        return alert
    }
    
    // 言語情報を取得
    static func getLocaleLang() -> String {
        let info = NSLocale.currentLocale().localeIdentifier  // jp_JA ja_US en_US 等
        var splitval = info.componentsSeparatedByString("_")
        return splitval[0]
    }
    
    // 言語がjaか？
    static func isJa() -> Bool {
        return getLocaleLang() == "ja"
    }
}
