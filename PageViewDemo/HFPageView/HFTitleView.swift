//
//  HFTitleView.swift
//  LiveAPP
//
//  Created by taoyi-two on 2017/3/16.
//  Copyright © 2017年 taoyitech. All rights reserved.
//

import UIKit

// MARK:- Title View Delegate
protocol HFTitleViewDelegate : class {
    func titleView(_ titleView:HFTitleView, selectIndex:Int)
}

// MARK:- Title View
class HFTitleView: UIView {
    weak var delegate : HFTitleViewDelegate?
    
    fileprivate var titles: [String]
    fileprivate var style : HFPageStyle
    
    // lazy
    fileprivate lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        
        return scrollView
    }()
    fileprivate lazy var normalRGB : (CGFloat, CGFloat, CGFloat) = self.style.normalColor.getRGBValue()
    fileprivate lazy var selectRGB : (CGFloat, CGFloat, CGFloat) = self.style.selectColor.getRGBValue()
    fileprivate lazy var deltaRGB : (CGFloat, CGFloat, CGFloat) = {
        let deltaR = self.selectRGB.0  - self.normalRGB.0
        let deltaG = self.selectRGB.1  - self.normalRGB.1
        let deltaB = self.selectRGB.2  - self.normalRGB.2
        return (deltaR, deltaG, deltaB)
        
    }()
    fileprivate lazy var bottomLine : UIView = {
        let bottomLine : UIView = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        return bottomLine
    }()
    fileprivate var currentIndex : Int = 0
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    init(frame: CGRect, titles: [String], style: HFPageStyle) {
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        setupUI()
        
    }
    fileprivate lazy var coverView : UIView = {
        let coverView : UIView = UIView()
        coverView.backgroundColor = self.style.coverViewColor
        coverView.alpha = self.style.coverViewAlpha
        return coverView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK:- Title View 拓展
extension HFTitleView {
    fileprivate func setupUI() {
        
        setupTitleLabels()
        
        if style.isShowBottomLine {
            setupBottomLine()
        }
        
        if style.isShowCoverView {
            setupCoverView()
        }
        
        addSubview(scrollView)
    }
    
    private func setupBottomLine(){
        scrollView.addSubview(bottomLine)
        bottomLine.frame = titleLabels.first!.frame
        bottomLine.frame.size.height = style.bottomLineHeight
        bottomLine.frame.origin.y = style.titleHeight - style.bottomLineHeight
    }
    
    fileprivate func setupTitleLabels() {
        
        for (i, title) in titles.enumerated() {
            let titleLabel = UILabel()
            
            titleLabel.text = title
            titleLabel.tag = i
            titleLabel.textAlignment = .center
            titleLabel.textColor = (i == 0 ? style.selectColor : style.normalColor)
            titleLabel.font = style.titleFont
            titleLabel.isUserInteractionEnabled = true
            
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_ :)))
            titleLabel.addGestureRecognizer(tapGes)
            scrollView.addSubview(titleLabel)
            titleLabels.append(titleLabel)
        }
        
        var labelW : CGFloat = bounds.width / CGFloat(titles.count)
        let labelH : CGFloat = style.titleHeight
        var labelX : CGFloat = 0
        let labelY : CGFloat = 0
        for (i,titleLabel) in titleLabels.enumerated() {
            if style.isScrollEnable {
                let size = CGSize(width: CGFloat(MAXFLOAT), height: 0)
                labelW = (titleLabel.text! as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : style.titleFont], context: nil).width
                labelX = (i == 0) ? style.titleMargin * 0.5 : (titleLabels[i-1].frame.maxX + style.titleMargin)
            } else {
                labelX = labelW * CGFloat(i)
            }
            titleLabel.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
        }
        
        if style.isScrollEnable {
            scrollView.contentSize = CGSize(width: titleLabels.last! .frame.maxX + style.titleMargin * 0.5, height: 0)
        }
        
        if style.isNeedScale {
            titleLabels.first?.transform = CGAffineTransform(scaleX: style.maxScaleRange, y: style.maxScaleRange)
        }
    }
    
    private func setupCoverView(){
        scrollView.insertSubview(coverView, at: 0)
        guard let firstLabel = titleLabels.first else {return}
        
        let coverH = style.coverViewHeight
        let coverY = (frame.height - coverH) * 0.5
        var coverW : CGFloat = firstLabel.frame.size.width
        var coverX : CGFloat = firstLabel.frame.origin.x
        
        if style.isScrollEnable {
            coverX -= style.coverViewMargin
            coverW += style.coverViewMargin * 2
        } else {
            coverX = firstLabel.frame.origin.x + style.coverViewMargin
            coverW = firstLabel.frame.size.width - 2 * style.coverViewMargin
        }
        coverView.frame = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)
        
        coverView.layer.cornerRadius = self.style.coverViewRadius
        coverView.layer.masksToBounds = true
    }
}

// MARK:- 点击标签处理事件
extension HFTitleView{
    @objc func titleLabelClick(_ tap: UITapGestureRecognizer) {
        guard let selectLabel = tap.view as? UILabel else {
            return
        }
        
        guard selectLabel.tag != currentIndex else {
            return
        }
        
        adjustTitle(selectLabel: selectLabel)
        
        delegate?.titleView(self, selectIndex: currentIndex)
        
    }
    
    func setCurrentTitleIndex(index: Int){
        let selectLabel = titleLabels[index]
        adjustTitle(selectLabel: selectLabel)
    }
    
    fileprivate func adjustTitle(selectLabel : UILabel) {
        
        let sourceLabel = titleLabels[currentIndex]
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            sourceLabel.textColor = self.style.normalColor
            selectLabel.textColor = self.style.selectColor
        }
        
        currentIndex = selectLabel.tag
        
        adjustLabelPosition()
        
        
        if style.isNeedScale {
            UIView.animate(withDuration: 0.25, animations: {
                sourceLabel.transform = CGAffineTransform.identity
                selectLabel.transform = CGAffineTransform(scaleX: self.style.maxScaleRange, y: self.style.maxScaleRange)
            })
        }
        
        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.25, animations: {
                self.bottomLine.frame.origin.x = selectLabel.frame.origin.x
                self.bottomLine.frame.size.width = selectLabel.frame.size.width
            })
        }
        
        if style.isShowCoverView {
            UIView.animate(withDuration: 0.25, animations: {
                self.coverView.frame.origin.x = self.style.isScrollEnable ? (selectLabel.frame.origin.x - self.style.coverViewMargin) : selectLabel.frame.origin.x + self.style.coverViewMargin
                self.coverView.frame.size.width = self.style.isScrollEnable ? (selectLabel.frame.size.width + self.style.coverViewMargin * 2) : selectLabel.frame.width - 2 * self.style.coverViewMargin
            })
        }

    }
    
    fileprivate func adjustLabelPosition() {
        if !style.isScrollEnable {
            return
        }
        
        let selectLabel = titleLabels[currentIndex]
        
        var offsetX = selectLabel.center.x - scrollView.bounds.width * 0.5
        if offsetX < 0 {
            offsetX = 0
        }
        let maxOffsetX = scrollView.contentSize.width - scrollView.bounds.width
        if offsetX > maxOffsetX {
            offsetX = maxOffsetX
        }
        
        scrollView.setContentOffset(CGPoint(x: offsetX, y:0), animated: true)
    }
}

// MARK:- pageView Conteng delegate
extension HFTitleView : HFContentViewDelegate {
    func contentView(_ contentView: HFContentView, didEndScroll inIndex: Int) {
        currentIndex = inIndex;
        
        adjustLabelPosition()
        
    }
    
    func contentView(_ contentView: HFContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        sourceLabel.textColor = UIColor(r: selectRGB.0 - deltaRGB.0 * progress, g: selectRGB.1 - deltaRGB.1 * progress, b: selectRGB.2 - deltaRGB.2 * progress)
        targetLabel.textColor = UIColor(r: normalRGB.0 + deltaRGB.0 * progress, g: normalRGB.1 + deltaRGB.1 * progress, b: normalRGB.2 + deltaRGB.2 * progress)
        
        if style.isNeedScale {
            let deltaScale = style.maxScaleRange - 1.0
            sourceLabel.transform = CGAffineTransform(scaleX: style.maxScaleRange - deltaScale * progress, y: style.maxScaleRange - deltaScale * progress)
            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + deltaScale * progress, y: 1.0 + deltaScale * progress)
        }
        
        let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let deltaW = targetLabel.frame.size.width - sourceLabel.frame.size.width

        if style.isShowBottomLine {
            bottomLine.frame.size.width = titleLabels[sourceIndex].frame.size.width + deltaW * progress
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + deltaX * progress
        }
        
        if style.isShowCoverView {
            coverView.frame.origin.x = style.isScrollEnable ? (sourceLabel.frame.origin.x - style.coverViewMargin + deltaX * progress) : (sourceLabel.frame.origin.x + deltaX * progress + style.coverViewMargin)
            coverView.frame.size.width = style.isScrollEnable ? (sourceLabel.frame.width + style.coverViewMargin * 2 + deltaW * progress) : (sourceLabel.frame.width + deltaW * progress - 2 * style.coverViewMargin)
        }
    }
}


