//
//  ZLCollectionReusableView.swift
//  ZLBalancedFlowLayoutDemo
//
//  Created by Zhixuan Lai on 12/24/14.
//  Copyright (c) 2014 Zhixuan Lai. All rights reserved.
//

import UIKit

class ZLCollectionReusableView: UICollectionReusableView {
//    var headerView = ZLSectionHeaderView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setup()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        setup()
    }
    
//    func setup() {
////        backgroundColor = UIColor.lightGrayColor()
////        headerView.textColor = UIColor.blackColor()
////        headerView.textAlignment = .Center
//        addSubview(headerView)
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        headerView.frame = self.bounds
//    }
}
