//
//  BookingViewController.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 2/17/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class BookingViewController: BaseViewController, CAPSPageMenuDelegate,BookingCalenderControllerDelegate,ManagerViewControllerDelegate {
    var pageMenu : CAPSPageMenu?

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var labelBook: UILabel!
    @IBOutlet weak var labelManager: UILabel!
    @IBOutlet weak var withLabelBooking: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPagingMenu()
        withLabelBooking.constant = UIScreen.main.bounds.size.width / 2
        labelManager.isHidden = true
        
        
        // Do any additional setup after loading the view.
    }
    
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
    
    func gotoService() {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller = main.instantiateViewController(withIdentifier: "ChoiceServiceViewController") as! ChoiceServiceViewController
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    func gotoCalendar() {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller = main.instantiateViewController(withIdentifier: "ExamScheduleViewController") as! ExamScheduleViewController
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    func gotoHistory() {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller = main.instantiateViewController(withIdentifier: "HistoryUserViewController") as! HistoryUserViewController
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    func gotoCvUser() {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller = main.instantiateViewController(withIdentifier: "FileViewController") as! FileViewController
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }

   
}
