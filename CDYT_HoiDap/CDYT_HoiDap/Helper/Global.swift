//
//  Global.swift
//  HoiDap
//
//  Created by CDYT on 12/26/16.
//  Copyright © 2016 ISORA. All rights reserved.
//

import UIKit

//let BASE_URL = "http://onlineapi.info:8096"    //RELEASE
let BASE_URL = "http://onlineapi.info:38096"     //DEV

let REGISTER_USER = BASE_URL + "/User/Register"
let UPLOAD_IMAGE = BASE_URL + "/Image/UploadImage"
let LOGIN_EMAIL_NICKNAME = BASE_URL + "/User/LoginWithEmailOrNickName"
let UPDATE_PROFILE = BASE_URL + "/User/UpdateProfile"
let FOLLOW_TAG = BASE_URL + "/User/FollowTag"

let HOTEST_TAG = BASE_URL + "/Post/GetHotestTags"
let GET_FEEDS = BASE_URL + "/Post/GetFeed"

let KEY_AUTH_DEFAULT = "123i@123sora"
let NOTIFICATION_TOKEN = "NOTIFICATION_TOKEN"
