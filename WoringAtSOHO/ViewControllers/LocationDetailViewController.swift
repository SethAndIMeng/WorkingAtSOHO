//
//  LocationDetailViewController.swift
//  WoringAtSOHO
//
//  Created by Seth Jin on 16/7/15.
//  Copyright © 2016年 SOHO3Q. All rights reserved.
//

import UIKit
import CVCalendar

let CGFloatEpsilon = CGFloat(0.001)

class LocationDetailViewController: UIViewController, UIScrollViewDelegate, CVCalendarViewDelegate, CVCalendarMenuViewDelegate
{
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var customImageScrollView: UIScrollView!
    @IBOutlet weak var customImagePageControl: UIPageControl!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var projectDescription: UILabel!
    
    @IBOutlet weak var yearMonthLabel: UILabel!
    @IBOutlet weak var calendarMenuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    
    var pageNumber = 0
    
    var projectInfo: ModelProjectItem? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.contentInset = UIEdgeInsetsZero
        priceLabel.layer.cornerRadius = 5
        priceLabel.layer.masksToBounds = true
        if let title = projectInfo?.projectName {
            self.title = title
        }
        locationLabel.text = projectInfo?.projectLocation
        projectDescription.text = projectInfo?.projectContent
        
        if let projectInfo = projectInfo, projectSmallImgs = projectInfo.projectSmallImgs {
            pageNumber = projectSmallImgs.count
            
            var prevView: UIView? = nil
            customImagePageControl.numberOfPages = pageNumber
            for i in 0...(pageNumber + 1) {
                let iv = UIImageView()
                let index = (i + pageNumber - 1) % pageNumber
                iv.translatesAutoresizingMaskIntoConstraints = false
                //            iv.image = UIImage(named: picName)
                if let imgPath = projectSmallImgs[index].imgPath {
                    iv.backgroundColor = UIColor.yellowColor()
                    iv.kf_setImageWithURL(NSURL(string:ImageBaseUrl + imgPath))
                }
                
                iv.contentMode = .ScaleAspectFill
                iv.clipsToBounds = true
                iv.userInteractionEnabled = true
                customImageScrollView.addSubview(iv)
                
                if nil != prevView {
                    customImageScrollView.addConstraint(NSLayoutConstraint(item: iv, attribute: .Leading, relatedBy: .Equal, toItem: prevView, attribute: .Trailing, multiplier: 1, constant: 0))
                }
                customImageScrollView.addConstraint(NSLayoutConstraint(item: iv, attribute: .CenterY, relatedBy: .Equal, toItem: customImageScrollView, attribute: .CenterY, multiplier: 1, constant: 0))
                customImageScrollView.addConstraint(NSLayoutConstraint(item: iv, attribute: .Width, relatedBy: .Equal, toItem: customImageScrollView, attribute: .Width, multiplier: 1, constant: 0))
                customImageScrollView.addConstraint(NSLayoutConstraint(item: iv, attribute: .Height, relatedBy: .Equal, toItem: customImageScrollView, attribute: .Height, multiplier: 1, constant: 0))
                
                if 0 == i {
                    customImageScrollView.addConstraint(NSLayoutConstraint(item: iv, attribute: .Leading, relatedBy: .Equal, toItem: iv.superview, attribute: .Leading, multiplier: 1, constant: 0))
                    customImageScrollView.addConstraint(NSLayoutConstraint(item: iv, attribute: .Top, relatedBy: .Equal, toItem: iv.superview, attribute: .Top, multiplier: 1, constant: 0))
                    customImageScrollView.addConstraint(NSLayoutConstraint(item: iv, attribute: .Bottom, relatedBy: .Equal, toItem: iv.superview, attribute: .Bottom, multiplier: 1, constant: 0))
                }
                if pageNumber + 1 == i {
                    customImageScrollView.addConstraint(NSLayoutConstraint(item: iv, attribute: .Trailing, relatedBy: .Equal, toItem: iv.superview, attribute: .Trailing, multiplier: 1, constant: 0))
                }
                
                prevView = iv
            }
            yearMonthLabel.text = Date(date: NSDate()).globalDescription
            calendarMenuView.backgroundColor = UIColor.clearColor()
            calendarView.backgroundColor = UIColor.clearColor()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarMenuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == customImageScrollView {
            if pageNumber > 0 {
                let width = scrollView.bounds.width
                let offsetX = scrollView.contentOffset.x
                
                if fabs(offsetX - 0) < CGFloatEpsilon { //最左边一个是(index=0)最后一个
                    scrollView.contentOffset = CGPointMake(width * CGFloat(pageNumber), 0)
                }
                if fabs(offsetX - width * CGFloat(pageNumber + 1)) < CGFloatEpsilon { //最右边一个(index=pageNumber+1)是第一个
                    scrollView.contentOffset = CGPointMake(width, 0)
                }
                
                // 此处不能用 offsetX 代替 scrollView.contentOffset.x，这个值在变化
                let currentPage = scrollView.contentOffset.x / width - 0.5
                customImagePageControl.currentPage = Int(currentPage)
            }
        } else if scrollView == self.scrollView {
            
        }
    }
    
    //CVCalendarViewDelegate
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    func firstWeekday() -> Weekday {
        return .Monday
    }
    func presentedDateUpdated(date: Date) {
        yearMonthLabel.text = date.globalDescription
    }
    
    func shouldAutoSelectDayOnWeekChange() -> Bool {
        return false
    }
    
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return false
    }
    
    func didSelectDayView(dayView: DayView, animationDidFinish: Bool) {
        let date = dayView.date
        NSLog("%@-%@", date, animationDidFinish)
    }
    
    deinit {
        customImageScrollView.delegate = nil
        scrollView.delegate = nil
    }

}
