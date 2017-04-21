//
//  DepartmentEntity.swift
//  CDYT_HoiDap
//
//  Created by Quang anh Vu on 4/21/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class DepartmentEntity: NSObject {
    
    var id = ""
    var name = ""
    
    override init() {
        super.init()
    }
    
    init(dictionary: NSDictionary) {
        if let value = dictionary["Id"] as? String {
            self.id = value
        }
        if let value = dictionary["Name"] as? String {
            self.name = value
        }
    }
}
