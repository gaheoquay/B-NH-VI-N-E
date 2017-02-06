//
//  ListNotificationEntity.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 1/9/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class ListNotificationEntity: Object {
    dynamic var linkedUser : LinkedUser?
    dynamic var notificaiton : NotificationEntity?
    dynamic var postTitle = ""
    dynamic var content = ""
    dynamic var pkId = 0
    
    override static func primaryKey() -> String? {
        return "pkId"
    }
    
    class func initWithDict(dictionary : NSDictionary, index:Int) -> ListNotificationEntity{
        let this = ListNotificationEntity()
        this.pkId = index
        if let value = dictionary["LinkedUser"] as? NSDictionary {
            this.linkedUser = LinkedUser.initWithDictionary(dictionary: value)
        }
        if let value = dictionary["Notification"] as? NSDictionary {
            this.notificaiton = NotificationEntity.initWithDictionary(dictionary: value)
        }
        if let value = dictionary["PostTitle"] as? String {
            this.postTitle = value
        }
        if let value = dictionary["Content"] as? String {
            this.content = value
        }
        return this
    }
}
