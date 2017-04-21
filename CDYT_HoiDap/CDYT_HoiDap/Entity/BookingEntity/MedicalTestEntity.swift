//
//  MedicalTestEntity.swift
//  CDYT_HoiDap
//
//  Created by Quang anh Vu on 4/21/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class MedicalTestEntity: NSObject {
    var id = ""
    var hisServiceMedicalTestID = ""
    var serviceName = ""
    var indicator = ""
    var hisroomId = 0
    var femaleHightIndicator = ""
    var femaleLowIn = ""
    var maleHight = ""
    var maleLow = ""
    var unit = ""
    
    
    override init() {
        super.init()
    }
    
    init(dictionary: NSDictionary) {
        if let value = dictionary["Id"] as? String {
            self.id = value
        }
        if let value = dictionary["HISServiceMedicalTestID"] as? String {
            self.hisServiceMedicalTestID = value
        }
        if let value = dictionary["ServiceName"] as? String {
            self.serviceName = value
        }
        if let value = dictionary["IndicatorStr"] as? String {
            self.indicator = value
        }
        if let value = dictionary["HisRoomId"] as? Int {
            self.hisroomId = value
        }
        if let value = dictionary["FemaleHighIndicator"] as? String {
            self.femaleHightIndicator = value
        }
        if let value = dictionary["FemaleLowIndicator"] as? String {
            self.femaleLowIn = value
        }
        if let value = dictionary["MaleHighIndicator"] as? String {
            self.maleHight = value
        }
        if let value = dictionary["MaleLowIndicator"] as? String {
            self.maleLow = value
        }
        if let value = dictionary["Unit"] as? String {
            self.unit = value
        }
    }

}
