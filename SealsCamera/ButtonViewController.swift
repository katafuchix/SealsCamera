//
//  ButtonViewController.swift
//  SealsCamera
//
//  Created by cano on 2016/06/20.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit

class ButtonViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {

    var delegate : buttonSelectDelegate?
    
    let reuseIdentifier = "Cell"
    
    //@IBOutlet weak var collectionView: UICollectionView!
    
    var collectionView : UICollectionView?
    let pDdata = PublicDatas.getPublicDatas()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        /*
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "menu_back.png")?.drawInRect(CGRectMake(0, 0, 50, 50))
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        */
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "footer_bg.png")!)
        
        // レイアウトを指定
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        // セルのサイズ
        flowLayout.itemSize = CGSizeMake(70.0, 70.0)
        // 縦、横のスペース
        flowLayout.minimumInteritemSpacing = 5.0
        flowLayout.minimumLineSpacing = 5.0
        // スクロールの方向
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        // サイズ、レイアウトを指定して初期化
        //collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        let rect = CGRectMake(0, 0, self.view.frame.width, 75)
        collectionView = UICollectionView(frame: rect, collectionViewLayout: flowLayout)
        // delegateを指定
        collectionView!.delegate = self
        // dataSourceを指定
        collectionView!.dataSource = self
        // セルのクラスを登録
        let itemCell = UINib(nibName: "ItemCell", bundle: nil)//.instantiateWithOwner(self, options: nil)[0]
        collectionView!.registerNib(itemCell as! UINib, forCellWithReuseIdentifier: reuseIdentifier)
        //collectionView!.registerClass(ItemCell.classForCoder(), forCellWithReuseIdentifier: reuseIdentifier)
        //collectionView!.backgroundView?.backgroundColor = UIColor(patternImage: image)
        collectionView!.backgroundColor = UIColor.clearColor()
        // 画面に表示
        //collectionView?.backgroundColor = UIColor(hex:9025020, alpha: 1.0)
        self.view.addSubview(collectionView!)
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return 6 //items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ItemCell
        
        // Configure the cell
        var n = indexPath.row
        if n == 5 { n = 7 }
        
        cell.backgroundColor = UIColor.clearColor()
        cell.layer.borderColor = UIColor.grayColor().CGColor
        cell.layer.borderWidth = 0
        cell.tag = indexPath.row
        
        let num = pDdata.getIntegerForKey("button")
        var on = "OFF"
        if num == indexPath.row {
            on = "ON"
        }
        let name = "\(n)_\(on).png"
        cell.imageView.image = UIImage(named: name)
        //print(cell)
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView,
                        didSelectItemAtIndexPath indexPath: NSIndexPath){
        /*
         // 選択されたセルの番号を表示
         let alert:UIAlertController = UIAlertController(title: "\(indexPath.row)", message: "", preferredStyle: UIAlertControllerStyle.Alert)
         alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
         // OKボタンが押された時の処理
         (action:UIAlertAction) -> Void in
         alert.dismissViewControllerAnimated(true, completion: nil)
         }))
         
         self.presentViewController(alert, animated: true, completion: nil)
         */
        
        let name = "\(indexPath.row)_OFF.png"
        print("name : \(name)")
        pDdata.setData(indexPath.row, key: "button")
        collectionView.reloadData()
        
        if (self.delegate?.respondsToSelector("buttonSelect:")) != nil {
            // 実装先のメソッドを実行
            delegate?.buttonSelect(indexPath.row)
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

protocol buttonSelectDelegate : NSObjectProtocol {
    
    func buttonSelect(index:Int)
    
}
