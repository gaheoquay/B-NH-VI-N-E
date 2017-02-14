//
//  CateEntity.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 13/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class CateEntity: NSObject {
    
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
