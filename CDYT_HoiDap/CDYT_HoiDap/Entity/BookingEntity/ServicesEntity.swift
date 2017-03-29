//
//  ServicesEntity.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 28/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class ServicesEntity: NSObject {
    
    var id = ""
    var his_service_Id = 0
    var name = ""
    var priceService : Double = 0
    var isCheckSelect = false

    override init() {
        super.init()
    }
    
    init(dictionary: NSDictionary) {
        if let value = dictionary["Id"] as? String {
            id = value
        }
        if let value = dictionary["HIS_Service_ID"] as? Int {
            his_service_Id = value
        }
        if let value = dictionary["Name"] as? String {
            name = value
        }
        if let value = dictionary["PriceService"] as? Double {
            priceService = value
        }
    }
}

