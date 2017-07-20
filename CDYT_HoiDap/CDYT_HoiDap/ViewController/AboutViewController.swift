//
//  AboutViewController.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 2/20/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class AboutViewController: BaseViewController,CAPSPageMenuDelegate,ListDoctorViewControllerDelegate {
    
    @IBOutlet weak var viewAboutHospital: UIView!
    @IBOutlet weak var viewListDoctor: UIView!
    @IBOutlet weak var viewMain: UIView!
    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPagingMenu()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    //#MARK: - Setup Paging menu
    func addPagingMenu() {
        // Array to keep track of controllers in page menu
        var controllerArray : [UIViewController] = []
        
        let controller1  = self.storyboard!.instantiateViewController(withIdentifier: "DescriptionViewController") as! DescriptionViewController
        
        let controller2 = self.storyboard!.instantiateViewController(withIdentifier: "ListDoctorViewController") as! ListDoctorViewController
        controller2.delegate = self
        
        controllerArray.append(controller1)
        controllerArray.append(controller2)
        
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
    //  MARK: page menu delegate
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        if index == 0 {
            viewListDoctor.backgroundColor = UIColor.white
            viewAboutHospital.backgroundColor = UIColor.init(netHex: 0xf0f1f2)
        }else{
            viewAboutHospital.backgroundColor = UIColor.white
            viewListDoctor.backgroundColor = UIColor.init(netHex: 0xf0f1f2)
        }
    }
    
    @IBAction func gotoAbout(_ sender: Any) {
        viewListDoctor.backgroundColor = UIColor.white
        viewAboutHospital.backgroundColor = UIColor.init(netHex: 0xf0f1f2)
        pageMenu?.moveToPage(0)
    }
    @IBAction func gotoListDoctor(_ sender: Any) {
        viewAboutHospital.backgroundColor = UIColor.white
        viewListDoctor.backgroundColor = UIColor.init(netHex: 0xf0f1f2)
        pageMenu?.moveToPage(1)
    }
    
    //  MARK: ListDoctorViewControllerDelegate
    func gotoProfile(authorEntity: AuthorEntity) {
        let storyBoard = UIStoryboard.init(name: "User", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "OtherUserViewController") as! OtherUserViewController
        viewController.user = authorEntity
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
