//
//  HFPageCollectionLayout.swift
//  LiveAPP
//
//  Created by taoyi-two on 2017/3/22.
//  Copyright © 2017年 taoyitech. All rights reserved.
//

import UIKit

class HFPageCollectionLayout: UICollectionViewFlowLayout {
    var cols : Int = 4              // 列数
    var rows : Int = 2              // 行数
    var colMargin : CGFloat = 10    // 列间距
    var rowMargin : CGFloat = 10    // 行间距
    
    fileprivate lazy var attributes : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate var totalWidth : CGFloat = 0
}

extension HFPageCollectionLayout {
    override func prepare() {
        
        guard let collectionView = self.collectionView else {
            return
        }
        let sections = collectionView.numberOfSections
        var previousPageNum = 0
        
        let collectionW = collectionView.bounds.width
        let collectionH = collectionView.bounds.height
        let itemW : CGFloat = (collectionW - sectionInset.left - sectionInset.right - colMargin * CGFloat(cols - 1)) / CGFloat(cols)
        let itemH : CGFloat = (collectionH - sectionInset.top - sectionInset.bottom - rowMargin * CGFloat(rows - 1)) / CGFloat(rows)
        
        for section in 0..<sections {
            let items = collectionView.numberOfItems(inSection: section)
            
            for item in 0..<items {
                let indexPath = IndexPath(item: item, section: section)
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                
                let currentPage : Int = item / (cols * rows)
                let currentIndex : Int = item % (cols * rows)
                
                let itemX : CGFloat = sectionInset.left + CGFloat(previousPageNum) * collectionW + CGFloat(currentPage) * collectionW + (itemW + colMargin) * CGFloat(currentIndex % cols)
                let itemY : CGFloat = sectionInset.top + (itemH + rowMargin) * CGFloat(currentIndex / cols)
                
                attribute.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
//                print(attribute.frame)
                attributes.append(attribute)
            }
            
            previousPageNum += (items - 1) / (cols * rows) + 1
        }
        totalWidth = CGFloat(previousPageNum) * collectionW
    }
}

extension HFPageCollectionLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return attributes
    }
}

extension HFPageCollectionLayout {
    override var collectionViewContentSize: CGSize {
        return CGSize(width: totalWidth, height: 0)
    }
}


