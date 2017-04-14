//
//  medicalTestGroupEntity.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 14/04/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class medicalTestGroupEntity: NSObject {
    var id = ""
    var hisServiceMedicTestGroupID = ""
    
    override init() {
        super.init()
    }
    init(dictionary: NSDictionary) {
        if let value = dictionary["Id"] as? String {
            self.id = value
        }
        if let value = dictionary["HISServiceMedicTestGroupID"] as? String {
            self.hisServiceMedicTestGroupID = value
        }
    }
}
