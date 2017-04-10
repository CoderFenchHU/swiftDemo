//
//  ViewController.swift
//  PageViewDemo
//
//  Created by taoyi-two on 2017/4/10.
//  Copyright © 2017年 taoyitech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate lazy var tableView : UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    let items = ["瀑布流", "滑动标题栏", "表情键盘"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "主页"
        self.tableView.backgroundColor = .white
        view.addSubview(tableView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell;
    }
}

extension ViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let waterFallVc = HFWaterFallViewController()
            waterFallVc.title = items[0]
            self.navigationController?.pushViewController(waterFallVc, animated: true)
        case 1:
            let pageVc = HFPageViewController()
            pageVc.title = items[1]
            self.navigationController?.pushViewController(pageVc, animated: true)
        case 2:
            let emojiVc = HFEmojiViewController()
            emojiVc.title = items[2]
            self.navigationController?.pushViewController(emojiVc, animated: true)
        default: break
        }
    }
}


class HFEmojiViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        setupPageCollection()
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
extension HFEmojiViewController : HFPageCollectionViewDataSource{
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


class HFPageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        setupPage()
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
    
}

class HFWaterFallViewController: UIViewController {
    fileprivate var itemCount = 30
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = HFWaterFallLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.cols = 2
        layout.dataSource = self
        
        let collectionView : UICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "layoutCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollection()
    }
    
    
    func setupCollection()  {
        view.addSubview(collectionView)
    }
    
    
}
extension HFWaterFallViewController : HFWaterFallDataSource{
    func waterFallLayout(_ layout: HFWaterFallLayout, itemIndex: Int) -> CGFloat {
        let screenW = UIScreen.main.bounds.width
        return itemIndex % 2 == 0 ? screenW * 2 / 3 : screenW * 0.5
    }
}

extension HFWaterFallViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "layoutCell", for: indexPath)
        cell.backgroundColor = UIColor.randomColor()
        
        var label : UILabel? = cell.contentView.subviews.first as? UILabel
        if label == nil {
            label = UILabel(frame: cell.bounds)
            label?.textAlignment = .center
            label?.textColor = UIColor.black
            cell.contentView.addSubview(label!)
        }
        label?.text = "\(indexPath.item)"
        
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
            itemCount += 30
            collectionView.reloadData()
        }
    }
}

