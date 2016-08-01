//
//  SOHOConstants.swift
//  WoringAtSOHO
//
//  Created by Seth Jin on 16/7/15.
//  Copyright © 2016年 SOHO3Q. All rights reserved.
//

import UIKit
import Alamofire
//import PKHUD

let TestEnvironment = true

var HostUrl: String {
    if TestEnvironment {
        return "soho3q.sohochina.com" //测试服务器
    } else {
        return "m.soho3q.com" //正式服务器
    }
}

let BaseUrl = "http://" + HostUrl

//代客下单账户
var ProxyUserName: String {
    if TestEnvironment {
        return "13521937005" //夏辉的测试号
    } else {
        return "15810361497" //周小洲的正式账户用户名
    }
}

var ProxyPassword: String {
    if TestEnvironment {
        return "123456" //夏辉的测试密码
    } else {
        return "xiaozhu1983" //周小洲的正式账户密码
    }
}

var ProxyCookieToken = ""
var ProxyCookieSid = ""

//图片基地址url
let ImageBaseUrl = "http://www.soho3q.com/entry/ImgStreamServlet.do?imgPath="

//网页url
let LoginUrl = BaseUrl + "/user/login.html" //登录页
let RegisterUrl = BaseUrl + "/html5/3q-registered.jsp" //注册页
let PaymentFormSubmitUrl = BaseUrl + "/html5/orderPay/orderSubmit.action" //提交支付页面的地址
let PaymentPrepareUrl = BaseUrl + "/sales/crsoConfirm.html?orderid=" //支付页的前一页地址
let PaymentSucceedUrl = BaseUrl + "/html5/z_success.jsp" //支付成功页面url
let MyReservationListUrl = BaseUrl + "/user/station.html#!/list" //我的预约列表

//Ajax API
let AjaxGetProjectListAPIUrl = BaseUrl + "/salesvc/ajax/booking/getprojectlist" //获取所有项目的接口地址
let AjaxGetProjectAvailableAPIUrl = BaseUrl + "/salesvc/ajax/flexible_station_stats/remains" //获取所有项目的剩余工位数
let GetUserInfoAPIUrl = BaseUrl + "/my/ajax/member/info" //获取用户信息api地址
let LoginAPIUrl = BaseUrl + "/my/ajax/login/submit" //登录api地址
let ProxyCreateCouponOrderAPIUrl = BaseUrl + "/salesvc/ajax/booking/create_coupon_order" //代客下单api地址
let AjaxConfirmStationReservationAPIUrl = BaseUrl + "/salesvc/ajax/reserve/confirm_station" //预约工位api地址
let AjaxGetUserCouponAPIUrl = BaseUrl + "/salesvc/ajax/coupon/my_coupons" //获取用户抵用券

var SOHO3Q_COOKIE_TOKEN = ""
var SOHO3Q_COOKIE_SID = ""
var SOHO3Q_COOKIE_USER_PHONE = "" //客户的手机号（代客下单ID）

let SOHO3Q_COOKIE_Expire_Time_Interval = NSTimeInterval(3 * 60 * 60) //3小时后过期
var SOHO3Q_COOKIE_TOKEN_SET_DATE = NSDate(timeIntervalSince1970: 0) //当前COOKIE的设置时间

class Soho3QUserInfo {
    static let keyToken = "SOHO3Q_COOKIE_TOKEN"
    static let keySid = "SOHO3Q_COOKIE_SID"
    static let keyPhone = "SOHO3Q_COOKIE_USER_PHONE"
    static let keyDate = "SOHO3Q_COOKIE_TOKEN_SET_DATE"
    
    class func loadSoho3QUserInfo() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let token = userDefaults.objectForKey(keyToken) as? String {
            SOHO3Q_COOKIE_TOKEN = token
        }
        if let sid = userDefaults.objectForKey(keySid) as? String {
            SOHO3Q_COOKIE_SID = sid
        }
        if let phone = userDefaults.objectForKey(keyPhone) as? String {
            SOHO3Q_COOKIE_USER_PHONE = phone
        }
        if let date = userDefaults.objectForKey(keyDate) as? NSDate {
            if date.compare(NSDate()) == .OrderedAscending {
                //验证时间是正确的
                SOHO3Q_COOKIE_TOKEN_SET_DATE = date
            }
        }
    }
    
    class func saveSoho3QUserInfo() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(SOHO3Q_COOKIE_TOKEN, forKey: keyToken)
        userDefaults.setValue(SOHO3Q_COOKIE_SID, forKey: keySid)
        userDefaults.setValue(SOHO3Q_COOKIE_USER_PHONE, forKey: keyPhone)
        userDefaults.setValue(SOHO3Q_COOKIE_TOKEN_SET_DATE, forKey: keyDate)
    }
    
    class func resetSoho3QUserInfo() {
        SOHO3Q_COOKIE_TOKEN = ""
        SOHO3Q_COOKIE_SID = ""
        SOHO3Q_COOKIE_USER_PHONE = ""
        SOHO3Q_COOKIE_TOKEN_SET_DATE = NSDate(timeIntervalSince1970: 0)
        saveSoho3QUserInfo()
    }
}

var SOHO3Q_USER_RESERVATION_DATE: NSDate? = nil
var SOHO3Q_USER_RESERVATION_PROJECT: ModelProjectItem? = nil

func ProxyAccountLogin(callbackHandler: ((Bool)->())?) {
    if !(ProxyCookieSid.characters.count > 0 && ProxyCookieToken.characters.count > 0) {
        Alamofire.request(.POST,
            LoginAPIUrl,
            parameters: ["account": ProxyUserName, "pwd": ProxyPassword],
            encoding: .URL,
            headers: [
                "Content-Type": "application/x-www-form-urlencoded",
                "Accept-Encoding": "gzip, deflate"
            ])
            .validate()
            .response { (request, response, data, error) in
                var succeed = false
                if let setCookies = response?.allHeaderFields["Set-Cookie"] as? String {
                    let listCookie = setCookies.componentsSeparatedByString("; ")
                    for cookie in listCookie {
                        if let range = cookie.rangeOfString("sid=", options: .CaseInsensitiveSearch) {
                            ProxyCookieSid = cookie.substringFromIndex(range.endIndex)
                        }
                        else if let range = cookie.rangeOfString("token=", options: .CaseInsensitiveSearch) {
                            ProxyCookieToken = cookie.substringFromIndex(range.endIndex)
                        } else {
                            
                        }
                    }
                    if ProxyCookieSid.characters.count > 0 && ProxyCookieToken.characters.count > 0 {
                        succeed = true
                    }
                }
                callbackHandler?(succeed)
        }
    } else {
        callbackHandler?(true)
    }
}

enum Soho3QProxyOrderType {
    case RMB99, RMB120, Error
    
    static func couponId(type: Soho3QProxyOrderType) -> (String, AnyObject) {
        if type == .RMB99 {
            if TestEnvironment {
                return ("1", 5) //测试
            } else {
                return ("1", 2) //正式
            }
        } else if type == .RMB120 {
            if TestEnvironment {
                return ("5", "") //测试
            } else {
                return ("2", "") //正式
            }
        } else {
            return ("", "")
        }
    }
}

private func ProxyCreateOrder(type: Soho3QProxyOrderType, callbackHandler: ((Bool, ModelCouponOrder?)->())?) {
    
    let phoneNumber = SOHO3Q_COOKIE_USER_PHONE
    if phoneNumber.characters.count > 0 {
        let (couponId, giftCouponId) = Soho3QProxyOrderType.couponId(type)
        let parameters: [String : AnyObject] = [
            "customerCompany": "未知公司",
            "customerName": "未知姓名",
            "customerPhone": phoneNumber,
            "items": [
                ["amount": 1, "couponId": couponId, "giftCouponId": giftCouponId]
            ]
        ]
        Alamofire.request(.POST,
            ProxyCreateCouponOrderAPIUrl,
            parameters: parameters,
            encoding: .JSON,
            headers: [
                "Content-Type": "application/json",
                "Accept-Encoding": "gzip, deflate",
                "Cookie": "sid=\(ProxyCookieSid); token=\(ProxyCookieToken)"
            ])
            .validate()
            .responseObject { (response: Response<ModelCreateCouponOrder, NSError>) in
                var succeed = false
                var orderObject: ModelCouponOrder? = nil
                if let value = response.result.value, result = value.result, items = result.items {
                    if items.count > 0 {
                        let item = items[0]
                        if let name = item.name {
                            succeed = true
                            orderObject = result
                            print("代客下单类型: \(name)")
                        }
                    }
                }
                callbackHandler?(succeed, orderObject)
        }
    } else {
        callbackHandler?(false, nil)
    }
}

func ProxyCreateOrderProcedure(sid: String, token: String, callbackHandler: ((Bool, ModelCouponOrder?)->())?) {
    
    let userHeader = [
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        "Accept-Encoding": "gzip, deflate",
        "Cookie": "sid=\(sid); token=\(token)"]
    Alamofire.request(.POST, GetUserInfoAPIUrl,
        parameters: nil,
        encoding: .URL,
        headers: userHeader
        )
        .validate()
        .responseObject {
            (response: Response<ModelGetUserInfo, NSError>) in
            switch response.result {
            case .Success:
                var type = Soho3QProxyOrderType.RMB99
                if let result = response.result.value?.result {
                    if let memberType = result.memberType {
                        switch memberType {
                        case "Float":
                            fallthrough
                        case "Fix":
                            fallthrough
                        case "Both":
                            //已经是会员
                            type = .RMB120
                            break;
                        default:
                            //不是会员
                            break;
                        }
                    }
                    
                    ProxyAccountLogin { succeed in
                        if succeed {
                            ProxyCreateOrder(type) { succeed, result in
                                if succeed {
                                    callbackHandler?(true, result) //下单成功
                                } else {
                                    callbackHandler?(false, nil)
                                }
                            }
                        } else {
                            callbackHandler?(false, nil)
                        }
                    }
                } else {
                    callbackHandler?(false, nil)
                }
                break
            case .Failure:
                callbackHandler?(false, nil)
                break
            }
    }
}

class SOHO3Q_USER_API {
    
    class func confirmStationReservation(project: ModelProjectItem, reservationDate: NSDate, callbackHandler: ((Bool, ModelReserveStationResult?) -> ())?) {
        if let projectId = project.projectId, cityId = project.cityId, projectName = project.projectNameOrigin, projectLocation = project.projectLocation {
            Alamofire.request(.POST,
                AjaxConfirmStationReservationAPIUrl,
                parameters: ["projectId": projectId, "cityId": cityId, "projectName": projectName, "projectLocation": projectLocation, "leaseTime": reservationDate.S3_dateString01],
                encoding: .URL,
                headers: [
                    "Accept": "application/json",
                    "Accept-Encoding": "gzip, deflate",
                    "Cookie": "sid=\(SOHO3Q_COOKIE_SID); token=\(SOHO3Q_COOKIE_TOKEN)"
                ])
                .validate()
                .responseObject(completionHandler: { (response: Response<ModelReserveStationResponse, NSError>) in
                    var retVal = false
                    var result: ModelReserveStationResult? = nil
                    if response.result.isSuccess {
                        if let value = response.result.value {
                            if nil != value.result && nil != value.result?.billId {
                                retVal = true
                                result = value.result
                            }
                        }
                    }
                    callbackHandler?(retVal, result)
                })
        }
    }
    
    class func generatePaymentForm(couponOrder: ModelCouponOrder) {
        if let order_id = couponOrder.paymentOrderId,
            order_num = couponOrder.paymentOrderNum,
            bill_id = couponOrder.paymentBillId,
            order_amount = couponOrder.totalPrice?.description {
            let project_id = "project_id"
            let channel = "0"
            let parameters = ["order_id": order_id, "order_num": order_num, "bill_id": bill_id, "order_amount": order_amount, "project_id": project_id, "channel": channel]
            let header = [
                "Content-Type": "application/x-www-form-urlencoded",
                "Accept-Encoding": "gzip, deflate",
                "Cookie": "sid=\(SOHO3Q_COOKIE_SID); token=\(SOHO3Q_COOKIE_TOKEN)"]
            Alamofire.request(.POST, PaymentFormSubmitUrl, parameters: parameters, encoding: .URL, headers: header)
                .validate()
                .response { (request, response, data, error) in
                    if let data = data {
                        let responseBody = NSString(data: data, encoding: NSUTF8StringEncoding)
                        print("\(responseBody)")
                    }
            }
        }
    }
    
    class func loginIfNeeded(currentVC: UIViewController?, callbackHandler: ((Bool) -> ())?) {
        let sid = SOHO3Q_COOKIE_SID
        let token = SOHO3Q_COOKIE_TOKEN
        if NSDate().compare(NSDate(timeInterval: SOHO3Q_COOKIE_Expire_Time_Interval, sinceDate: SOHO3Q_COOKIE_TOKEN_SET_DATE)) == .OrderedAscending &&
            sid.characters.count > 0 &&
            token.characters.count > 0 {
            //已经登录，且 当前时间 小于 过期时间，则跳过登录流程
            callbackHandler?(true)
        } else {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            if let loginVC = sb.instantiateViewControllerWithIdentifier("LoginViewController") as? LoginViewController {
                loginVC.loginSucceedCallback = { succeed in
                    callbackHandler?(succeed)
                }
                currentVC?.presentViewController(loginVC, animated: true) {
                }
            }
        }
    }
    
    class func getAvailableStationCount(callbackHandler: ((Int) -> ())?) {
        let sid = SOHO3Q_COOKIE_SID
        let token = SOHO3Q_COOKIE_TOKEN
        Alamofire.request(.GET, AjaxGetUserCouponAPIUrl, parameters: nil, encoding: .URL,
            headers: [
                "Accept": "application/json",
                "Content-Type": "application/x-www-form-urlencoded",
                "Accept-Encoding": "gzip, deflate",
                "Cookie": "sid=\(sid); token=\(token)"])
            .validate()
            .responseObject{ (response: Response<ModelGetMyCouponsResponse, NSError>) in
                var availableCount = 0
                switch response.result {
                case .Success:
                    if let result = response.result.value?.result {
                        for item in result {
                            if item.productType == "OPEN_STATION" {
                                if let remains = item.availableCount {
                                    availableCount = remains
                                }
                            }
                        }
                    }
                    break
                case .Failure:
                    break
                }
                callbackHandler?(availableCount)
        }
    }
}


