//
//  ServiceEntity.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 2/27/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class ServiceEntity: NSObject {
  var serviceId:Double = 0
  var priceService:Double = 0
  var name = ""
  var roomId : Double = 0
  var roomName = ""
  var updated : Double = 0
  override init(){
    super.init()
  }
  func initListCountry() -> [ServiceEntity] {
    var listCountry = [ServiceEntity]()
    for i in 0..<10 {
      let entity = ServiceEntity.init()
      entity.priceService = Double(i)
      entity.serviceId = Double(i) * 1000
      entity.roomId = Double(i)
      entity.roomName = "Room \(i)"
      entity.name = "Service \(i)"
      listCountry.append(entity)
    }
    return listCountry
  }
  init(dictionary:NSDictionary) {
    if let value = dictionary["HIS_Service_ID"] as? Double {
      serviceId = value
    }
    if let value = dictionary["PriceService"] as? Double {
      priceService = value
    }
    if let value = dictionary["HIS_Room_ID"] as? Double {
      roomId = value
    }
    if let value = dictionary["Name"] as? String {
      name = value
    }
    if let value = dictionary["HIS_Room_Name"] as? String {
      roomName = value
    }
    if let value = dictionary["Updated"] as? Double {
      updated = value
    }
  }

}
