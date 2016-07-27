//
//  LocationDetailViewController.swift
//  WoringAtSOHO
//
//  Created by Seth Jin on 16/7/15.
//  Copyright © 2016年 SOHO3Q. All rights reserved.
//

import UIKit
import CVCalendar
import Alamofire
import PKHUD

let CGFloatEpsilon = CGFloat(0.001)

class LocationDetailViewController: UIViewController, UIScrollViewDelegate, CVCalendarViewDelegate, CVCalendarMenuViewDelegate
{
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceLabel2: UILabel!
    @IBOutlet weak var priceLabel3: UILabel!
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var customImageScrollView: UIScrollView!
    @IBOutlet weak var customImagePageControl: UIPageControl!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var projectDescription: UILabel!
    
    @IBOutlet weak var yearMonthLabel: UILabel!
    @IBOutlet weak var calendarMenuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    
    @IBOutlet weak var reservationButton: UIButton!
    
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
        priceLabel2.layer.cornerRadius = 5
        priceLabel2.layer.masksToBounds = true
        priceLabel3.layer.cornerRadius = 5
        priceLabel3.layer.masksToBounds = true
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
        
        ProxyAccountLogin { succeed in
//            if succeed {
//                ProxyCreateOrder(.RMB99)
//            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepareForSegue(segue, sender: sender)
    }
    
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
    
    @IBAction func reservationButtonPressed(sender: AnyObject) {
        let sid = SOHO3Q_COOKIE_SID
        let token = SOHO3Q_COOKIE_TOKEN
        if NSDate().compare(SOHO3Q_COOKIE_EXPIRE_DATE) == .OrderedAscending &&
            sid.characters.count > 0 &&
            token.characters.count > 0 {
            //当前时间 小于 过期时间
            PKHUD.sharedHUD.contentView = PKHUDProgressView()
            PKHUD.sharedHUD.show()
            
            ProxyCreateOrderProcedure(sid, token: token) { succeed, result in
                if succeed {
                    PKHUD.sharedHUD.hide(true, completion: { success in
                        UIAlertView.soho3q_showOrderAlert(result)
                        let sb = UIStoryboard(name: "Main", bundle: nil)
                        if let paymentVC = sb.instantiateViewControllerWithIdentifier("PaymentViewController") as? PaymentViewController {
                            paymentVC.couponOrder = result
                            self.navigationController?.pushViewController(paymentVC, animated: true)
                        }
                    })
                } else {
                    PKHUD.sharedHUD.hide(false)
                }
            }
        } else {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            if let loginVC = sb.instantiateViewControllerWithIdentifier("LoginViewController") as? LoginViewController {
                loginVC.locationDetailVC = self
                self.navigationController?.presentViewController(loginVC, animated: true, completion: {
                })
            }
            
        }
    }
    
    deinit {
        customImageScrollView.delegate = nil
        scrollView.delegate = nil
    }

}
