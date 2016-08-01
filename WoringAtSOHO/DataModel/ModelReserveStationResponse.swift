//
//  ModelReserveStationResponse.swift
//  WoringAtSOHO
//
//  Created by Seth Jin on 16/8/1.
//  Copyright © 2016年 SOHO3Q. All rights reserved.
//

import UIKit
import ObjectMapper

class ModelReserveStationResponse: ModelSOHOApi {
    
    var result: ModelReserveStationResult? = nil
    
    override func mapping(map: Map) {
        super.mapping(map)
        result <- map["result"]
    }
}

class ModelReserveStationResult: Mappable {
    
    var billId: String?
    var companyid: String?
    var orderAmount: NSDecimalNumber?
    var orderId: String?
    var orderNum: String?
    var userId: String?
    var voucherId: Int?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        billId <- map["billId"]
        companyid <- map["companyid"]
        orderAmount <- (map["orderAmount"], NSDecimalNumberTransform())
        orderId <- map["orderId"]
        orderNum <- map["orderNum"]
        userId <- map["userId"]
        voucherId <- map["voucherId"]
    }
}