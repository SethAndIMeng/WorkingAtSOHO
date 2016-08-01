//
//  SOHOExtension.swift
//  WoringAtSOHO
//
//  Created by Seth Jin on 16/8/1.
//  Copyright © 2016年 SOHO3Q. All rights reserved.
//

import UIKit

extension NSDate {
    
    var S3_dateFormatter01: NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "zh_CN")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }
    
    var S3_dateString01: String {
        return S3_dateFormatter01.stringFromDate(self)
    }
    
}

extension UIAlertView {
    class func soho3q_showOrderAlert(result: ModelCouponOrder?) {
        //        if let result = result, items = result.items {
        //            if items.count > 0 {
        //                let item = items[0]
        //                let name = item.name
        //                UIAlertView(title: "下单成功", message: "为\(result.mobile)生成\(name): paymentOrderNum=\(result.paymentOrderNum), paymentOrderId=\(result.paymentOrderId), paymentBillId=\(result.paymentBillId), originalPrice=\(result.originalPrice), totalPrice=\(result.totalPrice)", delegate: nil, cancelButtonTitle: "确定").show()
        ////                generatePaymentForm(result)
        //            }
        //        }
    }
}