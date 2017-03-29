//
//  ServiceEntity.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 2/27/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class ServiceEntity: NSObject {
  var serviceId = 0
  var priceService:Double = 0
  var name = ""
  var roomId : Double = 0
  var roomName = ""
  var updated : Double = 0
  //test
  var isCheckSelect = false
  var isCheckShowDetail = false
  //end test
  override init(){
    super.init()
  }
    
  init(dictionary:NSDictionary) {
    if let value = dictionary["HIS_Service_ID"] as? Int {
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
