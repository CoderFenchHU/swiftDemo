//
//  HFContentView.swift
//  LiveAPP
//
//  Created by taoyi-two on 2017/3/16.
//  Copyright © 2017年 taoyitech. All rights reserved.
//

import UIKit


protocol HFContentViewDelegate : class {
    func contentView(_ contentView : HFContentView, didEndScroll inIndex : Int)
    func contentView(_ contentView : HFContentView, sourceIndex : Int, targetIndex : Int, progress : CGFloat)
}

// MARK:- Content View
class HFContentView: UIView{

    weak var delegate : HFContentViewDelegate?
    
    fileprivate var isForbidDelegate : Bool = false
    fileprivate var startOffset : CGFloat = 0
    fileprivate var childVcs:[UIViewController]
    fileprivate var parentVc : UIViewController
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView : UICollectionView = UICollectionView(frame:self.bounds , collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    init(frame: CGRect, childVcs: [UIViewController], parentVc:UIViewController) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    } 
}

// MARK:- 设置UI界面
extension HFContentView
{
    fileprivate func setupUI(){
        for childVc in childVcs {
            parentVc.addChildViewController(childVc)
            
        }
        
        addSubview(collectionView)
    }
}

// MARK:- CollectionView dataSource
extension HFContentView : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.randomColor()
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.item]
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}

// MARK:- CollectionView delegate
extension HFContentView : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    // 获取起始偏移量
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffset = scrollView.contentOffset.x
        isForbidDelegate = false
    }
    
    // 滑动处理
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        
        guard offsetX != startOffset && !isForbidDelegate else {
            return
        }
        
        var sourceIndex = 0
        var targetIndex = 0
        var progress : CGFloat = 0
        
        let collectionWidth = collectionView.bounds.width
        if offsetX > startOffset { // 左滑
            sourceIndex = Int(offsetX / collectionWidth)
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            progress = (offsetX - startOffset) / collectionWidth
            if offsetX - startOffset == collectionWidth {
                targetIndex = sourceIndex
            }
        } else { // 右滑
            targetIndex = Int(offsetX / collectionWidth)
            sourceIndex = targetIndex + 1
            progress = (startOffset - offsetX) / collectionWidth
        }
        
        
        delegate?.contentView(self, sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
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
        let index = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        delegate?.contentView(self, didEndScroll: index)
        
    }
}

// MARK:- Title View Delegate
extension HFContentView : HFTitleViewDelegate
{
    func titleView(_ titleView: HFTitleView, selectIndex: Int) {
        isForbidDelegate = true
        let indexPath = IndexPath(item: selectIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
}
