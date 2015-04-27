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
            titleLabel.sizeToFit()
            layoutSubviews()
        }
    }
    var image: UIImage? {
        didSet {
            if let image = image {
                imageView.image = image
            }
        }
    }
    var darkTitle = false {
        didSet {
            titleLabel.textColor = darkTitle ? UIColor(white: 0, alpha: 0.85) : UIColor(white: 1, alpha: 0.85)
            titleLabel.shadowColor = darkTitle ? UIColor(white: 1, alpha: 0.85) : UIColor(white: 0, alpha: 0.85)
        }
    }
    
    private var imageView = UIImageView()
    private var titleLabel = UILabel()
    
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
        contentView.backgroundColor = UIColor(white: 0.918, alpha: 1)
        titleLabel.textColor = UIColor(white: 1, alpha: 0.85)
        titleLabel.shadowColor = UIColor(white: 0, alpha: 0.85)
        titleLabel.shadowOffset = CGSize(width: 0.5, height: 1)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
        let titleInset = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
        var frame = CGRect(x: imageView.frame.origin.x, y: imageView.frame.origin.y, width: imageView.frame.width, height: titleLabel.frame.height)
        titleLabel.frame = UIEdgeInsetsInsetRect(frame, titleInset)
    }

    
}
