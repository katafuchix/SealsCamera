//
//  UINavigationControllerEx.swift
//  SealsCamera
//
//  Created by cano on 2016/07/01.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit

extension UINavigationController{
    /*
    override public func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return .LightContent
    }
    */
    override public func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override public func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override public func childViewControllerForStatusBarStyle() -> UIViewController? {
        return nil
    }
}