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

let GET_QUESTION_BY_ID = BASE_URL + "/Post/GetQuestionCreatedByUserId"

let GET_UNANSWER = BASE_URL + "/Post/GetUnansweredList"
let GET_QUESTION = BASE_URL + "/Post/GetQuestionByTag"
let POST_QUESTION = BASE_URL + "/Post/Insert"
let GET_QUESTION_BY_TAG = BASE_URL + "/Post/GetQuestionByTag"
let GET_LIST_COMMENT_BY_POSTID = BASE_URL + "/Post/GetListCommentByPostId"
let POST_COMMENT = BASE_URL + "/Post/Comment"

let KEY_AUTH_DEFAULT = "123i@123sora"
let NOTIFICATION_TOKEN = "NOTIFICATION_TOKEN"
