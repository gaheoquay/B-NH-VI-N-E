//
//  DistricHomeEntity.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 29/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class DistricHomeEntity: NSObject {
    
    var id = ""
    var name = ""
    
    override init() {
        super.init()
    }
    
    init(dictionary: NSDictionary) {
        if let value = dictionary["Id"] as? String {
            id = value
        }
        if let value = dictionary["Name"] as? String {
            name = value
        }
    }

}
