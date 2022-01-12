//
//  BaseViewController.swift
//  SealsCamera
//
//  Created by cano on 2016/06/20.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit
import AVFoundation

enum EditStatus : Int {
    case Not = 0
    case Stamp = 1
    case Pen = 2
    case Frame = 3
    case Filter = 4
}

class BaseViewController: UIViewController, UIGestureRecognizerDelegate, buttonSelectDelegate , filterSelectDelegate, ZDStickerViewDelegate, penSelectDelegate, colorPickerDelegate
{

    let AD_VIEW_HEIGHT : CGFloat = 50.0
    let MENU_VIEW_HEIGHT : CGFloat = 75.0
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image : UIImage?
    
    @IBOutlet weak var adView: UIView!
    
    @IBOutlet weak var menuContainer: UIView!
    
    @IBOutlet weak var filterContainer: UIView!
    @IBOutlet weak var filterContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterContainerTopConstraint: NSLayoutConstraint!
    
    var isShowFilter : Bool = false
    
    @IBOutlet weak var penContainer: UIView!
    @IBOutlet weak var penContainerTopConstraint: NSLayoutConstraint!
    var isShowPen: Bool = false
    var penViewController : PenViewController?
    
    var currentlyEditingView : ZDStickerView?
    var ZDStickerViews:Array<ZDStickerView>?
    
    var frameView:FrameView?
    var pData = PublicDatas.getPublicDatas()
    
    var status : EditStatus?
    
    @IBOutlet weak var undoBtn: UIButton!
    @IBOutlet weak var eraserBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var headerView: UIImageView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var backgroundUnderImageView: UIImageView!
    
    // navigationcontrollerに元から設定されているdelagateを保持しておく
    private var originalNavigationControllerDelegate: UIGestureRecognizerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.image = image
        //filterContainerBottomConstraint.constant -= filterContainer.frame.size.height
        //showFilter()
        
        penViewController = self.childViewControllers[0] as? PenViewController
        penViewController!.delegate = self
        
        let filterViewController = self.childViewControllers[1] as! FilterViewController
        filterViewController.setImageFile(self.imageView.image!)
        filterViewController.delegate = self
        
        let buttonViewController = self.childViewControllers[2] as! ButtonViewController
        buttonViewController.delegate = self
        
        status = EditStatus.Not
        currentlyEditingView = nil
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func onHome(sender: AnyObject) {
        //self.navigationController?.popToRootViewControllerAnimated(true)
        
        //アラートを表示する
        let okAction = UIAlertAction(title: "OK", style: .Default) {
            action in NSLog("OK！")
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        var message = "";
        if CommonUtil.isJa() {
            message = "編集中の画像があります。\nHOMEへ戻りますか？"
        }else{
            message = "Image is editing.\n Do you come back to the first screen?"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) {
            action in NSLog("キャンセル")
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        let alert = CommonUtil.createAlertOKCancel(message, okAction: okAction, cancelAction: cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func onSave(sender: AnyObject) {
        let cropImage = getImage()
        UIImageWriteToSavedPhotosAlbum(cropImage, self, "image:didFinishSavingWithError:contextInfo:", nil)
    }
    
    func getImage()->UIImage {
        unFocus()
        print(imageView!.frame)
        var r = AVMakeRectWithAspectRatioInsideRect(self.imageView!.image!.size, self.imageView!.frame)
        
        if frameView != nil && frameView!.isDescendantOfView(imageView) {
            //r = (frameView?.frame)!
            r = CGRectMake(0, 50.0, frameView!.frame.size.width, frameView!.frame.size.height)
        }
        print("frameView : \(frameView)")
        print(r)
        
        // self.viewを画像化
        let viewImg = UtilManager.getUIImageFromUIView(self.view)
        //UIImageWriteToSavedPhotosAlbum(viewImg, self, "image:didFinishSavingWithError:contextInfo:", nil)
        
        // imageViewのimageを切り取る
        let cropImage = self.cropImage(viewImg, rect:
            CGRectMake(
                r.origin.x ,
                r.origin.y ,
                r.size.width,
                r.size.height
            )
        )
        return cropImage
    }
    
    func unFocus(){
        //currentlyEditingLabel?.hideEditingHandles()
        let views = self.view.subviews
        for view in views {
            if view.isKindOfClass(ZDStickerView) {
                let z = view as! ZDStickerView
                z.hideEditingHandles()
            }
            /*if view.isKindOfClass(IQLabelView) {
                let i = view as! IQLabelView
                i.hideEditingHandles()
            }*/
        }
    }
    
    
    func cropImage(image:UIImage, rect:CGRect)->UIImage {
        let scale = image.scale
        
        let cliprect = CGRectMake(rect.origin.x * scale, rect.origin.y * scale,
                                  rect.size.width * scale, rect.size.height * scale)
        // ソース画像からCGImageRefを取り出す
        let srcImgRef : CGImageRef = image.CGImage!
        
        // 指定された範囲を切り抜いたCGImageRefを生成しUIImageとする
        let imgRef : CGImageRef = CGImageCreateWithImageInRect(srcImgRef, cliprect)!
        let resultImage : UIImage = UIImage(CGImage: imgRef, scale: scale, orientation: image.imageOrientation)
        
        // 後片付け
        //CGImageRelease(imgRef)
        return resultImage
    }
    
    // 画像保存時のセレクタ
    func image(image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutablePointer<Void>) {
        
        var message : String?
        if error == nil {
            if CommonUtil.isJa() {
                message = "画像を保存しました"
            }else{
                message = "saved successfully."
            }
        }
        // 処理の完了時にはアラートを出す
        let alert = UIAlertController(title: message!, message: "", preferredStyle: .Alert)
        // OKボタンを追加
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(okAction)
        // 表示
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // menu button
    func buttonSelect(index:Int) {
        print(index)
        switch index {
        case 0:
            hidePen()
            chgStatus(EditStatus.Filter)
            if !isShowFilter {
                showFilter()
            }else{
                hideFilter()
            }
        case 4:
            hideFilter()
            chgStatus(EditStatus.Pen)
            if !isShowPen {
                showPen()
            }else{
                hidePen()
            }
        case 5:
            hideFilter()
            hidePen()
            showFrameSelectViewController()
        default:
            hideFilter()
            hidePen()
            chgStatus(EditStatus.Stamp)
            showSelectViewController(index)
        }
    }
    
    func showSelectViewController(index:Int){
        // ビューコントローラーを取得
        let story = UIStoryboard(name: "Main", bundle: nil)
        let selectVC = story.instantiateViewControllerWithIdentifier("SelectViewController") as! SelectViewController
        selectVC.type = index
        
        selectVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        //self.modalPresentationStyle = .CurrentContext
        self.presentViewController(selectVC, animated: true, completion: nil)
    }
    
    func showFrameSelectViewController(){
        // ビューコントローラーを取得
        let story = UIStoryboard(name: "Main", bundle: nil)
        let selectVC = story.instantiateViewControllerWithIdentifier("FrameSelectViewController") as! FrameSelectViewController
        
        selectVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        //self.modalPresentationStyle = .CurrentContext
        self.presentViewController(selectVC, animated: true, completion: nil)
    }
    
    
    func onFilter(sender:AnyObject) {
        //StampTopConstraint.constant = self.view.frame.height - 240
        if isShowFilter {
            hideFilter()
        }else{
            showFilter()
        }
    }
    
    func showFilter(){
        //self.view.bringSubviewToFront(filterContainer)
        //self.view.bringSubviewToFront(menuContainer)
        UIView.animateWithDuration(0.2, animations: {
            self.filterContainerTopConstraint.constant = self.view.frame.size.height - (self.MENU_VIEW_HEIGHT + self.filterContainer.frame.size.height)
            print("self.filterContainerTopConstraint.constant : \(self.filterContainerTopConstraint.constant)")
            //+= self.filterContainer.frame.size.height
            //self.view.layoutIfNeeded()
            self.view.layoutSubviews()
            //self.view.setNeedsUpdateConstraints()
            },completion: {
                finished in
                self.isShowFilter = true
                //print(self.filterContainer.frame)
            }
        )
    }
    
    func hideFilter(){
        UIView.animateWithDuration(0.2, animations: {
            self.filterContainerTopConstraint.constant = self.view.frame.size.height + self.filterContainer.frame.size.height
            print("self.filterContainerTopConstraint.constant : \(self.filterContainerTopConstraint.constant)")
            //self.view.layoutIfNeeded()
            self.view.layoutSubviews()
            //self.view.setNeedsUpdateConstraints()
            }, completion: {
                finished in
                self.isShowFilter = false
                //print(self.filterContainer.frame)
        } )
    }
    
    func filterSelect(index:Int){
        print(index)
        applyFilter(selectedFilterIndex: index)
    }
    
    // apply filter to current image
    private func applyFilter(selectedFilterIndex filterIndex: Int) {
        let filterViewController = self.childViewControllers[1] as! FilterViewController
        
        print("Filter - \(filterViewController.filterNameList[filterIndex])")
        
        /* filter name
         0 - NO Filter,
         1 - PhotoEffectChrome, 2 - PhotoEffectFade, 3 - PhotoEffectInstant, 4 - PhotoEffectMono,
         5 - PhotoEffectNoir, 6 - PhotoEffectProcess, 7 - PhotoEffectTonal, 8 - PhotoEffectTransfer
         */
        
        // if No filter selected then apply default image and return.
        if filterIndex == 0 {
            // set image selected image
            self.imageView.image = self.image
            return
        }
        
        
        // Create and apply filter
        // 1 - create source image
        let sourceImage = CIImage(image: self.image!)
        
        // 2 - create filter using name
        let myFilter = CIFilter(name: filterViewController.filterNameList[filterIndex])
        myFilter?.setDefaults()
        
        // 3 - set source image
        myFilter?.setValue(sourceImage, forKey: kCIInputImageKey)
        
        // 4 - create core image context
        let context = CIContext(options: nil)
        
        // 5 - output filtered image as cgImage with dimension.
        let outputCGImage = context.createCGImage(myFilter!.outputImage!, fromRect: myFilter!.outputImage!.extent)
        
        // 6 - convert filtered CGImage to UIImage
        let filteredImage = UIImage(CGImage: outputCGImage)
        
        // 7 - set filtered image to preview
        self.imageView.image = filteredImage
    }
    
    func addStamp(image:UIImage){
        /*
         if currentlyEditingView != nil {
         currentlyEditingView?.hideEditingHandles()
         }
         */
        chgStatus(EditStatus.Stamp)
        
        let r = AVMakeRectWithAspectRatioInsideRect(self.imageView!.image!.size, self.imageView!.frame)
        let gripFrame1 : CGRect = CGRectMake(r.origin.x + 30 , r.origin.y + 30 , 150, 150)
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
        userResizableView1.rangeRect = self.imageView.frame
        self.view.addSubview(userResizableView1)
        
        currentlyEditingView = userResizableView1
        ZDStickerViews?.append(userResizableView1)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //print("status : \(status) \(status?.rawValue)")
        if status != EditStatus.Stamp { return }
        
        if let touch = touches.first {
        let p = touch.locationInView(self.view)
        
            //print("currentlyEditingView : \(currentlyEditingView)")
            if currentlyEditingView != nil {
                //print("currentlyEditingView?.isEditingHandlesHidden() : \(currentlyEditingView?.isEditingHandlesHidden())")
                //print("currentlyEditingView?.frame : \(currentlyEditingView?.frame)")
                //print("p : \(p)")
                if currentlyEditingView?.isEditingHandlesHidden() == false  && !CGRectContainsPoint((currentlyEditingView?.frame)!, p){
                currentlyEditingView?.hideEditingHandles()
                    currentlyEditingView = nil
                    return
                }
            }
            
            let bundleName = pData.getStringForKey("bundleName")
            let name = pData.getStringForKey("imageName")
            
            if(bundleName == "" && name == "" ){
                return 
            }
            
            let bundlepath = NSBundle.mainBundle().pathForResource(bundleName, ofType: "bundle")
            var isDir : ObjCBool = false
            if NSFileManager.defaultManager().fileExistsAtPath(bundlepath! + "/" + name, isDirectory: &isDir) {
                let url = NSURL(fileURLWithPath: bundlepath!).URLByAppendingPathComponent(name)
                let image = UIImage(contentsOfFile: url.path!)
                
                //print("imgUrl.path! : \(url.path!)")
                if !CGRectContainsPoint(self.imageView.frame, p) { return }
                
                let gripFrame1 : CGRect = CGRectMake(p.x , p.y , 150, 150)
                let contentView : UIView = UIView(frame:gripFrame1)
                contentView.backgroundColor = UIColor.clearColor()
                
                let imageView1 = UIImageView(image: image)
                imageView1.contentMode = .ScaleAspectFit
                contentView.addSubview(imageView1)
                
                let views = self.view.subviews.reverse()
                for view in views {
                    if view.isKindOfClass(ZDStickerView) {
                        let z = view as! ZDStickerView
                        z.hideEditingHandles()
                    }
                }
                
                let userResizableView1 : ZDStickerView = ZDStickerView(frame: gripFrame1)
                userResizableView1.tag = 0
                userResizableView1.stickerViewDelegate = self
                userResizableView1.contentView = contentView
                userResizableView1.preventsPositionOutsideSuperview = false
                userResizableView1.translucencySticker = false
                userResizableView1.showEditingHandles()
                userResizableView1.rangeRect = self.imageView.frame
                userResizableView1.center = p
                self.view.addSubview(userResizableView1)
                
                self.view.bringSubviewToFront(headerView)
                self.view.bringSubviewToFront(homeBtn)
                self.view.bringSubviewToFront(saveBtn)
                
                self.view.bringSubviewToFront(backgroundUnderImageView)
                self.view.bringSubviewToFront(undoBtn)
                self.view.bringSubviewToFront(eraserBtn)
                self.view.bringSubviewToFront(menuContainer)
                
                currentlyEditingView = userResizableView1
                ZDStickerViews?.append(userResizableView1)
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //print(touches)
    }
    
    func addFrame(index:Int){
        chgStatus(EditStatus.Frame)
        
        frameView?.removeFromSuperview()
        
        let name = "\(index).png"
        let bundlepath = NSBundle.mainBundle().pathForResource("iphone5_Frame", ofType: "bundle")
        var isDir : ObjCBool = false
        if NSFileManager.defaultManager().fileExistsAtPath(bundlepath! + "/" + name, isDirectory: &isDir) {
            let url = NSURL(fileURLWithPath: bundlepath!).URLByAppendingPathComponent(name)
            let image = UIImage(contentsOfFile: url.path!)
            frameView = FrameView(frame:self.imageView.frame)
            frameView?.setFrameImage(image!)
            self.view.addSubview(frameView!)
        }
    }
    
    func stickerViewDidLongPressed(sticker:ZDStickerView){
        
        if sticker.isEditingHandlesHidden() == true {
            sticker.showEditingHandles()
            currentlyEditingView = sticker
            
            let views = self.view.subviews.reverse()
            for view in views {
                if view.isKindOfClass(ZDStickerView) {
                    let z = view as! ZDStickerView
                    if z != sticker {
                        z.hideEditingHandles()
                    }
                }
            }
        }else{
            sticker.hideEditingHandles()
        }
    }
 
    func stickerViewDidClose(sticker: ZDStickerView!) {
        //print(sticker.tag)
        currentlyEditingView = nil
    }
    
    func stickerViewDidCustomButtonTap(sticker: ZDStickerView!) {
        print(sticker.tag)
    }
    
    func stickerViewDidBeginEditing(sticker: ZDStickerView!) {
        print(sticker)
    }
    
    // delegateでよばれるスタンプを貼るメソッド
    func stickerViewTouchBegin(sticker: ZDStickerView!){
        //print(touch)
        /*
        var setT = Set<UITouch>()
        setT = [touch]
        self.touchesBegan(setT, withEvent: nil)
        */
        let views = self.view.subviews.reverse()
        for view in views {
            if view.isKindOfClass(ZDStickerView) {
                let z = view as! ZDStickerView
                if z != sticker {
                    z.hideEditingHandles()
                }
            }
        }
        sticker.showEditingHandles()
    }
 
    func addDrawView() {
        let r = AVMakeRectWithAspectRatioInsideRect(self.imageView!.image!.size, self.imageView!.frame)
        //print("r : \(r)")
        let drawBase = DrawBase(frame:r)
        imageView!.userInteractionEnabled = true
        drawBase.userInteractionEnabled = true
        //drawBase.backgroundColor = UIColor.blackColor()
        self.view.addSubview(drawBase)
    }
    
    func onPen(sender:AnyObject) {
        //StampTopConstraint.constant = self.view.frame.height - 240
        
        if isShowPen {
            hidePen()
        }else{
            showPen()
        }
    }
    
    func showPen(){
        //self.view.bringSubviewToFront(filterContainer)
        //self.view.bringSubviewToFront(menuContainer)
        self.view.bringSubviewToFront(penContainer)
        self.view.bringSubviewToFront(menuContainer)
        UIView.animateWithDuration(0.2, animations: {
            self.penContainerTopConstraint.constant = self.view.frame.size.height - (self.AD_VIEW_HEIGHT + self.MENU_VIEW_HEIGHT + self.penContainer.frame.size.height)
            print("self.penContainerTopConstraint.constant : \(self.penContainerTopConstraint.constant)")
            //+= self.filterContainer.frame.size.height
            //self.view.layoutIfNeeded()
            self.view.layoutSubviews()
            //self.view.setNeedsUpdateConstraints()
            },completion: {
                finished in
                self.isShowPen = true
                //print(self.filterContainer.frame)
                self.addDrawView()
            }
        )
    }
    
    func hidePen(){
        UIView.animateWithDuration(0.2, animations: {
            self.penContainerTopConstraint.constant = self.view.frame.size.height + self.penContainer.frame.size.height
            print("self.penContainerTopConstraint.constant : \(self.penContainerTopConstraint.constant)")
            //self.view.layoutIfNeeded()
            self.view.layoutSubviews()
            //self.view.setNeedsUpdateConstraints()
            }, completion: {
                finished in
                self.isShowPen = false
                //print(self.filterContainer.frame)
        } )
    }
    
    func penSelect() {
        self.pData.setData(false, key: "clear")
        // ビューコントローラーを取得
        let story = UIStoryboard(name: "Main", bundle: nil)
        let colorVC = story.instantiateViewControllerWithIdentifier("ColorPickerViewController") as! ColorPickerViewController
        colorVC.delegate = self
        colorVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        //self.modalPresentationStyle = .CurrentContext
        self.presentViewController(colorVC, animated: true, completion: nil)
    }
    
    func colorSelect() {
        let color = pData.getStringForKey("color")
        if color != "" {
            penViewController!.penBaseView.backgroundColor = UIColor(hex: Int(color)!, alpha: 1.0)
        }else{
            penViewController!.penBaseView.backgroundColor = UIColor.clearColor()
        }
        self.addDrawView()
    }
    
    @IBAction func onEraser(sender: AnyObject) {
        if status != EditStatus.Pen { return }
        self.pData.setData(true, key: "clear")
    }
    
    @IBAction func onUndo(sender: AnyObject) {
        
        let views = self.view.subviews.reverse()
        for view in views {
            if view.isKindOfClass(ZDStickerView) {
                let z = view as! ZDStickerView
                if z.isEditingHandlesHidden() == false {
                    currentlyEditingView = nil
                }
                z.removeFromSuperview()
                ZDStickerViews?.removeLast()
                //chgStatus(EditStatus.Stamp)
                break
            }
            if view.isKindOfClass(DrawBase) {
                let drawBase = view as! DrawBase
                //drawBase.undoButtonClicked()
                if drawBase.paths.count == 0 { //&& self.imageView?.subviews.count > 1 {
                    drawBase.removeFromSuperview()
                    continue;
                }else{
                    drawBase.undoButtonClicked()
                    break
                }
                //break
            }
            
            if view.isKindOfClass(FrameView) {
                view.removeFromSuperview()
                break
            }
        }
        
        let nviews = self.view.subviews.reverse()
        if nviews.count == 0 { return }
        for view in nviews {
            //print("view : \(view)")
            if view.isKindOfClass(ZDStickerView) {
                chgStatus(EditStatus.Stamp)
                 break
            }else if view.isKindOfClass(DrawBase) {
                chgStatus(EditStatus.Pen)
                // 描画可能に
                let drawBase = view as! DrawBase
                drawBase.drawFlg = true
                 break
            }else if view.isKindOfClass(FrameView) {
                chgStatus(EditStatus.Frame)
                 break
            }else{
                //chgStatus(EditStatus.Not)
            }
            //break
        }
    }
    
    func chgStatus(s:EditStatus){
        
        status = s
        
        if status == EditStatus.Pen {
            self.pData.setData(false, key: "clear")
        }else{
            // ペン以外のときはペンの描画を無効にしておく
            self.disableDraw()
        }
        if status == EditStatus.Stamp {
            pData.setData("", key: "bundleName")
            pData.setData("", key: "imageName")
            return
        }
        
        let views = self.view.subviews.reverse()
        for view in views {
            //print("view : \(view)")
            if view.isKindOfClass(ZDStickerView) {
                let z = view as! ZDStickerView
                z.hideEditingHandles()
            }
        }
    }
    
    // ペンを無効に
    func disableDraw(){
        let views = self.view.subviews
        for view in views {
            if view.isKindOfClass(DrawBase) {
                let d = view as! DrawBase
                d.drawFlg = false
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // popGestureを乗っ取り、左スワイプでpopを無効化する
        // 必ずdisappearとセットで用いること
        if let popGestureRecognizer = navigationController?.interactivePopGestureRecognizer {
            self.originalNavigationControllerDelegate = popGestureRecognizer.delegate
            popGestureRecognizer.delegate = self
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // popGestureを乗っ取り、左スワイプでpopを無効化する(のを解除する)
        // 必ずwillAppear/willDisappearとセットで用いること
        if let popGestureRecognizer = navigationController?.interactivePopGestureRecognizer {
            popGestureRecognizer.delegate = originalNavigationControllerDelegate
            originalNavigationControllerDelegate = nil
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    // popGestureを乗っ取り、左スワイプでpopを無効化する
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
