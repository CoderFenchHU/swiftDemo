//
//  ViewController.swift
//  PageViewDemo
//
//  Created by taoyi-two on 2017/4/10.
//  Copyright © 2017年 taoyitech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupPage()
        
        
//        setupPageCollection()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupPage() {
        let pageFrame = CGRect(x:0, y:64, width: view.bounds.width, height:view.bounds.height - 64)
        let titles = ["推荐", "游戏","娱乐","趣玩","我的推荐", "我的游戏","我的娱乐","趣玩"]
        //        let titles = ["推荐", "游戏","娱乐","趣玩"]
        var childVcs  = [UIViewController]()
        
        
        for _ in 0 ..< titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childVcs.append(vc)
            
        }
        let parentVc = self
        
        var style = HFPageStyle()
        style.titleHeight = 44
        style.isScrollEnable = true
        style.isNeedScale = true
        style.isShowCoverView = true
        style.isShowBottomLine = false
        let pageView = HFPageView(frame: pageFrame, titles: titles, style: style, childVCs: childVcs, parentVc: parentVc)
        self.view.addSubview(pageView)
        
    }
    
    func setupPageCollection()  {
        let titles = ["普通", "精华", "豪华", "专属"]
        
        var style = HFPageStyle()
        style.isShowBottomLine = true
        
        let layout = HFPageCollectionLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.colMargin = 8
        layout.rowMargin = 8
        
        let frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: 400)
        let pageCollection = HFPageCollectionView(frame: frame, titles: titles, isTop: true, style: style, layout: layout)
        pageCollection.dataSource = self
        pageCollection.registerCell(UICollectionViewCell.self, reusableIdentify: "cellCollection")
        view.addSubview(pageCollection)
    }
}


extension ViewController : HFWaterFallDataSource{
    func waterFallLayout(_ layout: HFWaterFallLayout, itemIndex: Int) -> CGFloat {
        let screenW = UIScreen.main.bounds.width
        return itemIndex % 2 == 0 ? screenW * 2 / 3 : screenW * 0.5
    }
}

extension ViewController: HFPageCollectionViewDataSource{
    func numberOfSectionsInPageCollectionView(_ pageCollectionView: HFPageCollectionView) -> Int {
        return 4
    }
    
    func pageCollectionView(_ pageCollectionView: HFPageCollectionView, numberOfItemsIn section: Int) -> Int {
        return Int(arc4random_uniform(16) + 6)
    }
    
    func pageCollectionView(_ pageCollectionView: HFPageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCollection", for: indexPath)
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }
}
