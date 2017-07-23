//
//  UserEntity.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/27/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import Foundation
import RealmSwift

class UserEntity: Object {
    dynamic var id = ""
    dynamic var email = ""
    dynamic var nickname = ""
    dynamic var fullname = ""
    dynamic var job = ""
    dynamic var company = ""
    dynamic var dob : Double = 0
    dynamic var address = ""
    dynamic var gender = 0
    dynamic var thumbnailAvatarUrl = ""
    dynamic var avatarUrl = ""
    dynamic var phone = ""
    dynamic var socialId = ""
    dynamic var socialType = 0
    dynamic var role = 0
    dynamic var reputationRate = 1
    dynamic var isVerified = false
    dynamic var departmentId = ""
    dynamic var jobTitle = ""
    dynamic var updatedDate : Double = 0
    dynamic var createdDate : Double = 0
    dynamic var loginToken = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }

    class func initWithDictionary(dictionary: NSDictionary) -> UserEntity {
        let this = UserEntity()
        if let account = dictionary["Account"] as? NSDictionary {
            if let value = account["Id"] as? String{
                this.id = value
            }
            if let value = account["Email"] as? String {
                this.email = value
            }
            if let value = account["Nickname"] as? String {
                this.nickname = value
            }
            if let value = account["FullName"] as? String {
                this.fullname = value
            }
            if let value = account["Job"] as? String {
                this.job = value
            }
            if let value = account["Company"] as? String {
                this.company = value
            }
            if let value = account["DOB"] as? Double {
                this.dob = value/1000
            }
            if let value = account["Address"] as? String {
                this.address = value
            }
            if let value = account["Gender"] as? Int {
                this.gender = value
            }
            if let value = account["ThumbnailAvatarUrl"] as? String {
                this.thumbnailAvatarUrl = value
            }
            if let value = account["AvatarUrl"] as? String {
                this.avatarUrl = value
            }
            if let value = account["Phone"] as? String {
                this.phone = value
            }
            if let value = account["SocialId"] as? String {
                this.socialId = value
            }
            if let value = account["SocialType"] as? Int {
                this.socialType = value
            }
            if let value = account["DepartmentId"] as? String {
                this.departmentId = value
            }
            if let value = account["JobTitle"] as? String {
                this.jobTitle = value
            }
            if let value = account["Role"] as? Int {
                this.role = value
            }
            if let value = account["ReputationRate"] as? Int {
                this.reputationRate = value
            }
            if let value = account["IsVerified"] as? Bool {
                this.isVerified = value
            }
            if let value = account["UpdatedDate"] as? Double {
                this.updatedDate = value/1000
            }
            if let value = account["CreatedDate"] as? Double {
                this.createdDate = value/1000
            }
            if let value = account["LoginToken"] as? String {
                this.loginToken = value
            }
        }
        return this
    }
}
