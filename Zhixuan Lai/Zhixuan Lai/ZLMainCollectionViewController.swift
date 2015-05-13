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

    var config: JSON? {
        didSet {
            if let sections = config?["sections"].array {
                let mds = sections.map({json in json["md"].stringValue})
                if let styles = config?["style"].array?.map({json in json.stringValue}), open = config?["open"].string, close = config?["close"].string {
                    let style = join("", styles)
                    sectionHeaderAttributedStrings = mds.map({md in
                        let outputHtml: String = style+open+self.markdown.transform(md)+close
                        return NSAttributedString(data: outputHtml.dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil, error: nil)!
                    })
                }

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
        title = "Zhixuan"
        navigationController?.setNavigationBarHidden(true, animated: false)
        updateToolbarItems()

        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.registerClass(ZLCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: cellIdentifier)
        collectionView?.registerClass(ZLSectionHeaderView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView?.registerClass(ZLCollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerIdentifier)
        
//        let remoteJSONURL = "https://www.dropbox.com/s/fdr1sg8ubf7g9td/config.json?dl=1"
//        if let data = NSData(contentsOfURL: NSURL(string: remoteJSONURL)!) {
//            config = JSON(data: data)
//            println("updated")
//        }
    }
    
    override func viewDidAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.setToolbarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.setToolbarHidden(true, animated: animated)
    }

    // MARK: Toolbar
    var homeBarButtonItem = UIBarButtonItem(image: UIImage(named: "home-toolbar")!, style: .Plain, action: {item in})
    var gamesBarButtonItem = UIBarButtonItem(image: UIImage(named: "swords-toolbar")!, style: .Plain, action: {item in})
    var appsBarButtonItem = UIBarButtonItem(image: UIImage(named: "ipod-touch")!, style: .Plain, action: {item in})
    var codeBarButtonItem = UIBarButtonItem(image: UIImage(named: "github-toolbar")!, style: .Plain, action: {item in})
    var researchBarButtonItem = UIBarButtonItem(image: UIImage(named: "graduation-cap-toolbar")!, style: .Plain, action: {item in})
    
    var currentSectionTitle = "Welcome"
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if let indexPaths = collectionView?.indexPathsForVisibleItems() as? [NSIndexPath], let firstSection = indexPaths.first?.section, section = getSection(firstSection), title = section["title"].string {
            if currentSectionTitle != title {
                currentSectionTitle = title
                updateToolbarItems()
            }
        }
    }
    
    func updateToolbarItems() {
        
        homeBarButtonItem.addAction({item in self.scrollToSectionWithTitle("Welcome")})
        gamesBarButtonItem.addAction({item in self.scrollToSectionWithTitle("Games")})
        appsBarButtonItem.addAction({item in self.scrollToSectionWithTitle("Apps")})
        codeBarButtonItem.addAction({item in self.scrollToSectionWithTitle("Code")})
        researchBarButtonItem.addAction({item in self.scrollToSectionWithTitle("Research")})
        
        homeBarButtonItem.tintColor = currentSectionTitle == "Welcome" || currentSectionTitle == "Projects" ? view.tintColor : UIColor.grayColor()
        gamesBarButtonItem.tintColor = currentSectionTitle == "Games" ? view.tintColor : UIColor.grayColor()
        appsBarButtonItem.tintColor = currentSectionTitle == "Apps" ? view.tintColor : UIColor.grayColor()
        codeBarButtonItem.tintColor = currentSectionTitle == "Code" ? view.tintColor : UIColor.grayColor()
        researchBarButtonItem.tintColor = currentSectionTitle == "Research" ? view.tintColor : UIColor.grayColor()
        
        var fixedSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, action: {item in})
        var flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, action: {item in})
        
        var items = [fixedSpace, homeBarButtonItem, flexibleSpace, gamesBarButtonItem, flexibleSpace, appsBarButtonItem, flexibleSpace, codeBarButtonItem, flexibleSpace, researchBarButtonItem, fixedSpace]
        toolbarItems = items
    }

    func scrollToSectionWithTitle(toTitle: String) {
        if let sections = getSections() {
            for sectionIdx in (0..<sections.count) {
                let section = sections[sectionIdx]
                if let title = section["title"].string {
                    if title == toTitle {
                        var attributes = collectionView?.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: sectionIdx))
                        var rect = attributes?.frame
                        let headerSize = headerSizeForSection(sectionIdx)
                        collectionView?.setContentOffset(CGPoint(x: 0, y: rect!.origin.y-headerSize.height-30), animated: true)
                    }
                }
            }
        }
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
        if let project = projectForIndexPath(indexPath), titleString = project["title"].string {
            cell.title = titleString
            if let darkTitle = project["darkTitle"].bool {
                cell.darkTitle = darkTitle
            } else {
                cell.darkTitle = false
            }
        }
        cell.image = imageForIndexPath(indexPath)
        cell.clipsToBounds = true
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
        return headerSizeForSection(section)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 20)
    }
    
    func headerSizeForSection(section: Int) -> CGSize {
        if let attributedString = attributedStringForSection(section) {
            var size = TTTAttributedLabel.sizeThatFitsAttributedString(attributedString, withConstraints: ZLSectionHeaderView.labelMaxSize, limitedToNumberOfLines: 0)
            return size
        }
        return CGSizeZero
    }
    
    // MARK: - UICollectionViewDelegate
    var webViewControllers = [String: SVWebViewController]()

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        if let project = projectForIndexPath(indexPath), urlString = project["url"].string {
            
            var webViewController = SVWebViewController(address: urlString)
            webViewController.title = project["title"].string
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
