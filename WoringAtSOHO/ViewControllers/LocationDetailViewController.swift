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

let TagAlertView1 = 1
let TagAlertView2 = 2

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
    @IBOutlet weak var reservationButtonMask: UIButton!
    
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
//                    iv.backgroundColor = UIColor.yellowColor()
                    iv.backgroundColor = UIColor.lightGrayColor()
//                    iv.kf_setImageWithURL(NSURL(string:ImageBaseUrl + imgPath))
                    iv.kf_setImageWithURL(NSURL(string:ImageBaseUrl + imgPath), placeholderImage: sharedPlaceHolderImage, optionsInfo: nil, progressBlock: nil, completionHandler: nil)
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
    
    func setReservationButtonEnabled(enabled: Bool) {
        if enabled {
            reservationButton.enabled = true
            reservationButton.backgroundColor = UIColor.orangeColor()
            reservationButtonMask.hidden = true
        } else {
            reservationButton.enabled = false
            reservationButton.backgroundColor = UIColor.darkGrayColor()
            reservationButtonMask.hidden = false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        reservationButton.setTitle("请选择您的入驻办公日期", forState: .Normal)
        setReservationButtonEnabled(false)
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
    
    var currentProjectAvailableRequest: Request? = nil
    func didSelectDayView(dayView: DayView, animationDidFinish: Bool) {
        
        if let cvDate = dayView.date, date = cvDate.convertedDate() {
//            NSLog("%@-%@", date, animationDidFinish)
            
            if let projectInfo = projectInfo, projectId = projectInfo.projectId {
                
                let dateString = date.S3_dateString01
                
                SOHO3Q_USER_RESERVATION_DATE = nil
                SOHO3Q_USER_RESERVATION_PROJECT = nil
                if let currentProjectAvailableRequest = currentProjectAvailableRequest {
                    currentProjectAvailableRequest.cancel()
                }
                
                var isAvailableDay = false
                let today = NSDate()
                if today.compare(date) == .OrderedAscending {
                    isAvailableDay = true
                } else {
                    let c0 = NSCalendar.currentCalendar().components([.Era, .Year, .Month, .Day], fromDate: today)
                    let c1 = NSCalendar.currentCalendar().components([.Era, .Year, .Month, .Day], fromDate: date)
                    if c0.era == c1.era && c0.year == c1.year && c0.month == c1.month && c0.day == c1.day {
                        isAvailableDay = true
                    }
                }
                
                if isAvailableDay {
                    reservationButton.setTitle("正在检索\(dateString)的工位", forState: .Normal)
                    setReservationButtonEnabled(false)
                    
                    currentProjectAvailableRequest =
                        Alamofire.request(.GET, AjaxGetProjectAvailableAPIUrl, parameters: ["projectId": projectId, "currentDate": dateString])
                            .validate()
                            .responseObject { [weak self] (response: Response<ModelProjectAvailable, NSError>) in
                                guard let strongSelf = self else {
                                    return
                                }
                                var succeed = false
                                switch response.result {
                                case .Success:
                                    if let result = response.result.value?.result {
                                        for item in result {
                                            if let projectId = item.projectId, currentProjectId = projectInfo.projectId {
                                                if projectId == currentProjectId {
                                                    if let remains = item.remains {
                                                        if remains > 0 {
                                                            succeed = true
                                                            strongSelf.reservationButton.setTitle("立即预约\(dateString)的工位 (剩余: \(remains))", forState: .Normal)
                                                            strongSelf.setReservationButtonEnabled(true)
                                                            SOHO3Q_USER_RESERVATION_DATE = date
                                                            SOHO3Q_USER_RESERVATION_PROJECT = projectInfo
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    break
                                    
                                case .Failure:
                                    break
                                }
                                if !succeed {
                                    strongSelf.reservationButton.setTitle("无法预约\(dateString)的工位 (剩余: 0)", forState: .Normal)
                                    strongSelf.setReservationButtonEnabled(false)
                                }
                                strongSelf.currentProjectAvailableRequest = nil
                                
                    }
                } else {
                    reservationButton.setTitle("请选择今天或未来的日期", forState: .Normal)
                    setReservationButtonEnabled(false)
                }
                
            }
        }
        
    }
    
    @IBAction func reservationButtonPressed(sender: AnyObject) {
        
        SOHO3Q_USER_API.loginIfNeeded(self.navigationController) { [weak self] succeed in
            self?.loginSucceedProcedure(true)
        }
    }
    
    @IBAction func maskButtonPressed(sender: AnyObject) {
        var offsetY = yearMonthLabel.frame.origin.y
        let screenSize = UIScreen.mainScreen().bounds.size
        let contentSize = scrollView.contentSize
        if contentSize.height > screenSize.height {
            //必须contentSize比屏幕大才有意义
            if offsetY + screenSize.height > contentSize.height {
                //日历高度比屏幕高度小
                offsetY = contentSize.height - screenSize.height
            }
            scrollView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
        }
    }
    
    @IBAction func locationButtonPressed(sender: AnyObject) {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let mapViewVC = sb.instantiateViewControllerWithIdentifier("MapViewController") as? MapViewController {
            mapViewVC.projectInfo = projectInfo
            self.navigationController?.pushViewController(mapViewVC, animated: true)
        }
    }
    
    func loginSucceedProcedure(succeed: Bool) {
        
        if succeed {
            let sid = SOHO3Q_COOKIE_SID
            let token = SOHO3Q_COOKIE_TOKEN
            
            PKHUD.sharedHUD.contentView = PKHUDProgressView()
            PKHUD.sharedHUD.show()
            
            SOHO3Q_USER_API.getAvailableStationCount({ availableCount in
                if availableCount > 0 {
                    //直接预约工位
                    PKHUD.sharedHUD.hide(true) {[weak self] _ in
                        let alertView = UIAlertView(title: "账户有余额", message: "您的账户中还有\(availableCount)张工位预约券可消费", delegate: self, cancelButtonTitle: "取消预约")
                        alertView.tag = TagAlertView1
                        self?.alertView = alertView
                        alertView.addButtonWithTitle("立刻使用")
                        alertView.show()
                    }
                } else {
                    //先创建订单，让用户支付支付买券再预约
                    ProxyCreateOrderProcedure(sid, token: token) { [weak self] succeed, result in
                        guard let strongSelf = self else {
                            return
                        }
                        if succeed {
                            PKHUD.sharedHUD.hide(true, completion: { _ in
                                let sb = UIStoryboard(name: "Main", bundle: nil)
                                if let paymentVC = sb.instantiateViewControllerWithIdentifier("PaymentViewController") as? PaymentViewController {
                                    paymentVC.couponOrder = result
                                    paymentVC.paymentDoneCallback = { [weak self] succeed in
                                        self?.paymentDoneProcedure(succeed)
                                    }
                                    strongSelf.navigationController?.pushViewController(paymentVC, animated: true)
                                }
                            })
                        } else {
                            PKHUD.sharedHUD.hide(false)
                        }
                    }
                }
            })
        } else {
            UIAlertView(title: "登录失败", message: "请尝试重新登录", delegate: nil, cancelButtonTitle: "确定").show()
        }
    }
    
    var alertView: UIAlertView? = nil
    func paymentDoneProcedure(succeed: Bool) {
        if succeed {
            if let project = SOHO3Q_USER_RESERVATION_PROJECT, date = SOHO3Q_USER_RESERVATION_DATE {
                
                PKHUD.sharedHUD.contentView = PKHUDProgressView()
                PKHUD.sharedHUD.show()
                
                SOHO3Q_USER_API
                    .confirmStationReservation(project, reservationDate: date) { succeed, result in
                        PKHUD.sharedHUD.hide(true, completion: { [weak self] _ in
                            if succeed {
                                var projectName = "SOHO"
                                if let name = project.projectName {
                                    projectName = name
                                }
                                let alertView = UIAlertView(title: "预约成功", message: "已成功预约了\(date.S3_dateString01)在\(projectName)工位", delegate: self, cancelButtonTitle: "关闭")
                                alertView.tag = TagAlertView2
                                self?.alertView = alertView
                                alertView.addButtonWithTitle("查看我的预约")
                                alertView.show()
                            } else {
                                UIAlertView(title: "预约失败", message: "当前工位已经预约光了，请您预约其它时间地点的工位", delegate: self, cancelButtonTitle: "确定").show()
                            }
                        })
                }
            }

        } else {
            UIAlertView(title: "支付失败", message: "请重新预约", delegate: nil, cancelButtonTitle: "确定").show()
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch alertView.tag {
        case TagAlertView1:
            if buttonIndex == 1 {
                self.paymentDoneProcedure(true)
            }
            break
        case TagAlertView2:
            if buttonIndex == 1 {
                SOHO3Q_USER_API.loginIfNeeded(self.navigationController) { [weak self] succeed in
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    if let reservationListVC = sb.instantiateViewControllerWithIdentifier("MyReservationListViewController") as? MyReservationListViewController {
                        self?.navigationController?.pushViewController(reservationListVC, animated: true)
                    }
                }
            }
            break
        default:
            break
        }
    }
    
    deinit {
        customImageScrollView.delegate = nil
        scrollView.delegate = nil
        alertView?.delegate = nil
    }

}
