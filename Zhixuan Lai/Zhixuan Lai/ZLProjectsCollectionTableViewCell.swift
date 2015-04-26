//
//  UIProjectsCollectionTableViewCell.swift
//  Zhixuan Lai
//
//  Created by Zhixuan Lai on 4/14/15.
//  Copyright (c) 2015 Zhixuan Lai. All rights reserved.
//

import UIKit

class ZLProjectsCollectionTableViewCell: UITableViewCell {
    var collectionView: UICollectionView
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        var layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: ZLProjectCollectionViewCell.Height, height: ZLProjectCollectionViewCell.Height)
        layout.scrollDirection = .Horizontal
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.registerClass(ZLProjectCollectionViewCell.self, forCellWithReuseIdentifier: "identifier")
        collectionView.backgroundColor = UIColor.whiteColor()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        contentView.addSubview(collectionView)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: protocol<UICollectionViewDataSource, UICollectionViewDelegate>, index: Int) {
        collectionView.dataSource = dataSourceDelegate
        collectionView.delegate = dataSourceDelegate
        collectionView.tag = index
        
        collectionView.reloadData()
    }
}
