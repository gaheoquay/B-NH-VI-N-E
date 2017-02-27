//
//  ZoneEntity.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 2/27/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class ZoneEntity: NSObject {
  var zoneId:Double = 0
  var districtId:Double = 0
  var name = ""
  var updated : Double = 0
  override init(){
    super.init()
  }
  func initListZone() -> [ZoneEntity] {
    var listCountry = [ZoneEntity]()
    for i in 0..<10 {
      let entity = ZoneEntity.init()
      entity.districtId = Double(i)
      entity.zoneId = Double(i)
      entity.name = "Zone \(i)"
      listCountry.append(entity)
    }
    return listCountry
  }
  init(dictionary:NSDictionary) {
    if let value = dictionary["HIS_Zone_ID"] as? Double {
      zoneId = value
    }
    if let value = dictionary["HIS_District_ID"] as? Double {
      districtId = value
    }
    if let value = dictionary["Name"] as? String {
      name = value
    }
    if let value = dictionary["Updated"] as? Double {
      updated = value
    }
  }
}
