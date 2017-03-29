//
//  PackServiceEntity.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 28/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class PackServiceEntity: NSObject {
    
    var listPack = [PackagesEntity]()
    var listSer = [ServicesEntity]()
    
    override init() {
        super.init()
    }
    
    init(dictionary: NSDictionary) {
        if let value = dictionary["ListPackages"] as? [NSDictionary] {
            for item in value {
                let entity = PackagesEntity.init(dictionary: item)
                listPack.append(entity)
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
