//
//  ChoiceServiceViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 24/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class ChoiceServiceViewController: UIViewController,WYPopoverControllerDelegate,UITableViewDataSource,UITableViewDelegate,ListServiceViewControllerDelegate {

    var popupViewController:WYPopoverController!
    @IBOutlet weak var tbListService: UITableView!
    @IBOutlet weak var viewTopbar: UIView!
    @IBOutlet weak var lbSumPrice: UILabel!
    
    var selectedIndex = -1

    
    //test
    let arrayName = ["abasdqdcsdfdfc","asdasdsadsadsadvcvsdf"]
    let arrayPrice =  [10000,20000]
    var sumPrice = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTopbar()
        for price in arrayPrice {
            sumPrice = sumPrice + price
        }
        tbListService.register(UINib.init(nibName: "FileCell", bundle: nil), forCellReuseIdentifier: "FileCell")
        tbListService.delegate = self
        tbListService.dataSource = self
        tbListService.estimatedRowHeight = 9999
        tbListService.rowHeight = UITableViewAutomaticDimension
//        setUpSumPrice()
                // Do any additional setup after loading the view.
    }
    
 
    
    func popoverControllerDidDismissPopover(_ popoverController: WYPopoverController!) {
        if popupViewController != nil {
            popupViewController.delegate = nil
            popupViewController = nil
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapExit(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func tapInsertService(_ sender: Any) {
        if popupViewController == nil {
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let popoverVC = mainStoryboard.instantiateViewController(withIdentifier: "ListServiceViewController") as! ListServiceViewController
            popoverVC.preferredContentSize = CGSize.init(width: tbListService.frame.size.width - 16, height: tbListService.frame.size.height - 16 )
            popoverVC.isModalInPopover = false
            popoverVC.delegate = self
            self.popupViewController = WYPopoverController(contentViewController: popoverVC)
            self.popupViewController.delegate = self
            self.popupViewController.wantsDefaultContentAppearance = false;
            self.popupViewController.presentPopover(from: CGRect.init(x: 0, y: 0, width: 0, height: 0), in: self.view, permittedArrowDirections: WYPopoverArrowDirection.none, animated: true, options: WYPopoverAnimationOptions.fadeWithScale, completion: nil)
            
        }

    }
    func setUpTopbar(){
        viewTopbar.layer.borderWidth = 0.5
        viewTopbar.layer.borderColor = UIColor.gray.cgColor
        viewTopbar.layer.cornerRadius = 4
    }
    
 
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell") as! FileCell
        cell.lbName.text = arrayName[indexPath.row]
        cell.checkService(isCheckService: false)
        return cell
    }
    
    
        
    func setUpSumPrice(){
        let fontBold = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)]
        let fontRegular = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
        let fontWithColor = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),NSForegroundColorAttributeName: UIColor.green]
        let myAttrString = NSMutableAttributedString(string: "\(arrayPrice.count) ", attributes: fontBold)
        myAttrString.append(NSAttributedString(string: "dịch vụ được trọn \n Tổng tiền tạm tính : ", attributes: fontRegular))
        myAttrString.append(NSAttributedString(string: "\(sumPrice)đ", attributes: fontWithColor))
        lbSumPrice.attributedText = myAttrString

    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func gotoListChoiceService() {
        popupViewController.dismissPopover(animated: true)
    }
    
   
}
