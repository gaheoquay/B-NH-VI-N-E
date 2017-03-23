//
//  ListAdminEntity.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 22/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class ListAdminEntity: NSObject {
    
    var id = ""
    var email = ""
    var nickName = ""
    var fullName = ""
    var thumbnailAvatar = ""
    var avatar = ""
    var role = 0
    var isVerifile = false
    var jobTitle = ""
    var isBlocked = false
    var phone = ""
    var adress = ""
    var gender = 0
    var dob: Double = 0
    
    override init() {
        super.init()
    }
    
    init(dictionary: NSDictionary) {
        if let value = dictionary["Gender"] as? Int {
            gender = value
        }
        if let value = dictionary["Id"] as? String {
            id = value
        }
        if let value = dictionary["Email"] as? String {
            email = value
        }
        if let value = dictionary["Nickname"] as? String {
            nickName = value
        }
        if let value = dictionary["FullName"] as? String {
            fullName = value
        }
        if let value = dictionary["ThumbnailAvatarUrl"] as? String {
            thumbnailAvatar = value
        }
        if let value = dictionary["AvatarUrl"] as? String {
            avatar = value
        }
        if let value = dictionary["Role"] as? Int {
            role = value
        }
        if let value = dictionary["IsVerified"] as? Bool {
            isVerifile = value
        }
        if let value = dictionary["JobTitle"] as? String {
            jobTitle = value
        }
        if let value = dictionary["IsBlocked"] as? Bool {
            isBlocked = value
        }
        if let value = dictionary["DOB"] as? Double {
            dob = value
        }
        if let value = dictionary["Phone"] as? String {
            phone = value
        }
        if let value = dictionary["Address"] as? String {
            adress = value
        }
        
    }

}
