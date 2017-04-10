//
//  ReusableProtocol.swift
//  LiveAPP
//
//  Created by taoyi-two on 2017/3/29.
//  Copyright © 2017年 taoyitech. All rights reserved.
//

import UIKit

protocol ReusableProtocol {
    static var reusableIdentify : String { get }
    static var nib : UINib? { get }
}

extension ReusableProtocol {
    static var reusableIdentify : String  {
        return "\(self)"
    }
    
    static var nib : UINib? {
        return nil
    }
}

extension UITableView {
    func registerCell<T: UITableViewCell>(_ cell: T.Type) where T: ReusableProtocol{
        if let nib = T.nib {
            register(nib, forCellReuseIdentifier: T.reusableIdentify)
        } else {
            register(cell, forCellReuseIdentifier: T.reusableIdentify)
        }
    }
    
    func dequeueReusableCell<T: ReusableProtocol>(indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.reusableIdentify, for: indexPath) as! T
    }
}

extension UICollectionView {
    func registerCell<T: UICollectionView>(_ cell: T.Type) where T: ReusableProtocol{
        if let nib = T.nib {
            register(nib, forCellWithReuseIdentifier: T.reusableIdentify)
        } else {
            register(cell, forCellWithReuseIdentifier: T.reusableIdentify)
        }
    }
    
    func dequeueReusableCell<T: ReusableProtocol>(indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.reusableIdentify, for: indexPath) as! T
    }
}
