//
//  ModelSOHOApi.swift
//  WoringAtSOHO
//
//  Created by Seth Jin on 16/7/26.
//  Copyright © 2016年 SOHO3Q. All rights reserved.
//

import UIKit
import ObjectMapper

class ModelSOHOApi: Mappable {
    var status: String?
    var message: String?
    
    var code: String?
    var serverIp: String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        code <- map["code"]
        serverIp <- map["serverIp"]
    }
}
