//
//  MedicalTestLinesEntity.swift
//  CDYT_HoiDap
//
//  Created by Quang anh Vu on 4/21/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class MedicalTestLinesEntity: NSObject {
    var id = ""
    var hisMedicalTestLineID = ""
    var serviceName = ""
    var indicator = ""
    var hisroomId = 0
    var femaleHightIndicator = ""
    var femaleLowIn = ""
    var maleHight = ""
    var maleLow = ""
    var unit = ""
    var nameLine = ""
    
    override init() {
        super.init()
    }
    
    init(dictionary: NSDictionary) {
        if let value = dictionary["Id"] as? String {
            self.id = value
        }
        if let value = dictionary["HISMedicalTestLineID"] as? String {
            self.hisMedicalTestLineID = value
        }
        if let value = dictionary["IndicatorStr"] as? String {
            self.indicator = value
        }
        if let value = dictionary["LowerIndicatorMale"] as? String {
            self.maleLow = value
        }
        if let value = dictionary["LowerIndicatorFemale"] as? String {
            self.femaleLowIn = value
        }
        if let value = dictionary["HigherIndicatorFemale"] as? String {
            self.femaleHightIndicator = value
        }
        if let value = dictionary["HigherIndicatorMale"] as? String {
            self.maleHight = value
        }
        if let value = dictionary["Unit"] as? String {
            self.unit = value
        }
        if let value = dictionary["NameLine"] as? String {
            self.nameLine = value
        }
    }

}
