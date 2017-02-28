//
//  CheckInResultEntity.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 28/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class CheckInResultEntity: NSObject {
    
    var patinentId = 0
    var checkUpId = 0
    var patientHistory = 0
    var values = 0
    var sequence = 0
    
    override init() {
        super.init()
    }
    
    init(dictionary: NSDictionary) {
        if let value = dictionary["HIS_Patient_ID"] as? Int {
            patinentId = value
        }
        if let value = dictionary["HIS_CheckUp_ID"] as? Int {
            checkUpId = value
        }
        if let value = dictionary["HIS_PatientHistory_ID"] as? Int {
            patientHistory = value
        }
        if let value = dictionary["Value"] as? Int {
            values = value
        }
        if let value = dictionary["SequenceNo"] as? Int {
            sequence = value
        }
        
    }


}
