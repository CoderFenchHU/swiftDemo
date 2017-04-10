//
//  HFPageCollectionView.swift
//  LiveAPP
//
//  Created by taoyi-two on 2017/3/22.
//  Copyright © 2017年 taoyitech. All rights reserved.
//

import UIKit

protocol HFPageCollectionViewDataSource : class {
    func numberOfSectionsInPageCollectionView(_ pageCollectionView: HFPageCollectionView) -> Int
    
    func pageCollectionView(_ pageCollectionView: HFPageCollectionView, numberOfItemsIn section: Int) -> Int
    
    func pageCollectionView(_ pageCollectionView: HFPageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

class HFPageCollectionView: UIView {
    var  layout : HFPageCollectionLayout
    
    weak var dataSource : HFPageCollectionViewDataSource?
    
    fileprivate var currentSection : Int = 0
    fileprivate var nextSection : Int = 0
    fileprivate var startOffset : CGFloat = 0
    fileprivate var titles : [String]
    fileprivate var style : HFPageStyle
    fileprivate var collectionView : UICollectionView!
    fileprivate var pageControl : UIPageControl!
    fileprivate var titleView : HFTitleView!
    
    init(frame: CGRect, titles: [String], isTop: Bool, style: HFPageStyle, layout: HFPageCollectionLayout) {
        self.titles = titles
        self.style = style
        self.layout = layout
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   

}

// MARK:- 设置UI
extension HFPageCollectionView {
    func setupUI() {
        // titleView 
        let titleY : CGFloat = style.isTitleInTop ? 0 : bounds.height - style.titleHeight
        let titleViewFrame = CGRect(x: 0, y: titleY, width: bounds.width, height: style.titleHeight)
        let titleView : HFTitleView = HFTitleView(frame: titleViewFrame, titles: titles, style: style)
        titleView.backgroundColor = UIColor.randomColor()
        titleView.delegate = self
        addSubview(titleView)
        self.titleView = titleView
        
        // collectionView
        let collY = style.isTitleInTop ? style.titleHeight : 0
        let collH = bounds.height - style.titleHeight - style.pageControlHeight
        let collFrame = CGRect(x: 0, y: collY, width: bounds.width, height: collH)
        let collectionView : UICollectionView = UICollectionView(frame: collFrame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.randomColor()
        collectionView.isPagingEnabled = true
        self.collectionView = collectionView
        addSubview(collectionView)
        
        // pageControl
        let pageControl = UIPageControl()
        pageControl.center.x = bounds.width * 0.5
        pageControl.bounds = CGRect(x: 0, y: 0, width: bounds.width, height: style.pageControlHeight)
        pageControl.frame.origin.y = collectionView.frame.maxY
        pageControl.backgroundColor = UIColor.randomColor()
        pageControl.numberOfPages = 3
        addSubview(pageControl)
        self.pageControl = pageControl
        
    }
}

// MARK:- collectionView DataSource
extension HFPageCollectionView : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSectionsInPageCollectionView(self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let items = dataSource?.pageCollectionView(self, numberOfItemsIn: section) else {
            return 0
        }
        if section == 0 {
            pageControl.numberOfPages = (items - 1) / (layout.cols * layout.rows) + 1
        }
        return items
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dataSource?.pageCollectionView(self, collectionView, cellForItemAt: indexPath) ?? UICollectionViewCell()
        
        return cell
        
    }
}

// MARK:- collectionView delegate
extension HFPageCollectionView : UICollectionViewDelegate{
    
    // 获取起始偏移量
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let point = CGPoint(x: layout.sectionInset.left + 1 + collectionView.contentOffset.x, y: layout.sectionInset.top + 1)
        let indexPath = collectionView.indexPathForItem(at: point)!
        currentSection = indexPath.section
        print(currentSection)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndScroll()
        }
    }
    
    private func scrollViewDidEndScroll() {
        let point = CGPoint(x: layout.sectionInset.left + 1 + collectionView.contentOffset.x, y: layout.sectionInset.top + 1)
        let indexPath = collectionView.indexPathForItem(at: point)!
        let pageInSeciton = indexPath.item / (layout.cols * layout.rows)
        let items = collectionView.numberOfItems(inSection: indexPath.section)
        nextSection = indexPath.section
        
        
        if currentSection != nextSection {
            pageControl.numberOfPages = (items - 1) / (layout.cols * layout.rows) + 1
            
            titleView.setCurrentTitleIndex(index: nextSection)
        }
        pageControl.currentPage = pageInSeciton
       
    }
    
}

// MARK:- 外部方法
extension HFPageCollectionView {
    func registerCell(_ cell : AnyClass?, reusableIdentify: String){
        collectionView.register(cell, forCellWithReuseIdentifier: reusableIdentify)
    }
    
    func registerNib(_ Nib: UINib?, reusableIdentify: String){
        collectionView.register(Nib, forCellWithReuseIdentifier: reusableIdentify)
    }
    
    func reloadData(){
        collectionView.reloadData()
    }
}

// MARK:- HFTitleViewDelegate
extension HFPageCollectionView: HFTitleViewDelegate{
    func titleView(_ titleView: HFTitleView, selectIndex: Int) {
        pageControl.currentPage = 0
        
        
        let indexPath = IndexPath(item: 0, section: selectIndex)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
        let items = collectionView.numberOfItems(inSection: selectIndex)
        let sectionPages  = (items - 1) / (layout.cols * layout.rows) + 1
        
        pageControl.numberOfPages = sectionPages
        
        if (selectIndex == collectionView.numberOfSections - 1) && sectionPages == 1{
            return
        }
        collectionView.contentOffset.x -= layout.sectionInset.left
    }
}



