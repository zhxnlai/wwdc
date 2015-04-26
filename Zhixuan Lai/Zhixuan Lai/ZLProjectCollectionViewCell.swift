//
//  ZLProjectCollectionViewCell.swift
//  Zhixuan Lai
//
//  Created by Zhixuan Lai on 4/14/15.
//  Copyright (c) 2015 Zhixuan Lai. All rights reserved.
//

import UIKit

class ZLProjectCollectionViewCell: UICollectionViewCell {
    static let Height = CGFloat(150)
    
    var project: Project? {
        didSet {
            titleLabel.text = project?.title
            
            titleLabel.sizeToFit()
            layoutSubviews()
        }
    }
    
    var titleLabel = UILabel(frame: CGRectZero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(titleLabel)
        
        contentView.backgroundColor = UIColor.lightGrayColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
