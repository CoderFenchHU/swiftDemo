//
//  HFWaterFallLayout.swift
//  LiveAPP
//
//  Created by taoyi-two on 2017/3/21.
//  Copyright © 2017年 taoyitech. All rights reserved.
//

import UIKit

protocol HFWaterFallDataSource : class{
    func waterFallLayout(_ layout : HFWaterFallLayout, itemIndex : Int) -> CGFloat
    
    
}

class HFWaterFallLayout: UICollectionViewFlowLayout {
    var cols : Int = 3
    
    weak var dataSource : HFWaterFallDataSource?
    fileprivate lazy var attributes : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate lazy var maxHeight : CGFloat = self.sectionInset.top + self.sectionInset.bottom
}

// MARK:- 所有cell的布局
extension HFWaterFallLayout {
    override func prepare() {
        super.prepare()
        
        // cell 布局 -> UICollectionViewLayoutAttributes
        guard let collectionView = self.collectionView else {
            return
        }
        let count = collectionView.numberOfItems(inSection: 0)
        print(count)
        let itemW = (collectionView.bounds.width - sectionInset.left - sectionInset.right - (CGFloat(cols) - 1) *  minimumInteritemSpacing) / CGFloat(cols)
        var heights : [CGFloat] = Array(repeating: sectionInset.top, count: cols)
        for i in 0..<count {
            
            let indexPath = IndexPath(item: i, section: 0)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            guard let itemH = dataSource?.waterFallLayout(self, itemIndex: i) else {
                fatalError("Error: NO item height. Please use HFWaterFallDataSource to set the item height!")
            }
            let minH = heights.min()!
            let minIndex = heights.index(of: minH)!
            let itemX = sectionInset.left + (minimumInteritemSpacing + itemW) * CGFloat(minIndex)
            let itemY = minH 
            
            attribute.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
            
            
            attributes.append(attribute)
            
            heights[minIndex] = attribute.frame.maxY + minimumLineSpacing
            
        }
        maxHeight = heights.max()!
    }
}

// MARK:- 准备好的布局
extension HFWaterFallLayout{
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
}

// MARK:- 滚动范围
extension HFWaterFallLayout {
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: maxHeight)
    }
}
