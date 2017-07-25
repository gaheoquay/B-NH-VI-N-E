//
//  UserDepartmentEntity.swift
//  CDYT_HoiDap
//
//  Created by Tuan Vu on 7/24/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class UserDepartmentEntity: Object {
    dynamic var id = ""
    dynamic var name = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    class func initWithDictionary(dictionary: NSDictionary) -> UserDepartmentEntity {
        let this = UserDepartmentEntity()
        if let value = dictionary["Id"] as? String{
            this.id = value
        }
        if let value = dictionary["Name"] as? String{
            this.name = value
        }
        return this
    }
}
