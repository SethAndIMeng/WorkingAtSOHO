//
//  LocationListTableViewController.swift
//  WoringAtSOHO
//
//  Created by Seth Jin on 16/7/14.
//  Copyright © 2016年 SOHO3Q. All rights reserved.
//

import UIKit

import Alamofire
import AlamofireObjectMapper

class LocationListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var customImageView: UIImageView!
    
    @IBOutlet weak var labelContainer1: UIView!
    @IBOutlet weak var labelContainer2: UIView!
    var imageAspectConstraint: NSLayoutConstraint?  = nil
}

class LocationListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //0:北京 1:上海
    var projectList: [[ModelProjectItem]] = [[ModelProjectItem](), [ModelProjectItem]()]
    //当前选择的是哪个
    var selectedList = 0

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.title = "SOHO每日办公"
        
        tableView.estimatedRowHeight = 200; // 设置UITableViewCell每行大概多高
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        Alamofire.request(.GET, "http://soho3q.sohochina.com/salesvc/ajax/booking/getprojectlist", parameters: nil)
            .validate()
            .responseObject { [weak self] (response: Response<ModelProjectList, NSError>) in
                switch response.result {
                case .Success:
                    guard let strongSelf = self else {
                        return
                    }
                    if let projectList = response.result.value?.result {
                        for project in projectList {
                            if let cityName = project.cityName {
                                switch cityName {
                                case "北京":
                                    strongSelf.projectList[0].append(project)
                                case "上海":
                                    strongSelf.projectList[1].append(project)
                                default:
                                    break;
                                }
                            }
                        }
                        strongSelf.tableView.reloadData()
                    }
                    break
                    
                case .Failure:
                    break
                }
                
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationListTableViewCell", forIndexPath: indexPath) as! LocationListTableViewCell

        // Configure the cell...
        let image = UIImage(named: "DefaultSOHOImage")
        if let image = image {
            let aspect = image.size.width / image.size.height
            if let imageAspectConstraint = cell.imageAspectConstraint {
                cell.customImageView.removeConstraint(imageAspectConstraint)
            }
            cell.customImageView.image = image;
            let imageAspectConstraint = NSLayoutConstraint(item: cell.customImageView, attribute:  NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: cell.customImageView, attribute: NSLayoutAttribute.Height, multiplier: aspect, constant: 0.0)
            cell.customImageView.addConstraint(imageAspectConstraint)
            cell.imageAspectConstraint = imageAspectConstraint
        }
        cell.labelContainer1.layer.cornerRadius = 5;
        cell.labelContainer1.layer.masksToBounds = true;
        cell.labelContainer2.layer.cornerRadius = 5;
        cell.labelContainer2.layer.masksToBounds = true;

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
