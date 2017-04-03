//
//  PackagesEntity.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 28/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class PackagesEntity: NSObject {
    
    var pack = PackEntity()
    var service = [ServicesEntity]()
    var textSerive = ""
    
    override init() {
        super.init()
    }
    
    init(dictionary: NSDictionary) {
        if let value = dictionary["Pack"] as? NSDictionary {
            pack = PackEntity.init(dictionary: value)
        }
        if let value = dictionary["Services"] as? [NSDictionary] {
            for item in value {
                let entity = ServicesEntity.init(dictionary: item)
                textSerive += entity.name
                service.append(entity)
            }
        }
    }

}
