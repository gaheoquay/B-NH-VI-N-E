//
//  MediCalEntity.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 14/04/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class MediCalEntity: NSObject {
    var medicalTestGroup = medicalTestGroupEntity()
    var listMedicalTests = [listMedicalTestsEntity]()
    var moneyExtra:Double = 0
    
    override init() {
        super.init()
    }
    
    init(dictionary: NSDictionary) {
        if let value = dictionary["MedicalTestGroup"] as? NSDictionary {
            self.medicalTestGroup = medicalTestGroupEntity.init(dictionary: value)
        }
        if let value = dictionary["ListMedicalTests"] as? [NSDictionary] {
            for item in value {
                let entity = listMedicalTestsEntity.init(dictionary: item)
                listMedicalTests.append(entity)
            }
        }
        if let value = dictionary["MoneyExtra"] as? Double {
            self.moneyExtra = value
        }
    }
}
