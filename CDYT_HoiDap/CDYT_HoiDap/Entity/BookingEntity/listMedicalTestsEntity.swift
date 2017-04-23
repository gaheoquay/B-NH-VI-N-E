//
//  listMedicalTestsEntity.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 14/04/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class listMedicalTestsEntity: NSObject {
    
    var medicalTest = MedicalTestEntity()
    var medicalTestLines = [MedicalTestLinesEntity]()
    var isShowDetail = false
    
    override init() {
        super.init()
    }
    init(dictionary: NSDictionary) {
        if let value = dictionary["MedicalTest"] as? NSDictionary {
            self.medicalTest = MedicalTestEntity.init(dictionary: value)
        }
        if let value = dictionary["MedicalTestLines"] as? [NSDictionary] {
            for item in value {
                let entity = MedicalTestLinesEntity.init(dictionary: item)
                self.medicalTestLines.append(entity)
            }
        }
    }
}

