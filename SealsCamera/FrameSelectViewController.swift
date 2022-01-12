//
//  FrameSelectViewController.swift
//  SealsCamera
//
//  Created by cano on 2016/06/29.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit

class FrameSelectViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource{
    
    var delegate : filterSelectDelegate?
    let reuseIdentifier = "Cell"
    
    var collectionView : UICollectionView?
    let pDdata = PublicDatas.getPublicDatas()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.7)
        
        // レイアウトを指定
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        // セルのサイズ
        flowLayout.itemSize = CGSizeMake(100.0, 100.0)
        // 縦、横のスペース
        flowLayout.minimumInteritemSpacing = 10.0
        flowLayout.minimumLineSpacing = 10.0
        // スクロールの方向
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        // サイズ、レイアウトを指定して初期化
        //collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        let rect = CGRectMake(0, 40.0, self.view.frame.width, self.view.frame.height-40.0)
        collectionView = UICollectionView(frame: rect, collectionViewLayout: flowLayout)
        // delegateを指定
        collectionView!.delegate = self
        // dataSourceを指定
        collectionView!.dataSource = self
        // セルのクラスを登録
        let itemCell = UINib(nibName: "FrameCell", bundle: nil)//.instantiateWithOwner(self, options: nil)[0]
        collectionView!.registerNib(itemCell as! UINib, forCellWithReuseIdentifier: reuseIdentifier)
        //collectionView!.registerClass(ItemCell.classForCoder(), forCellWithReuseIdentifier: reuseIdentifier)
        // 画面に表示
        collectionView?.backgroundColor = UIColor.clearColor() //UIColor(hex:9025020, alpha: 1.0)
        collectionView?.alpha = 1.0
        self.view.addSubview(collectionView!)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func onClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return 13 //items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FrameCell
        
        // Configure the cell
        
        cell.backgroundColor = UIColor.clearColor()
        cell.layer.borderColor = UIColor.grayColor().CGColor
        cell.layer.borderWidth = 0
        
        let num = indexPath.row
        let name = "\(num).png.png"
        let bundlepath = NSBundle.mainBundle().pathForResource("iphone5_Frame_SAM213", ofType: "bundle")
        var isDir : ObjCBool = false
        if NSFileManager.defaultManager().fileExistsAtPath(bundlepath! + "/" + name, isDirectory: &isDir) {
            let url = NSURL(fileURLWithPath: bundlepath!).URLByAppendingPathComponent(name)
            let image = UIImage(contentsOfFile: url.path!)
            cell.imageView.image = image
        }
        return cell
    }
    
    
    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView,
                        didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        let cell = self.collectionView?.cellForItemAtIndexPath(indexPath) as! FrameCell
        
        let nc = self.presentingViewController as! UINavigationController
        let bc = nc.viewControllers[1] as! BaseViewController
        bc.addFrame(indexPath.row)
        
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
