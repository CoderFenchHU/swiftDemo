//
//  UIColor-Extension.swift
//  LiveAPP
//
//  Created by taoyi-two on 2017/3/16.
//  Copyright © 2017年 taoyitech. All rights reserved.
//

import UIKit

extension UIColor{
    // MARK:- 随机颜色
    class func randomColor() -> UIColor{
        let color = UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green:CGFloat(arc4random_uniform(256))/255.0, blue:CGFloat(arc4random_uniform(256))/255.0, alpha: 1)
        return color
    }
    
    // MARK:- R G B 颜色
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    // MARK:- 十六进制颜色
    convenience init?(hexString:String) {
        guard hexString.characters.count >= 6 else {
            return nil
        }
        var hexTempString = hexString.uppercased()
        if hexTempString.hasPrefix("0X") {
            hexTempString = (hexTempString as NSString).substring(from: 2)
//            hexTempString = hexTempString.substring(from: hexTempString.startIndex)
        }
        
        if hexTempString.hasPrefix("#") {
            hexTempString = (hexTempString as NSString).substring(from: 1)
        }
        
        var range = NSRange(location: 0, length: 2)
        let rHex = (hexTempString as NSString).substring(with: range)
        
        range.location = 2
        let gHex = (hexTempString as NSString).substring(with: range)
        
        range.location = 4
        let bHex = (hexTempString as NSString).substring(with: range)
        
        var  r : UInt32 = 0
        var  g : UInt32 = 0
        var  b : UInt32 = 0
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        
        self.init(r: CGFloat(r),  g : CGFloat(g), b:  CGFloat(b))
    }
}

// MARK:- 从颜色中获取RGB的指
extension UIColor {
    func getRGBValue() -> (CGFloat, CGFloat, CGFloat){
        
        var red : CGFloat = 0
        var green : CGFloat = 0
        var blue : CGFloat = 0
        guard getRed(&red, green: &green, blue: &blue, alpha: nil) else {
            fatalError("get RGB value error!")
        }
        return (red * 255, green * 255, blue * 255)
        
        
    }
    
}
