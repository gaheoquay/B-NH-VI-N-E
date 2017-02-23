//
//  Global.swift
//  HoiDap
//
//  Created by CDYT on 12/26/16.
//  Copyright © 2016 ISORA. All rights reserved.
//

import UIKit

//let BASE_URL = "http://onlineapi.info:8096"    //RELEASE
//let BASE_URL = "http://onlineapi.info:38096"     //DEV
let BASE_URL = "http://123.24.206.9:38192"     //DEV

let REGISTER_USER = BASE_URL + "/User/Register"
let UPLOAD_IMAGE = BASE_URL + "/Image/UploadImage"
let LOGIN_EMAIL_NICKNAME = BASE_URL + "/User/LoginWithEmailOrNickName"
let UPDATE_PROFILE = BASE_URL + "/User/UpdateProfile"
let FOLLOW_TAG = BASE_URL + "/User/FollowTag"
let GET_CATE = BASE_URL + "/Category/GetList"

let HOTEST_TAG = BASE_URL + "/Post/GetHotestTags"
let GET_FEEDS = BASE_URL + "/Post/GetFeed"
let SEARCH = BASE_URL + "/Post/Search"
let GET_QUESTION_BY_ID = BASE_URL + "/Post/GetQuestionCreatedByUserId"

let GET_UNANSWER = BASE_URL + "/Post/GetUnansweredList"
let GET_QUESTION = BASE_URL + "/Post/GetQuestionByTag"
let POST_QUESTION = BASE_URL + "/Post/Insert"
let GET_QUESTION_BY_TAG = BASE_URL + "/Post/GetQuestionByTag"
let GET_LIST_COMMENT_BY_POSTID = BASE_URL + "/Post/GetListCommentByPostId"
let POST_COMMENT = BASE_URL + "/Post/Comment"
let POST_COMMENT_ON_COMMENT = BASE_URL + "/Post/CommentOnComment"
let LIKE_POST = BASE_URL + "/Post/LikePost"
let LIKE_COMMENT = BASE_URL + "/Post/LikeComment"
let LIKE_COMMENT_ON_COMMENT = BASE_URL + "/Post/LikeCommentLevel2"
let MARK_AS_SOLUTION = BASE_URL + "/Post/AcceptAsSolution"
let GET_LIST_NOTIFICATION = BASE_URL + "/Notification/GetNotificationsByUserId"
let GET_POST_BY_ID = BASE_URL + "/Post/GetPostById"
let GET_USER_BY_ID = BASE_URL + "/User/GetUserById"
let CHANGE_PASSWORD = BASE_URL + "/User/ChangePassword"
let DELETE_ALL = BASE_URL + "/Post/Delete"
let UPDATE_POST = BASE_URL + "/Post/UpdatePost"
let GET_LIST_SUBCOMMENT = BASE_URL + "/Post/GetListSubCommentByCommentId"
let SET_READ_NOTIFICATION = BASE_URL + "/Notification/SetRead"
let UPDATE_COMMENT = BASE_URL + "/Post/UpdateComment"
let UPDATE_SUBCOMMENT = BASE_URL + "/Post/UpdateSubComment"
let FOLLOW_POST = BASE_URL + "/Post/FollowPost"
let POLICY_RULE = BASE_URL + "/PolicyAndCondition"
let GET_UNREAD_NOTIFICATION = BASE_URL + "/Notification/GetUnreadNotificationCount"
let GET_QUESTION_FOLLOWED = BASE_URL + "/Post/GetQuestionFollowedByUserId"
let GET_QUESTION_ASSIGN = BASE_URL + "/Post/GetQuestionAssignToUser"
let GET_LIST_DOCTOR = BASE_URL + "/category/getListDoctors"
let GET_LASTED_POST = BASE_URL + "/Post/Classify"

let KEY_AUTH_DEFAULT = "123i@123sora"
let NOTIFICATION_TOKEN = "NOTIFICATION_TOKEN"
let RELOAD_ALL_DATA = "RELOAD_ALL_DATA"
let LOGIN_SUCCESS = "LOGIN_SUCCESS"
let UPDATE_USERINFO = "UPDATE_USERINFO"
let COMMENT_ON_COMMENT_SUCCESS = "COMMENT_ON_COMMENT_SUCCESS"
let RELOAD_QUESTION_DETAIL = "RELOAD_QUESTION_DETAIL"
let RELOAD_COMMENT_DETAIL = "RELOAD_COMMENT_DETAIL"
let RELOAD_SUBCOMMENT_DETAIL = "RELOAD_SUBCOMMENT_DETAIL"

let SENDBIRD_APPKEY = "537AC4A8-39A9-4DF6-8D3F-03559A226AD2"

let SPLASH = "ScreenSplash"
let HOME = "ScreenHome"
let SLECT_QUESTION_NO_ANSWER = "ScreenQuestionNoAnswer"
let SLECT_TAG = "ScreenPopularTags"
let DETAILS_TAG = "ScreenDetailTag"
let MY_PAGE = "ScreenMyPage"
let MY_ACCOUNT = "ScreenMyAccount"
let NOTIFICATION = "ScreenNotification"
let MAIL_BOX = "ScreenMailBox"
let CHAT = "ScreenChat"
let SETTING = "ScreenSetting"
let POLICIES = "ScreenPolicies"
let TERM = "ScreenTerms"
let USER_PAGE = "ScreenUserPage"
let USER_ACCOUNT = "ScreenUserAccount"
let CHANGE_PASS = "ScreenChangePassword"
let LOGIN = "ScreenLogin"
let FORGOT_PASS = "ScreenForgotPassword"
let DETAILS_POST = "ScreenDetailPost"
let DETAIL_COMMENT = "ScreenDetailComment"
let CREATE_QUESTION = "ScreenCreateQuestion"
let SEARCHS = "ScreenSearch"

var listNotification = [ListNotificationEntity]()
var listCate = [CateEntity]()
var listAllDoctor = [ListDoctorEntity]()
var isHiddent = false

