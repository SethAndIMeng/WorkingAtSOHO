//
//  ModelProjectList.swift
//  WoringAtSOHO
//
//  Created by Seth Jin on 16/7/14.
//  Copyright © 2016年 SOHO3Q. All rights reserved.
//

import UIKit
import ObjectMapper

class ModelProjectList: ModelSOHOApi {
    
    var result: [ModelProjectItem]?
    
    required init?(_ map: Map) {
        super.init(map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map)
        result <- map["result"]
    }
}

class ModelProjectItem: Mappable {
    var cityId: String?
    var cityName: String?
    var projectId: String?
    var projectLocation: String?
    var projectName: String?
    var localCoordinate: String?
    var projectContent: String?
    var projectArea: String?
    var projectCode: String?
    var managerId: String?
    var projectManagerName: String?
    var projectManagerEmail: String?
    var projectManagerTel: String?
    var projectLargeImgs: [ModelImagePath]?
    var projectSmallImgs: [ModelImagePath]?
    var price: String?
    var total: Int?
    var remains: Int?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        cityId <- map["cityId"]
        cityName <- map["cityName"]
        projectId <- map["projectId"]
        projectLocation <- map["projectLocation"]
        projectName <- map["projectName"]
        localCoordinate <- map["localCoordinate"]
        projectName <- map["projectName"]
        localCoordinate <- map["localCoordinate"]
        projectContent <- map["projectContent"]
        projectArea <- map["projectArea"]
        projectCode <- map["projectCode"]
        managerId <- map["managerId"]
        projectManagerName <- map["projectManagerName"]
        projectManagerEmail <- map["projectManagerEmail"]
        projectManagerTel <- map["projectManagerTel"]
        projectLargeImgs <- map["projectLargeImgs"]
        projectSmallImgs <- map["projectSmallImgs"]
        price <- map["price"]
        total <- map["total"]
        remains <- map["remains"]
    }
}

class ModelImagePath: Mappable {
    var imgPath: String?
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        imgPath <- map["imgPath"]
    }
}
