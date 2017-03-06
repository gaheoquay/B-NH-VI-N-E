//
//  BaseViewController.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 2/22/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      NotificationCenter.default.addObserver(self, selector: #selector(self.gotoDetail(notification:)), name: NSNotification.Name.init(GO_TO_DETAIL_WHEN_TAP_NOTIFICATION), object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(self.showNotification(notification:)), name: NSNotification.Name.init(SHOW_NOTIFICAION), object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(self.gotoChat(notification:)), name: NSNotification.Name.init(GO_TO_CHAT), object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(setUpBadge), name: Notification.Name.init(UPDATE_BADGE), object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(gotoSchedule), name: Notification.Name.init(GO_TO_SCHEDULE), object: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  func setUpBadge(){
    let tabbar = self.tabBarController as? RAMAnimatedTabBarController
    if unreadMessageCount + notificationCount != 0 {
      tabbar?.tabBar.items![4].badgeValue = "\(unreadMessageCount + notificationCount)"
    }else{
      tabbar?.tabBar.items![4].badgeValue = nil
    }
  }

  func gotoDetail(notification:Notification){
    let dicData = notification.object as! NSDictionary
    navigationNotificaton(dicData: dicData)
  }
  func showNotification(notification:Notification){
    let userInfo = notification.object as! NSDictionary
    if let apsInfo = userInfo["aps"] as? NSDictionary{
      let dicData = apsInfo["data"] as! NSDictionary
      let alert = apsInfo["alert"] as! String
      RNNotificationView.show(withImage: UIImage(named: "Logo.png"),
                              title: "BỆNH VIỆN E",
                              message: alert,
                              duration: 2,
                              iconSize: CGSize(width: 22, height: 22), // Optional setup
        onTap: {
          self.navigationNotificaton(dicData: dicData)
      })

    }
  }
  
  func navigationNotificaton(dicData:NSDictionary){
    let type = dicData["Type"] as! String
    let parentId = dicData["ParentId"] as! String
    let notificationId = dicData["Id"] as! String
    let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
    if type == "1" || type == "3" {
      let viewController = storyBoard.instantiateViewController(withIdentifier: "QuestionDetailViewController") as! QuestionDetailViewController
      viewController.questionID = parentId
      viewController.notificationId = notificationId
      self.navigationController?.pushViewController(viewController, animated: true)
    }else{
      let viewController = storyBoard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
      viewController.commentId = parentId
      viewController.notificationId = notificationId
      self.navigationController?.pushViewController(viewController, animated: true)
    }
  }
  
  func gotoChat(notification:Notification){
    let dicData = notification.object as! NSDictionary
      var userListQuery = SBDMain.createAllUserListQuery()
      userListQuery = SBDMain.createUserListQuery(withUserIds: [dicData["id"] as! String])
      userListQuery?.limit = 25
    if userListQuery?.hasNext == false {
      return
    }
    
    userListQuery?.loadNextPage(completionHandler: { (users, error) in
      if error != nil {
        return
      }
      var selectedUser = [SBDUser]()
      for user in users! as [SBDUser] {
        selectedUser.append(user)
      }
      SBDGroupChannel.createChannel(with: selectedUser, isDistinct: true) { (channel, error) in
        if error != nil {
          return
        }
        DispatchQueue.main.async {
          let vc = GroupChannelChattingViewController()
          vc.groupChannel = channel
          self.present(vc, animated: false, completion: nil)
        }
      }
    })
  }
  
  func gotoSchedule(){
    let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
    let viewController = storyBoard.instantiateViewController(withIdentifier: "ExamScheduleViewController") as! ExamScheduleViewController
    self.navigationController?.pushViewController(viewController, animated: true)
  }
}
