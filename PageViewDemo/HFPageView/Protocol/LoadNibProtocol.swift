//
//  LoadNibProtocol.swift
//  LiveAPP
//
//  Created by taoyi-two on 2017/3/29.
//  Copyright © 2017年 taoyitech. All rights reserved.
//

import UIKit

protocol LoadNibProtocol {
    
}

extension LoadNibProtocol where Self : UIView {
    static func loadFromNib(_ nibName: String? = nil) -> Self {
        let nib = nibName ?? "\(self)"
        return Bundle.main.loadNibNamed(nib, owner: nil
            , options: nil)?.first as! Self
    }
}
