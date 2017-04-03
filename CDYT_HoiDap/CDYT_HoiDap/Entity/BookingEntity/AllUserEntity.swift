//
//  AllUserEntity.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 28/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class AllUserEntity: NSObject {
    
    var profile = FileUserEntity()
    var booking = BookingEntity()
    var listPac = [PackEntity]()
    var listSer = [ServicesEntity]()
    var isCheckSelect = false
    
    override init() {
        super.init()
    }
    
    init(dictionary: NSDictionary) {
        if let value = dictionary["Profile"] as? NSDictionary {
            profile = FileUserEntity.init(dictionary: value)
        }
        if let value = dictionary["BookingRecord"] as? NSDictionary {
            booking = BookingEntity.init(dictionary: value)
        }
        if let value = dictionary["ListPackages"] as? [NSDictionary] {
            for item in value {
                let entity = PackEntity.init(dictionary: item)
                listPac.append(entity)
            }
        }
        if let value = dictionary["ListServices"] as? [NSDictionary] {
            for item in value {
                let entity = ServicesEntity.init(dictionary: item)
                listSer.append(entity)
            }
        }

    }
}
