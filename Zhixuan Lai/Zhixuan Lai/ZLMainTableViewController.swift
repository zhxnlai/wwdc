//
//  ZLMainTableViewController.swift
//  Zhixuan Lai
//
//  Created by Zhixuan Lai on 4/14/15.
//  Copyright (c) 2015 Zhixuan Lai. All rights reserved.
//

import UIKit

class ZLMainTableViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Zhixuan Lai"
    }

    enum Section: Int {
        case Welcome, Bio, Projects, Footer, Count

        enum WelcomeRow: Int {
            case Welcome, Count
        }

        enum BioRow: Int {
            case Bio, Count
        }

        enum ProjectsRow: Int {
            case Research, Apps, Games, Code, Count
        }

        enum FooterRow: Int {
            case Footer, Count
        }

        static let sectionTitles = [
            Welcome: "Welcome",
            Bio: "Bio",
            Projects: "Projects",
            Footer: "Footer"]
        static let sectionCount = [
            Welcome: WelcomeRow.Count.rawValue,
            Bio: BioRow.Count.rawValue,
            Projects: ProjectsRow.Count.rawValue,
            Footer: FooterRow.Count.rawValue];

        func sectionHeaderTitle() -> String {
            if let sectionTitle = Section.sectionTitles[self] {
                return sectionTitle
            } else {
                return "Section"
            }
        }

        func sectionRowCount() -> Int {
            if let sectionCount = Section.sectionCount[self] {
                return sectionCount
            } else {
                return 0
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Section.Count.rawValue
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section(rawValue:section)!.sectionRowCount()
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section(rawValue:section)!.sectionHeaderTitle()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier = String(format: "s%li-r%li", indexPath.section, indexPath.row)
        
        var cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if cell==nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: cellIdentifier)
        }
        cell.selectionStyle = .None

        switch Section(rawValue:indexPath.section)! {
        case .Welcome:

            switch Section.WelcomeRow(rawValue: indexPath.row)! {
            case .Welcome:
                cell.textLabel!.text = "My name is Zhixuan Lai"
            default:
                cell.textLabel!.text = "Welcome"
            }
            break;
        case .Bio:
            switch Section.BioRow(rawValue: indexPath.row)! {
            case .Bio:
                cell.textLabel!.text = "Education Background"
            default:
                cell.textLabel!.text = "Bio"
            }
            break;
        case .Projects:
            var cell:ZLProjectsCollectionTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? ZLProjectsCollectionTableViewCell
            if cell==nil {
                cell = ZLProjectsCollectionTableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
            }
//            switch Section.ProjectsRow(rawValue: indexPath.row)! {
//            case .Research:
//                cell.textLabel!.text = "Research"
//            case .Apps:
//                cell.textLabel!.text = "Apps"
//            case .Games:
//                cell.textLabel!.text = "Games"
//            case .Code:
//                cell.textLabel!.text = "Code"
//            default:
//                cell.textLabel!.text = "Projects"
//            }
            return cell
        case .Footer:
            break;
        default:
            break;
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch Section(rawValue:indexPath.section)! {
        case .Projects:
            return ZLProjectCollectionViewCell.Height+1
        default:
            break
        }
        return 43.5
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if var cell = cell as? ZLProjectsCollectionTableViewCell {
            cell.setCollectionViewDataSourceDelegate(self, index: indexPath.row)
        }
    }

    var projects: [Section.ProjectsRow: [Project]] = [
        .Research:
            [Project(title: "Prolog Visualizer", url: "prolog.firebaseapp.com"),
            Project(title: "Printf Visualizer", url: "prolog.firebaseapp.com"),
            Project(title: "CamlBack", url: "prolog.firebaseapp.com")],
        .Apps:
            [Project(title: "Talkly", url: "http://zhxnlai.github.io/#/talkly?hideNav"),
            Project(title: "Murmur", url: "http://zhxnlai.github.io/#/murmur?hideNav")],
        .Games:
            [Project(title: "Intersolar", url: "http://zhxnlai.github.io/#/intersolar?hideNav"),
            Project(title: "Horoscoper", url: "http://zhxnlai.github.io/#/horoscoper?hideNav"),
            Project(title: "Spacinarium", url: "http://zhxnlai.github.io/#/spacinarium?hideNav"),
            Project(title: "Timid Turtle", url: "http://zhxnlai.github.io/#/timid-turtle?hideNav"),
            Project(title: "Trig vs Dots", url: "http://zhxnlai.github.io/#/trig-vs-dots?hideNav")],
        .Code:
            [Project(title: "ZLSwipeableView", url: "prolog.firebaseapp.com"),
            Project(title: "ZLBalancedFlowLayout", url: "prolog.firebaseapp.com")],
    ]
    
    // Mark: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projects[Section.ProjectsRow(rawValue: collectionView.tag)!]!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("identifier", forIndexPath: indexPath)as! ZLProjectCollectionViewCell
        var project = projects[Section.ProjectsRow(rawValue: collectionView.tag)!]![indexPath.item]
        cell.project = project
        return cell
    }
    
//    var webViewController = SVWebViewController(address: "http://zhxnlai.github.io")

    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! ZLProjectCollectionViewCell
        if let project = cell.project {
//            webViewController.loadURL(NSURL(string: project.url))
//            navigationController?.pushViewController(webViewController, animated: true)
        }
    }

}
