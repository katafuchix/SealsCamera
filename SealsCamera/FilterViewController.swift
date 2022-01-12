//
//  FilterViewController.swift
//  SealsCamera
//
//  Created by cano on 2016/06/25.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var delegate : filterSelectDelegate?
    let reuseIdentifier = "Cell"
    
    var collectionView : UICollectionView?
    let pDdata = PublicDatas.getPublicDatas()
    
    // filter Title and Name list
    //var filterTitleList: [String]!
    //var filterNameList: [String]!
    
    let filterTitleList = ["(( Choose Filter ))" ,"PhotoEffectChrome", "PhotoEffectFade", "PhotoEffectInstant", "PhotoEffectMono", "PhotoEffectNoir", "PhotoEffectProcess", "PhotoEffectTonal", "PhotoEffectTransfer"]
    
    // set filter name list array.
    let filterNameList = ["No Filter" ,"CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectInstant", "CIPhotoEffectMono", "CIPhotoEffectNoir", "CIPhotoEffectProcess", "CIPhotoEffectTonal", "CIPhotoEffectTransfer"]
    
    var image : UIImage?
    var thumbImage : UIImage?
    
    var thumbImages : Array<UIImage>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.view.backgroundColor = UIColor.blackColor()
        /*
        //thumbImage = image?.resize(CGSizeMake(60.0, 60.0))
        print("self.parentViewController : \(self.parentViewController)")
        print("self.presentedViewController ; \(self.presentedViewController)")
        print("self.presentingViewController ; \(self.presentingViewController)")
        
        var tc = UIApplication.sharedApplication().keyWindow?.rootViewController;
        while ((tc!.presentedViewController) != nil) {
            tc = tc!.presentedViewController
        }
        print("tc : \(tc)")
        //let bc = self.parentViewController as! BaseViewController
        //self.image = bc.image
        thumbImage = image?.resize(CGSizeMake(60.0, 60.0))
        
        
        // レイアウトを指定
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        // セルのサイズ
        flowLayout.itemSize = CGSizeMake(60.0, 60.0)
        // 縦、横のスペース
        flowLayout.minimumInteritemSpacing = 10.0
        flowLayout.minimumLineSpacing = 10.0
        // スクロールの方向
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        // サイズ、レイアウトを指定して初期化
        //collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        let rect = CGRectMake(0, 0, self.view.frame.width, 74)
        collectionView = UICollectionView(frame: rect, collectionViewLayout: flowLayout)
        // delegateを指定
        collectionView!.delegate = self
        // dataSourceを指定
        collectionView!.dataSource = self
        // セルのクラスを登録
        let FilterCell = UINib(nibName: "FilterCell", bundle: nil)//.instantiateWithOwner(self, options: nil)[0]
        collectionView!.registerNib(FilterCell as! UINib, forCellWithReuseIdentifier: reuseIdentifier)
        //collectionView!.registerClass(ItemCell.classForCoder(), forCellWithReuseIdentifier: reuseIdentifier)
        //collectionView!.backgroundView?.backgroundColor = UIColor.whiteColor()
        //collectionView!.backgroundColor = UIColor.lightGrayColor()
        // 画面に表示
        //collectionView?.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!)
        */
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func setImageFile(image:UIImage){
        print("setImageFile")
        self.image = image
        self.thumbImage = image.resize(CGSizeMake(100.0, 100.0))
        
        print("self.thubImage.size : \(self.thumbImage!.size)")
        /*
        // 正方形に切り取られていない場合は切り取った比率で画像を再生成
        if self.thumbImage!.size.width != self.thumbImage!.size.height {
            let portrait = self.thumbImage!.size.width > self.thumbImage!.size.height;
            let s = portrait ? self.thumbImage!.size.width : self.thumbImage!.size.height;
            
            // 画像を表示する際の下地
            let view = UIView(frame:CGRectMake(0,0,s,s))
            view.backgroundColor = UIColor.whiteColor()
            // 画像を保存したサイズで表示
            let imageView = UIImageView(image: self.thumbImage)
            imageView.center = view.center
            view.addSubview(imageView)
            let newImage = UtilManager.getUIImageFromUIView(view)
            self.thumbImage = newImage
        }
        */
        thumbImages = Array<UIImage>()
        for i in 0 ..< 9 {
            
            let num = i + 1
            let filterImage = applyFilter(thumbImage!, filterIndex: i)
            let nameImage = UIImage(named: "f0\(num).png")
            
            //合成したいサイズを指定して、描画を開始
            let theSize = CGSizeMake(70.0, 70.0);
            UIGraphicsBeginImageContext(theSize);
            filterImage.drawAtPoint(CGPointMake(0, 0))
            nameImage?.drawInRect(CGRectMake(0, 0, 70.0, 70.0))
            
            let resultImage = UIGraphicsGetImageFromCurrentImageContext();
            //合成終了
            UIGraphicsEndImageContext();
            
            thumbImages?.append(resultImage)
        }
        
        //thumbImage = image?.resize(CGSizeMake(60.0, 60.0))
        print("self.parentViewController : \(self.parentViewController)")
        print("self.presentedViewController ; \(self.presentedViewController)")
        print("self.presentingViewController ; \(self.presentingViewController)")
        
        var tc = UIApplication.sharedApplication().keyWindow?.rootViewController;
        while ((tc!.presentedViewController) != nil) {
            tc = tc!.presentedViewController
        }
        print("tc : \(tc)")
        //let bc = self.parentViewController as! BaseViewController
        //self.image = bc.image
        thumbImage = image.resize(CGSizeMake(60.0, 60.0))
        
        
        // レイアウトを指定
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        // セルのサイズ
        flowLayout.itemSize = CGSizeMake(60.0, 60.0)
        // 縦、横のスペース
        flowLayout.minimumInteritemSpacing = 10.0
        flowLayout.minimumLineSpacing = 10.0
        // スクロールの方向
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        // サイズ、レイアウトを指定して初期化
        //collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        let rect = CGRectMake(0, 0, self.view.frame.width, 74)
        collectionView = UICollectionView(frame: rect, collectionViewLayout: flowLayout)
        // delegateを指定
        collectionView!.delegate = self
        // dataSourceを指定
        collectionView!.dataSource = self
        // セルのクラスを登録
        let FilterCell = UINib(nibName: "FilterCell", bundle: nil)//.instantiateWithOwner(self, options: nil)[0]
        collectionView!.registerNib(FilterCell as! UINib, forCellWithReuseIdentifier: reuseIdentifier)
        //collectionView!.registerClass(ItemCell.classForCoder(), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView!.backgroundView?.backgroundColor = UIColor.whiteColor()
        //collectionView!.backgroundColor = UIColor.lightGrayColor()
        // 画面に表示
        collectionView?.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!)
    }

    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        //return 8 //items.count
        return self.filterTitleList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FilterCell
        
        // Configure the cell
        
        //cell.backgroundColor = UIColor.clearColor()
        cell.layer.borderColor = UIColor.grayColor().CGColor
        cell.layer.borderWidth = 1
        /*
        let bc = self.parentViewController as! BaseViewController
        self.image = bc.image
        thumbImage = image?.resize(CGSizeMake(120.0, 120.0))
        
        let num = indexPath.row + 1
        */
        //cell.baseImageView.image = applyFilter(thumbImage!, filterIndex: indexPath.row)
        //cell.imageView.image = UIImage(named: "f0\(num).png")
        /*
        let filterImage = applyFilter(thumbImage!, filterIndex: indexPath.row)
        let nameImage = UIImage(named: "f0\(num).png")
        
        //合成したいサイズを指定して、描画を開始
        let theSize = CGSizeMake(70.0, 70.0);
        UIGraphicsBeginImageContext(theSize);
        filterImage.drawAtPoint(CGPointMake(0, 0))
        nameImage?.drawInRect(CGRectMake(0, 0, 70.0, 70.0))
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext();
        //合成終了
        UIGraphicsEndImageContext();
        */
        cell.imageView.image = thumbImages![indexPath.row]
        
        //print("self.parentViewController : \(self.parentViewController)")
        //cell.label.text = self.filterTitleList[indexPath.row]
        //print(cell)
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView,
                        didSelectItemAtIndexPath indexPath: NSIndexPath){
       
        if (self.delegate?.respondsToSelector("filterSelect:")) != nil {
            // 実装先のメソッドを実行
            delegate?.filterSelect(indexPath.row)
        }
    }

    func applyFilter(image:UIImage, filterIndex: Int) -> UIImage {
        //let filterViewController = self.childViewControllers[0] as! FilterViewController
        
        print("Filter - \(self.filterNameList[filterIndex])")
        
        /* filter name
         0 - NO Filter,
         1 - PhotoEffectChrome, 2 - PhotoEffectFade, 3 - PhotoEffectInstant, 4 - PhotoEffectMono,
         5 - PhotoEffectNoir, 6 - PhotoEffectProcess, 7 - PhotoEffectTonal, 8 - PhotoEffectTransfer
         */
        
        // if No filter selected then apply default image and return.
        if filterIndex == 0 {
            // set image selected image
            return image
        }
        
        
        // Create and apply filter
        // 1 - create source image
        let sourceImage = CIImage(image: image)
        
        // 2 - create filter using name
        let myFilter = CIFilter(name: self.filterNameList[filterIndex])
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
        return filteredImage
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


protocol filterSelectDelegate : NSObjectProtocol {
    
    func filterSelect(index:Int)
    
}
