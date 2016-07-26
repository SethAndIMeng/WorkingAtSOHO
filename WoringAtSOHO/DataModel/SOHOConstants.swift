//
//  SOHOConstants.swift
//  WoringAtSOHO
//
//  Created by Seth Jin on 16/7/15.
//  Copyright © 2016年 SOHO3Q. All rights reserved.
//

import UIKit
import Alamofire

let TestEnvironment = true

var BaseUrl: String {
    if TestEnvironment {
        return "http://soho3q.sohochina.com" //测试服务器
    } else {
        return "http://m.soho3q.com" //正式服务器
    }
}

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
        return "Majin1982" //夏辉的测试密码
    } else {
        return "12345678" //周小洲的正式账户密码
    }
}

var ProxyCookieToken = ""
var ProxyCookieSid = ""

//图片基地址url
let ImageBaseUrl = "http://www.soho3q.com/entry/ImgStreamServlet.do?imgPath="

//网页url
let LoginUrl = BaseUrl + "/user/login.html" //登录页
let RegisterUrl = BaseUrl + "/html5/3q-registered.jsp" //注册页

//Ajax API
let AjaxGetProjectListAPIUrl = BaseUrl + "/salesvc/ajax/booking/getprojectlist" //获取所有项目的接口地址
let GetUserInfoAPIUrl = BaseUrl + "/my/ajax/member/info" //获取用户信息api地址
let LoginAPIUrl = BaseUrl + "/my/ajax/login/submit" //登录api地址
let ProxyCreateCouponOrderAPIUrl = BaseUrl + "/salesvc/ajax/booking/create_coupon_order" //代客下单api地址

var SOHO3Q_COOKIE_TOKEN = ""
var SOHO3Q_COOKIE_SID = ""
var SOHO3Q_COOKIE_USER_PHONE = "" //客户的手机号（代客下单ID）

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

func ProxyCreateOrder(type: Soho3QProxyOrderType, callbackHandler: ((Bool)->())?) {
    
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
                if let value = response.result.value, result = value.result, items = result.items{
                    if items.count > 0 {
                        let item = items[0]
                        if let name = item.name {
                            print("成功代客下单: \(name)")
                            succeed = true
                        }
                    }
                }
                callbackHandler?(succeed)
        }
    } else {
        callbackHandler?(false)
    }
}
