//
//  PackEntity.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 28/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class PackEntity: NSObject {
    
    var id = ""
    var his_service_id = 0
    var name = ""
    var update : Double = 0
    var pricePackage : Double = 0
    var arrService = ""
    var isCheckShowDetail = false
    var isCheckSelect = false
    
    override init() {
        super.init()
    }
    
    init(dictionary: NSDictionary) {
        if let value = dictionary["Id"] as? String {
            id = value
        }
        if let value = dictionary["HIS_ServicePackage_ID"] as? Int {
            his_service_id = value
        }
        if let value = dictionary["Name"] as? String {
            name = value
        }
        if let value = dictionary["Updated"] as? Double {
            update = value
        }
        if let value = dictionary["PricePackage"] as? Double {
            pricePackage = value
        }
        
    }

}

