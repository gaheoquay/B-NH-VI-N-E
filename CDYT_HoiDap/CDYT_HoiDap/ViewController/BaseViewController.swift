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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
          print("Did tap notification")
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
