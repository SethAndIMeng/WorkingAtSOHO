//
//  ModelGetMyCoupons.swift
//  WoringAtSOHO
//
//  Created by Seth Jin on 16/8/1.
//  Copyright © 2016年 SOHO3Q. All rights reserved.
//

import UIKit
import ObjectMapper

class ModelGetMyCouponsResponse: ModelSOHOApi {
    
    var result: [ModelGetMyCouponsItems]? = nil
    
    override func mapping(map: Map) {
        super.mapping(map)
        result <- map["result"]
    }
}

class ModelGetMyCouponsItems: Mappable {
    
    var availableCount: Int?
    var couponId: Int?
    var couponName: String?
    var productType: String?
    var projectName: String?
    var usedCount: Int?
    
    required init?(_ map: Map) {
        
    }
    func mapping(map: Map) {
        availableCount <- map["availableCount"]
        couponId <- map["couponId"]
        couponName <- map["couponName"]
        productType <- map["productType"]
        projectName <- map["projectName"]
        usedCount <- map["usedCount"]
    }
}
