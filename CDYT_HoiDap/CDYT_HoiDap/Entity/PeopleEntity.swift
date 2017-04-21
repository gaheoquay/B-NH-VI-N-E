//
//  PeopleEntity.swift
//  CDYT_HoiDap
//
//  Created by Quang anh Vu on 4/21/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class PeopleEntity: NSObject {
    
    var user = AuthorEntity()
    var department = DepartmentEntity()

    override init() {
        super.init()
    }
    init(dictionary: NSDictionary) {
        if let value = dictionary["User"] as? NSDictionary {
            self.user = AuthorEntity.init(dictionary: value)
        }
        if let value = dictionary["Department"] as? NSDictionary {
            self.department = DepartmentEntity.init(dictionary: value)
        }
    }
}
