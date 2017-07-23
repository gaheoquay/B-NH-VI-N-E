//
//  NotificationEntity.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 1/9/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class NotificationEntity: NSObject {
  var id = ""
  var type = 0
  var detailId = ""
  var parentId = ""
  var isRead = false
  var createdDate : Double = 0
    
//    override static func primaryKey() -> String? {
//        return "id"
//    }
    override init(){
        super.init()
    }
    
   class func initWithDictionary(dictionary:NSDictionary) -> NotificationEntity{
    let this = NotificationEntity()
    
    if let value = dictionary["Id"] as? String {
      this.id = value
    }
    if let value = dictionary["Type"] as? Int {
      this.type = value
    }
    if let value = dictionary["DetailId"] as? String {
      this.detailId = value
    }
    if let value = dictionary["ParentId"] as? String {
      this.parentId = value
    }
    if let value = dictionary["IsRead"] as? Bool {
      this.isRead = value
    }
    if let value = dictionary["CreatedDate"] as? Double {
      this.createdDate = value/1000
    }
    
    return this
  }
    
}
