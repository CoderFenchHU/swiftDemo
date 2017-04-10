//
//  HFPageView.swift
//  LiveAPP
//
//  Created by taoyi-two on 2017/3/16.
//  Copyright © 2017年 taoyitech. All rights reserved.
//

import UIKit

// MARK:- Page Style 结构体
struct HFPageStyle {
    
    var pageControlHeight : CGFloat = 20                            // 设置pageController高度
    var isTitleInTop : Bool = true                                  // 设置标题栏是否在顶部
    
    var titleHeight: CGFloat = 44                                   // 设置标题栏高度
    var normalColor : UIColor = UIColor(r: 255, g: 255, b: 255)     // 设置标题未选择状态颜色
    var selectColor: UIColor = UIColor(r: 255, g: 127, b: 0)        // 设置标题选中状态颜色
    var titleFont : UIFont = UIFont.systemFont(ofSize: 14)          // 设置标题字体
    var isScrollEnable : Bool = false                               // 设置标题栏是否能滑动
    var titleMargin : CGFloat = 20                                  // 设置标题间隔
    var isShowBottomLine : Bool = true                              // 设置是否显示底部滑动条
    var bottomLineColor : UIColor = UIColor.orange                  // 设置底部滑动条颜色
    var bottomLineHeight : CGFloat = 3                              // 设置底部滑动条高度
    var isNeedScale : Bool = false                                  // 设置标签条是否缩放
    var maxScaleRange : CGFloat = 1.2                               // 设置标签缩放最大比例
    var coverViewColor : UIColor = UIColor.black                    // 设置覆盖颜色
    var coverViewAlpha : CGFloat = 0.3                              // 设置覆盖透明度
    var isShowCoverView : Bool = false                              // 设置覆盖是否显示
    var coverViewHeight : CGFloat = 25.0                            // 设置覆盖高度
    var coverViewRadius : CGFloat = 12.0                            // 设置覆盖圆角
    var coverViewMargin : CGFloat = 8                               // 设置覆盖间隔
}

// MARK:- Page View
class HFPageView: UIView {
    var titles : [String]
    var style : HFPageStyle
    var childVCs : [UIViewController]
    var parentVc : UIViewController
    
    init(frame: CGRect, titles: [String], style: HFPageStyle, childVCs: [UIViewController], parentVc: UIViewController) {
        self.childVCs = childVCs
        self.titles = titles
        self.parentVc = parentVc
        self.style = style
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置UI界面
extension HFPageView
{
    fileprivate func setupUI() {
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleHeight)
        let titleView = HFTitleView(frame: titleFrame, titles: titles, style: style)
        titleView.backgroundColor = UIColor.randomColor()
        addSubview(titleView)
        
        let contentFrame = CGRect(x: 0, y: titleFrame.maxY, width: bounds.width, height: bounds.height - style.titleHeight)
        let contentView = HFContentView(frame: contentFrame, childVcs: childVCs, parentVc: parentVc)
        contentView.backgroundColor = UIColor.randomColor()
        addSubview(contentView)
        
        titleView.delegate = contentView;
        contentView.delegate = titleView;
    }
}
