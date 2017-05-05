//
//  NotificationNewEntity.swift
//  CDYT_HoiDap
//
//  Created by Quang anh Vu on 5/4/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class NotificationNewEntity: NSObject {
    
    var id = ""
    var type = 0
    var detailId = ""
    var parenId = ""
    var isRead = false
    var createDate:Double = 0
    var displayType = 0
    var userId = ""
    var userAvatar = ""
    var conTent = ""
    var userDisPlay = ""
    
    override init() {
        super.init()
    }
    init(dictionary: NSDictionary) {
        if let value = dictionary["Id"] as? String {
            self.id = value
        }
        if let value = dictionary["Type"] as? Int {
            self.type = value
        }
        if let value = dictionary["DetailId"] as? String {
            self.detailId = value
        }
        if let value = dictionary["ParentId"] as? String {
            self.parenId = value
        }
        if let value = dictionary["IsRead"] as? Bool {
            self.isRead = value
        }
        if let value = dictionary["CreatedDate"] as? Double {
            self.createDate = value
        }
        if let value = dictionary["DisplayType"] as? Int {
            self.displayType = value
        }
        if let value = dictionary["UserId"] as? String {
            self.userId = value
        }
        if let value = dictionary["UserDisplayName"] as? String {
            self.userDisPlay = value
        }
        if let value = dictionary["UserAvatar"] as? String {
            self.userAvatar = value
        }
        if let value = dictionary["Content"] as? String {
            self.conTent = value
        }
    }
}
