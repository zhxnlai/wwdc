//
//  ZLCollectionViewCell.swift
//  Zhixuan Lai
//
//  Created by Zhixuan Lai on 4/26/15.
//  Copyright (c) 2015 Zhixuan Lai. All rights reserved.
//

import UIKit

class ZLCollectionViewCell: UICollectionViewCell {
    var title = "" {
        didSet {
            titleLabel.text = title
        }
    }
    var image: UIImage? {
        didSet {
            if let image = image {
                imageView.image = image
            }
        }
    }
    
    var imageView = UIImageView()
    var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        //[UIColor colorWithWhite:0.918 alpha:1.000]
        // [UIColor colorWithWhite:0.114 alpha:1.000]
        contentView.backgroundColor = UIColor(white: 0.918, alpha: 1)
        titleLabel.textColor = UIColor(white: 0.114, alpha: 1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
    }

    
}
