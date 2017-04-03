//
//  BookingViewController.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 2/17/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit


class BookingViewController: BaseViewController, CAPSPageMenuDelegate,BookingCalenderControllerDelegate,ManagerViewControllerDelegate,WYPopoverControllerDelegate,ListServiceViewControllerDelegate {
    var pageMenu : CAPSPageMenu?
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var withLabelBooking: NSLayoutConstraint!
    @IBOutlet weak var imgBooking: UIImageView!
    @IBOutlet weak var imgManager: UIImageView!
    
    lazy var listService = [ServiceEntity]()
    var popupViewController:WYPopoverController!
    
    var listServices = [ServicesEntity]()       // Kham tai nha and xet nghiem
    var listPack = [PackagesEntity]()
    var service = PackServiceEntity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestListService()
        addPagingMenu()
        withLabelBooking.constant = UIScreen.main.bounds.size.width / 2
        registerNotification()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        imgBooking.image = UIImage.init(named: "tab1.png")
        imgManager.isHidden = true
        imgBooking.isHidden = false
        pageMenu?.moveToPage(0)
    }
    
    @IBAction func tapManager(_ sender: Any) {
        pageMenu?.moveToPage(1)
        imgManager.image = UIImage.init(named: "tab1.png")
        imgBooking.isHidden = true
        imgManager.isHidden = false
    }
    
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        if index == 0 {
            imgManager.isHidden = true
            imgBooking.isHidden = false
        }else {
            imgBooking.isHidden = true
            imgManager.isHidden = false
        }
        self.view.layoutIfNeeded()
    }
    //MARK: Delegate
    func gotoService(status: Int) {
        if status == 0 {
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
        }else {
            let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "ExamInHomeViewController") as! ExamInHomeViewController
            viewcontroller.listPacKage = self.listPack
            viewcontroller.listService = self.listServices
            viewcontroller.service = self.service
            self.navigationController?.pushViewController(viewcontroller, animated: true)
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
        let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "HistoryUserViewController") as! HistoryUserViewController
        self.navigationController?.pushViewController(viewcontroller, animated: true)
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
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
        
    }
    
    func dissMisPopup() {
        popupViewController.dismissPopover(animated: true)
        popupViewController.delegate = nil
        popupViewController = nil
    }
    
    func gotoExamSchudel() {
        let alert = UIAlertController(title: "Thông Báo", message: "Gửi lịch đặt khám thành công. Bạn cần xác nhận lại khi đến ngày đặt", preferredStyle: .alert)
        let arletAction = UIAlertAction(title: "Xem", style: .cancel) { (UIAlertAction) in
            let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "ExamScheduleViewController") as! ExamScheduleViewController
            viewcontroller.listService = self.listService
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
        alert.addAction(arletAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func gotoExamSchudelCheckin() {
        let alert = UIAlertController(title: "Thông Báo", message: "Đăng ký khám thành công", preferredStyle: .alert)
        let arletAction = UIAlertAction(title: "Xem", style: .cancel) { (UIAlertAction) in
            let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "ExamScheduleViewController") as! ExamScheduleViewController
            viewcontroller.listService = self.listService
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
        alert.addAction(arletAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func gotoExamSchudelAtHome() {
        let alert = UIAlertController(title: "Thông Báo", message: "Gửi lịch thành công \n Chúng tối sẽ gọi lại cho bạn\n để xác nhận ", preferredStyle: .alert)
        let arletAction = UIAlertAction(title: "Xem", style: .cancel) { (UIAlertAction) in
            let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "ExamScheduleViewController") as! ExamScheduleViewController
            viewcontroller.listService = self.listService
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
        alert.addAction(arletAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(setDataListSer(notification:)), name: NSNotification.Name(rawValue: GET_LIST_SERIVCE_IN_HOME), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDataListPac(notification:)), name: NSNotification.Name(rawValue: GET_LIST_PACKAGE_IN_HOME), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setServices(notification:)), name: NSNotification.Name(rawValue: GET_SERVICES), object: nil)
    }
    
    func setDataListSer(notification: Notification){
        if notification.object != nil {
            let listSer = notification.object as! [ServicesEntity]
            self.listServices = listSer
            
        }
    }
    
    func setServices(notification: Notification){
        if notification.object != nil {
            let services = notification.object as! PackServiceEntity
            self.service = services
            
        }
    }
    
    func setDataListPac(notification: Notification){
        if notification.object != nil {
            let listPacks = notification.object as! [PackagesEntity]
            self.listPack = listPacks
            
        }
        
    }
    
    
    
    
}
