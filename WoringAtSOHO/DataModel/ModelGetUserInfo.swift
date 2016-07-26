//
//  ModelGetUserInfo.swift
//  WoringAtSOHO
//
//  Created by Seth Jin on 16/7/26.
//  Copyright © 2016年 SOHO3Q. All rights reserved.
//

import UIKit
import ObjectMapper

class ModelGetUserInfo: ModelSOHOApi {
    
    var result: ModelUserInfo? = nil
    
    override func mapping(map: Map) {
        super.mapping(map)
        result <- map["result"]
    }
}

class ModelUserInfo: Mappable {
    
    var userName: String? = nil
    var memberType: String? = nil //"Fix", "Both", "Float"
    var memberLevel: String? = nil
    
    var remainDays: String? = nil
    var expireDate: String? = nil
    
    var headImg: String? = nil
    var inviteCode: String? = nil
    
    var fixMemberStartDate: String? = nil
    var fixMemberEndDate: String? = nil
    
    var fixedStation: String? = nil
    
    var floatMemberStartDate: String? = nil
    var floatMemberEndDate: String? = nil
    
    var memberStartDate: String? = nil
    var memberEndDate: String? = nil
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        userName <- map["userName"]
        memberType <- map["memberType"]
        memberLevel <- map["memberLevel"]
        
        remainDays <- map["remainDays"]
        expireDate <- map["expireDate"]
        
        headImg <- map["headImg"]
        inviteCode <- map["inviteCode"]
        
        fixMemberStartDate <- map["fixMemberStartDate"]
        fixMemberEndDate <- map["fixMemberEndDate"]
        
        fixedStation <- map["fixedStation"]
        
        floatMemberStartDate <- map["floatMemberStartDate"]
        fixMemberEndDate <- map["fixMemberEndDate"]
        
        fixedStation <- map["fixedStation"]
        
        floatMemberStartDate <- map["floatMemberStartDate"]
        floatMemberEndDate <- map["floatMemberEndDate"]
        
        memberStartDate <- map["memberStartDate"]
        memberEndDate <- map["memberEndDate"]
    }
}
