//
//  SOHOConstants.swift
//  WoringAtSOHO
//
//  Created by Seth Jin on 16/7/15.
//  Copyright © 2016年 SOHO3Q. All rights reserved.
//

import UIKit

let BaseUrl = "http://soho3q.sohochina.com" //测试

//图片基地址url
let ImageBaseUrl = "http://www.soho3q.com/entry/ImgStreamServlet.do?imgPath="

//网页url
let LoginUrl = BaseUrl + "/user/login.html" //登录页
let RegisterUrl = BaseUrl + "/html5/3q-registered.jsp" //注册页

//Ajax API
let AjaxGetProjectListAPIUrl = BaseUrl + "/salesvc/ajax/booking/getprojectlist" //获取所有项目的接口地址
let GetUserInfoAPIUrl = BaseUrl + "/my/ajax/member/info" //获取用户信息api地址

var SOHO3Q_USER_TOKEN = ""
var SOHO3Q_USER_SID = ""

let SOHOApiDefaultHeader = [
    "Content-Type": "application/x-www-form-urlencoded",
    "Accept-Encoding": "gzip, deflate"
]