//
//  ViewController.swift
//  SealsCamera
//
//  Created by cano on 2016/06/20.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate
    //, imageSelectDelegate
{

    @IBOutlet weak var albumView: UIView!
    
    @IBOutlet weak var cameraView: UIView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        let albumTap = UITapGestureRecognizer(target: self, action: "tapAlbumGesture:")
        self.albumView.addGestureRecognizer(albumTap)
        
        let cameraTap = UITapGestureRecognizer(target: self, action: "tapCameraGesture:")
        self.cameraView.addGestureRecognizer(cameraTap)
        
    }
    /*
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        self.setNeedsStatusBarAppearanceUpdate()
*/
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // ビューへのタップイベントを拾う   追加ボタンの有効範囲
    func tapAlbumGesture(sender: UITapGestureRecognizer){
        //print("tapAlbumGesture")
        self.albumView.backgroundColor = UIColor.lightGrayColor()
        self.albumView.alpha = 0.3
        onImage("")
    }
    
    func tapCameraGesture(sender: UITapGestureRecognizer){
        print("tapCameraGesture")
        self.cameraView.backgroundColor = UIColor.lightGrayColor()
        self.cameraView.alpha = 0.3
        cameraStart("")
    }
    
    func cameraStart(sender : AnyObject) {
        
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.Camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            self.presentViewController(cameraPicker, animated: true, completion: nil)
            
        }
    }
    
    func onImage(sender:AnyObject){
        
        print("on image")
        //rightMenuConstraint.constant -= 200
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = true
            
            imagePicker.navigationBar.translucent = false
            imagePicker.navigationBar.barStyle = .Default
            imagePicker.navigationBar.tintColor = UIColor.blackColor()
            
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    /*
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        self.setNeedsStatusBarAppearanceUpdate()
    }
    */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //print(info)
        /*
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("cropper-vc") as! CropperViewController
            vc._image = pickedImage
            vc.delegate = self
            picker.pushViewController(vc, animated: true)
         
        }
        */
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectImage(picker, image:pickedImage)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
        self.albumView.backgroundColor = UIColor.clearColor()
        self.cameraView.backgroundColor = UIColor.clearColor()
    }
    
    func selectImage(picker: UIImagePickerController, image:UIImage) {
        
        // 初回ボタンの選択はフィルタに
        PublicDatas.getPublicDatas().setData(0, key: "button")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("BaseViewController") as! BaseViewController
        //vc._image = pickedImage
        vc.image = image
        self.navigationController!.pushViewController(vc, animated: true)
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.albumView.backgroundColor = UIColor.clearColor()
        self.cameraView.backgroundColor = UIColor.clearColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

