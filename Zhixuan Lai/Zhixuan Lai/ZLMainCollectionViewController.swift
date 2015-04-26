//
//  ZLMainCollectionViewController.swift
//  Zhixuan Lai
//
//  Created by Zhixuan Lai on 4/25/15.
//  Copyright (c) 2015 Zhixuan Lai. All rights reserved.
//

import UIKit
import SwiftyJSON
import TTTAttributedLabel
import ReactiveUI
import SVWebViewController

class ZLMainCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, TTTAttributedLabelDelegate {
    private var images = [String: UIImage]()
    private let cellIdentifier = "cell", headerIdentifier = "header", footerIdentifier = "footer"
    
    private var sectionHeaderAttributedStrings: [NSAttributedString]?
    var markdown = Markdown()
    var webViewController = SVWebViewController(address: "http://zhxnlai.github.io")

    var config: JSON? {
        didSet {
            if let sections = config?["sections"].array {
                let mds = sections.map({json in json["md"].stringValue})
                sectionHeaderAttributedStrings = mds.map({md in
                    let style = join("", [  "<style>",
                                            "    * {font-family: 'HelveticaNeue';}",
"h1,h2,h3,h4,h5,h6{\nfont-weight:normal;\nline-height:1em;\n}\nh4,h5,h6{ font-weight: bold; }\nh1{ font-size:2.5em; }\nh2{ font-size:2em; }\nh3{ font-size:1.5em; }\nh4{ font-size:1.2em; }\nh5{ font-size:1em; }\nh6{ font-size:0.9em; }\n",
                        "a{ color: #0645ad; text-decoration:none;}",
//                        "p { margin:1em 0;}",
                                            "</style>"])
                    let outputHtml: String = style+"<div style=\"font-size: 15px; line-height:1.5em;\">"+self.markdown.transform(md)+"</div>"
                    return NSAttributedString(data: outputHtml.dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil, error: nil)!
                })
                collectionView?.reloadData()
            }
        }
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        
        var imgPaths = (NSBundle.mainBundle().pathsForResourcesOfType("png", inDirectory: "") as! Array<String>) +
                        (NSBundle.mainBundle().pathsForResourcesOfType("jpg", inDirectory: "") as! Array<String>)
        for path in imgPaths {
            if let image = UIImage(contentsOfFile: path) {
                let fileName = path.lastPathComponent.stringByDeletingPathExtension
                images[fileName] = image
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        if let configPath = NSBundle.mainBundle().pathForResource("config", ofType: "json"), configData = NSData(contentsOfFile: configPath) {
            config = JSON(data: configData)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        webViewController.loadURL(NSURL(string: "http://zhxnlai.github.io"))

        title = "Zhixuan Lai"
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self , action: Selector("refreshButtonAction:"))
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .Plain, target: self, action: Selector("settingsButtonAction:"))
        
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.registerClass(ZLCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: cellIdentifier)
        collectionView?.registerClass(ZLSectionHeaderView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView?.registerClass(ZLCollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerIdentifier)
    }

    // MARK: - UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if let numSections = getSections()?.count {
            return numSections
        }
        return 0
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let numProjects = getSection(section)?["projects"].array?.count {
            return numProjects
        }
        return 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! ZLCollectionViewCell
//        var imageView = UIImageView(image: imageForIndexPath(indexPath))
//        imageView.contentMode = .ScaleAspectFill
//        cell.backgroundView = imageView
        if let project = projectForIndexPath(indexPath), titleString = project["title"].string {
            cell.title = titleString
        }
        cell.image = imageForIndexPath(indexPath)
//        cell.clipsToBounds = true
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch (kind) {
        case UICollectionElementKindSectionHeader:
            var view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier, forIndexPath: indexPath) as! ZLSectionHeaderView
            if let attributedString = attributedStringForSection(indexPath.section) {
                view.attributedText = attributedString
            }
            view.label.delegate = self
            return view
        case UICollectionElementKindSectionFooter:
            var view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: footerIdentifier, forIndexPath: indexPath) as! ZLCollectionReusableView
            return view
        default:
            break
        }
        return ZLCollectionReusableView(frame: CGRectZero)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var size = imageForIndexPath(indexPath).size
        return size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let attributedString = attributedStringForSection(section) {
            var size = TTTAttributedLabel.sizeThatFitsAttributedString(attributedString, withConstraints: ZLSectionHeaderView.labelMaxSize, limitedToNumberOfLines: 0)
            return size
        }
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeZero
    }
    
    // MARK: - UICollectionViewDelegate
    

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        if let project = projectForIndexPath(indexPath), urlString = project["url"].string {
            webViewController.loadURL(NSURL(string: urlString))
            navigationController?.pushViewController(webViewController, animated: true)
        }
    }
    
    // MARK: - TTTAttributedLabelDelegate
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        let alertController = UIAlertController(title: url.absoluteString, message: "Open Link in Safari", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in}
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in UIApplication.sharedApplication().openURL(url)}
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - ()
    func getSections() -> [JSON]? {
        if let sections = config?["sections"].array {
            return sections
        }
        return nil
    }

    func getSection(section:Int) -> JSON? {
        if let project = getSections()?[section] {
            return project
        }
        return nil
    }
    
    func imageForIndexPath(indexPath:NSIndexPath) -> UIImage {
        if let key = projectForIndexPath(indexPath)?["img"].string, img = images[key] {
            return img
        }
        return UIImage(named: "placeholder")!
    }

    func projectForIndexPath(indexPath:NSIndexPath) -> JSON? {
        if let project = config?["sections"].array?[indexPath.section]["projects"].array?[indexPath.item] {
            return project
        }
        return nil
    }
    
    func attributedStringForSection(section:Int) -> NSAttributedString? {
        if let s = sectionHeaderAttributedStrings?[section] {
            return s
        }
        return nil
    }

    

}
