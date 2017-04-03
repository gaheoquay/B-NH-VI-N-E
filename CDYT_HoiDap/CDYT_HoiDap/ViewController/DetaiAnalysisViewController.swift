//
//  DetaiAnalysisViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 26/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class DetaiAnalysisViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var lbPantentHistory: UILabel!
    @IBOutlet weak var imgBarcode: UIImageView!
    @IBOutlet weak var tbListAnalysisCode: UITableView!
    @IBOutlet weak var lbTotalPrice: UILabel!
    @IBOutlet weak var lbSurCharge: UILabel!
    @IBOutlet weak var lbAdress: UILabel!
    @IBOutlet weak var tbListService: UITableView!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbHour: UILabel!
    @IBOutlet weak var heightTbService: NSLayoutConstraint!
    @IBOutlet weak var heightTbAnalysis: NSLayoutConstraint!
    @IBOutlet weak var heightViewTop: NSLayoutConstraint!
    @IBOutlet weak var viewTop: UIView!
    
    var listServices = [ServicesEntity]()       // Kham tai nha and xet nghiem
    var listPack = [PackEntity]()
    var booKing = BookingEntity()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        tbListService.register(UINib.init(nibName: "ServiceCell", bundle: nil), forCellReuseIdentifier: "ServiceCell")
        tbListService.delegate = self
        tbListService.dataSource = self
        heightTbService.constant = CGFloat(60 * (listPack.count + listServices.count) - 2)
        lbDate.text = String().convertTimeStampWithDateFormat(timeStamp: booKing.bookingDate / 1000, dateFormat: "dd/MM/YYYY")
        lbHour.text = String().convertTimeStampWithDateFormat(timeStamp: booKing.bookingDate / 1000, dateFormat: "hh:mm a")
        viewTop.isHidden = true
        heightViewTop.constant = 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return listPack.count
        }else {
            return listServices.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell") as! ServiceCell
        if indexPath.section == 0 {
            if listPack.count > 0 {
                cell.setDataPac(entity: listPack[indexPath.row])
            }
        }else {
            if listServices.count > 0 {
                cell.setDataSer(entity: listServices[indexPath.row])
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    

}
