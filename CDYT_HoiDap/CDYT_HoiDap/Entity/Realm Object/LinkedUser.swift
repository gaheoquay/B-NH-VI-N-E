//
//  LinkedUser.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 2/6/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import Foundation
import RealmSwift

class LinkedUser: NSObject {
    var id = ""
    var email = ""
    var nickname = ""
    var fullname = ""
    var job = ""
    var company = ""
    var dob : Double = 0
    var address = ""
    var gender = 0
    var thumbnailAvatarUrl = ""
    var avatarUrl = ""
    var phone = ""
    var socialId = ""
    var socialType = 0
    var role = 1
    var reputationRate = 1
    var isVerified = false
    var updatedDate : Double = 0
    var createdDate : Double = 0
    
//    override static func primaryKey() -> String? {
//        return "id"
//    }
    
    class func initWithDictionary(dictionary: NSDictionary) -> LinkedUser {
        let this = LinkedUser()
        if let value = dictionary["Id"] as? String{
            this.id = value
        }
        if let value = dictionary["Email"] as? String {
            this.email = value
        }
        if let value = dictionary["Nickname"] as? String {
            this.nickname = value
        }
        if let value = dictionary["FullName"] as? String {
            this.fullname = value
        }
        if let value = dictionary["Job"] as? String {
            this.job = value
        }
        if let value = dictionary["Company"] as? String {
            this.company = value
        }
        if let value = dictionary["DOB"] as? Double {
            this.dob = value/1000
        }
        if let value = dictionary["Address"] as? String {
            this.address = value
        }
        if let value = dictionary["Gender"] as? Int {
            this.gender = value
        }
        if let value = dictionary["ThumbnailAvatarUrl"] as? String {
            this.thumbnailAvatarUrl = value
        }
        if let value = dictionary["AvatarUrl"] as? String {
            this.avatarUrl = value
        }
        if let value = dictionary["Phone"] as? String {
            this.phone = value
        }
        if let value = dictionary["SocialId"] as? String {
            this.socialId = value
        }
        if let value = dictionary["SocialType"] as? Int {
            this.socialType = value
        }
        if let value = dictionary["Role"] as? Int {
            this.role = value
        }
        if let value = dictionary["ReputationRate"] as? Int {
            this.reputationRate = value
        }
        if let value = dictionary["IsVerified"] as? Bool {
            this.isVerified = value
        }
        if let value = dictionary["UpdatedDate"] as? Double {
            this.updatedDate = value/1000
        }
        if let value = dictionary["CreatedDate"] as? Double {
            this.createdDate = value/1000
        }
        
        return this
    }

    override init(){
        super.init()
    }
    
}
