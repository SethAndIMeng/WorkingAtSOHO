//
//  LocationDetailViewController.swift
//  WoringAtSOHO
//
//  Created by Seth Jin on 16/7/15.
//  Copyright © 2016年 SOHO3Q. All rights reserved.
//

import UIKit
import Auk

class LocationDetailViewController: UIViewController {
    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var projectInfo: ModelProjectItem? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        scrollView.contentInset = UIEdgeInsetsZero
//        contentViewHeight.constant = 300

        // Do any additional setup after loading the view.
        if let projectInfo = projectInfo, projectSmallImgs = projectInfo.projectSmallImgs {
            imageScrollView.auk.settings.contentMode = .ScaleAspectFill
            for img in projectSmallImgs {
                if let imgPath = img.imgPath {
                    imageScrollView.auk.show(url: ImageBaseUrl + imgPath)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
