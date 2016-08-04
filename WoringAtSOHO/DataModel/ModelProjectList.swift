//
//  ModelProjectList.swift
//  WoringAtSOHO
//
//  Created by Seth Jin on 16/7/14.
//  Copyright © 2016年 SOHO3Q. All rights reserved.
//

import UIKit
import ObjectMapper
import MapKit

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
    var projectNameOrigin: String?
    var localCoordinate: CLLocationCoordinate2D? = nil
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
        projectNameOrigin <- map["projectName"]
        projectName <- map["projectName"]
        if let projectNameOrigin = projectNameOrigin {
            if nil == projectNameOrigin.rangeOfString("SOHO", options: .CaseInsensitiveSearch, range: nil, locale: nil) {
                //不包含"SOHO"字样
                projectName = projectNameOrigin.stringByReplacingOccurrencesOfString("3Q", withString: "SOHO 3Q", options: .CaseInsensitiveSearch, range: nil)
            }
        }
        var localCoordinate: String? = ""
        localCoordinate <- map["localCoordinate"]
        if let listLocalCoordinate = localCoordinate?.componentsSeparatedByString(",") {
            if listLocalCoordinate.count == 2 {
                if let latitude = CLLocationDegrees(listLocalCoordinate[1]), longitude = CLLocationDegrees(listLocalCoordinate[0]) {
                    self.localCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                }
            }
        }
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

class ModelProjectAvailable: ModelSOHOApi {
    
    var result: [ModelProjectAvailableItem]?
    
    required init?(_ map: Map) {
        super.init(map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map)
        result <- map["result"]
    }
}

class ModelProjectAvailableItem: Mappable {
    
    var occupied: Int? = nil
    var projectId: String? = nil
    var remains: Int? = nil
    var total: Int? = nil
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        occupied <- map["occupied"]
        projectId <- map["projectId"]
        remains <- map["remains"]
        total <- map["total"]
    }
}
