//
//  BookingViewController.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 2/17/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit


class BookingViewController: BaseViewController, CAPSPageMenuDelegate,BookingCalenderControllerDelegate,ManagerViewControllerDelegate,WYPopoverControllerDelegate,ListServiceViewControllerDelegate,SearchFileViewControllerDelegate {
    var pageMenu : CAPSPageMenu?

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var labelBook: UILabel!
    @IBOutlet weak var labelManager: UILabel!
    @IBOutlet weak var withLabelBooking: NSLayoutConstraint!
  
  lazy var listService = [ServiceEntity]()
    var popupViewController:WYPopoverController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      requestListService()
        addPagingMenu()
        withLabelBooking.constant = UIScreen.main.bounds.size.width / 2
        labelManager.isHidden = true
        // Do any additional setup after loading the view.
    }
//    MARK: ADDING PAGE MENU
    func addPagingMenu() {
        // Array to keep track of controllers in page menu
        var controllerArray : [UIViewController] = []
        
        let controllerBooking  = self.storyboard!.instantiateViewController(withIdentifier: "BookingCalenderController") as! BookingCalenderController
        controllerBooking.delegate = self
        controllerBooking.title = "Booking"
        
        let controllerManager = self.storyboard!.instantiateViewController(withIdentifier: "ManagerViewController") as! ManagerViewController
        controllerManager.delegate = self
        controllerManager.title = "Manager"
        
        controllerArray.append(controllerBooking)
        controllerArray.append(controllerManager)
        
        let menuWidth: CGFloat = 50
        
       
        let parameters: [CAPSPageMenuOption] = [
            .selectedMenuItemLabelColor(UIColor.white),
            .menuItemSeparatorWidth(0.5),
            .menuItemSeparatorColor(UIColor.black),
            .selectionIndicatorHeight(5),
            .addBottomMenuHairline(false),
            .menuItemFont(UIFont.boldSystemFont(ofSize: 13)),
            .menuHeight(0),
            .menuItemWidth(menuWidth),
            .enableHorizontalBounce(false),
            ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.viewMain.frame.size.width, height: self.viewMain.frame.size.height), pageMenuOptions: parameters)
        
        pageMenu!.delegate = self
        
        self.viewMain.addSubview(pageMenu!.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//  MARK: GET LIST SERVICE
  func requestListService(){
      Alamofire.request(BOOKING_GET_LIST_SERVICE, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
        if let status = response.response?.statusCode {
          if status == 200{
            if let result = response.result.value {
              let jsonData = result as! [NSDictionary]
              
              for item in jsonData {
                let entity = ServiceEntity.init(dictionary: item)
                self.listService.append(entity)
              }
            }
          }else{
            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
          }
        }else{
          UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
        }
      }
  }
//   MARK: ACTION
    @IBAction func tapBookCalender(_ sender: Any) {
        labelManager.isHidden = true
        labelBook.isHidden = false
        pageMenu?.moveToPage(0)
    }
    
    @IBAction func tapManager(_ sender: Any) {
        pageMenu?.moveToPage(1)
        labelBook.isHidden = true
        labelManager.isHidden = false
    }
    
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        if index == 0 {
            labelManager.isHidden = true
            labelBook.isHidden = false
        }else {
            labelBook.isHidden = true
            labelManager.isHidden = false
        }
        self.view.layoutIfNeeded()
    }
    //MARK: Delegate
    func gotoService() {
        if popupViewController == nil {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let popoverVC = mainStoryboard.instantiateViewController(withIdentifier: "ListServiceViewController") as! ListServiceViewController
            popoverVC.preferredContentSize = CGSize.init(width: UIScreen.main.bounds.size.width - 32, height: UIScreen.main.bounds.size.height - 120 )
            popoverVC.isModalInPopover = false
          popoverVC.listService = self.listService
            popoverVC.delegate = self
            self.popupViewController = WYPopoverController(contentViewController: popoverVC)
            self.popupViewController.delegate = self
            self.popupViewController.wantsDefaultContentAppearance = false;
            self.popupViewController.presentPopover(from: CGRect.init(x: 0, y: 0, width: 0, height: 0), in: self.view, permittedArrowDirections: WYPopoverArrowDirection.none, animated: true, options: WYPopoverAnimationOptions.fadeWithScale, completion: nil)
            
        }
       
    }
    func popoverControllerDidDismissPopover(_ popoverController: WYPopoverController!) {
        if popupViewController != nil {
            popupViewController.delegate = nil
            popupViewController = nil
        }
    }
    

    func gotoCalendar() {
        if Until.getCurrentId().isEmpty {
            Until.gotoLogin(_self: self, cannotBack: true)
        }else{
        let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "ExamScheduleViewController") as! ExamScheduleViewController
      viewcontroller.listService = listService
        self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
    }
    func gotoHistory() {
//        let main = UIStoryboard(name: "Main", bundle: nil)
//        let viewcontroller = main.instantiateViewController(withIdentifier: "HistoryUserViewController") as! HistoryUserViewController
//        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    func gotoCvUser() {
        
        if Until.getCurrentId().isEmpty {
            Until.gotoLogin(_self: self, cannotBack: true)
        }else{
            let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "FileViewController")
            self.navigationController?.pushViewController(viewcontroller!, animated: true)
        }

    }
    
    func gotoFile() {
        if Until.getCurrentId().isEmpty {
            Until.gotoLogin(_self: self, cannotBack: true)
        }else{
            let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "SearchFileViewController") as! SearchFileViewController
            viewcontroller.delegate = self
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }

    }
    
    func dissMisPopup() {
        if popupViewController != nil {
            popupViewController.delegate = nil
            popupViewController = nil
        }else {
            popupViewController.dismissPopover(animated: true)
        }
    }
    
    func gotoBooking() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Calendar
    
    
   
}
