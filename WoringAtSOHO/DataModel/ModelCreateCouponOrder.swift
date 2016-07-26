//
//  ModelCreateCouponOrder.swift
//  WoringAtSOHO
//
//  Created by Seth Jin on 16/7/27.
//  Copyright © 2016年 SOHO3Q. All rights reserved.
//

import UIKit
import ObjectMapper

class ModelCreateCouponOrder: ModelSOHOApi {
    var result: ModelCouponOrder? = nil
    
    override func mapping(map: Map) {
        result <- map["result"]
    }
}

class ModelCouponOrder: Mappable {
    
    var discountItems: String? = nil
    var items: [ModelCouponItem]? = nil
    var mobile: String? = nil
    var orderId: Int? = nil
    var originalPrice: Float? = nil
    var paymentBillId: String? = nil
    var paymentOrderId: String? = nil
    var paymentOrderNum: String? = nil
    var status: Int? = nil
    var totalPrice: Float? = nil
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        discountItems <- map["discountItems"]
        items <- map["items"]
        mobile <- map["mobile"]
        orderId <- map["orderId"]
        originalPrice <- map["originalPrice"]
        paymentBillId <- map["paymentBillId"]
        paymentOrderId <- map["paymentOrderId"]
        paymentOrderNum <- map["paymentOrderNum"]
        status <- map["status"]
        totalPrice <- map["totalPrice"]
    }
}

class ModelCouponItem: Mappable {
    var amount: Int? = nil
    var couponId: Int? = nil
    var couponType: Int? = nil
    var giftCouponId: Int? = nil
    var name: String? = nil
    var price: Float? = nil
    var productType: Int? = nil
    var unit: String? = nil
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        amount <- map["amount"]
        couponId <- map["couponId"]
        couponType <- map["couponType"]
        giftCouponId <- map["giftCouponId"]
        name <- map["name"]
        price <- map["price"]
        productType <- map["productType"]
        unit <- map["unit"]
    }
}


