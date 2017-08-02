//
//  PageMeunuViewController.swift
//  CDYT_HoiDap
//
//  Created by Quang Anh on 8/2/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class PageMeunuViewController: UIViewController {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewLineBooking: UIView!
    @IBOutlet weak var viewLineSetting: UIView!
    var pageMenu : CAPSPageMenu?

    override func viewDidLoad() {
        super.viewDidLoad()
        addPagingMenu()
        viewLineSetting.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBooking(_ sender: Any) {
        setupPageMenu(index: 0)
        pageMenu?.moveToPage(0)
    }
    
    @IBAction func btnSetting(_ sender: Any) {
        setupPageMenu(index: 1)
        pageMenu?.moveToPage(1)
    }
    
    func setupPageMenu(index: Int){
        if index == 0 {
            viewLineBooking.isHidden = false
            viewLineSetting.isHidden = true
        }else {
            viewLineBooking.isHidden = true
            viewLineSetting.isHidden = false
        }
    }
    
    func pushViewController(identifier: String){
        let viewController = storyboard?.instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
}

extension PageMeunuViewController: CAPSPageMenuDelegate {
    func addPagingMenu() {
        // Array to keep track of controllers in page menu
        var controllerArray : [UIViewController] = []
        
        let controller1  = self.storyboard!.instantiateViewController(withIdentifier: "HomeBookingViewController") as! HomeBookingViewController
        controller1.pushView = { (identifier) -> Void in
            self.pushViewController(identifier: identifier)
        }
        
        let controller2 = self.storyboard!.instantiateViewController(withIdentifier: "SettingBookingViewController") as! SettingBookingViewController
        
        controllerArray.append(controller1)
        controllerArray.append(controller2)
        
        let parameters: [CAPSPageMenuOption] = [
            .selectedMenuItemLabelColor(UIColor.white),
            .menuItemSeparatorWidth(0.5),
            .menuItemSeparatorColor(UIColor.black),
            .selectionIndicatorHeight(5),
            .addBottomMenuHairline(false),
            .menuItemFont(UIFont.boldSystemFont(ofSize: 13)),
            .menuHeight(0),
            .enableHorizontalBounce(false),
            ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.viewMain.frame.size.width, height: self.viewMain.frame.size.height), pageMenuOptions: parameters)
        
        pageMenu!.delegate = self
        self.viewMain.addSubview(pageMenu!.view)
    }
    
    //  MARK: page menu delegate
    func didMoveToPage(_ controller: UIViewController, index: Int) {
       setupPageMenu(index: index)
    }
    

}
