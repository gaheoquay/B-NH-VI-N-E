//
//  PatientHistoryEntity.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 14/04/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class PatientHistoryEntity: NSObject {
    
    var id = ""
    var hisPatientHistoryID = ""
    
    override init() {
        super.init()
    }
    
    init(dictionary: NSDictionary) {
        if let value = dictionary["Id"] as? String {
            self.id = value
        }
        if let value = dictionary["HISPatientHistoryID"] as? String {
            self.hisPatientHistoryID = value
        }
    }

}
