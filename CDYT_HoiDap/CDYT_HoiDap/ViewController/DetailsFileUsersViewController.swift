//
//  DetailsFileUsersViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 28/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class DetailsFileUsersViewController: UIViewController {
    
    @IBOutlet weak var lbBillCode: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbHistoryCode: UILabel!
    @IBOutlet weak var lbNumberWait: UILabel!
    @IBOutlet weak var lbAdress: UILabel!
    @IBOutlet weak var lbSickName: UILabel!
    @IBOutlet weak var lbProvisionalPrice: UILabel!
    @IBOutlet weak var lbExamDate: UILabel!
    @IBOutlet weak var lbName: UILabel!
    
    var listCheckin = CheckInResultEntity()
    var listService = ServiceEntity()
    var name = ""
    var dateExam: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        registerNotification()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    func setupView(){
        lbName.text = name
        lbHistoryCode.text = String(listCheckin.patientHistory)
        lbNumberWait.text = String(listCheckin.sequence)
        lbAdress.text = listService.roomName
        lbSickName.text = listService.name
        lbSickName.text = String(listService.priceService)
        lbExamDate.text = String().convertTimeStampWithDateFormat(timeStamp: dateExam, dateFormat: "dd/MM/YYYY")
    }
    
    func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(setDataListService(notification:)), name: NSNotification.Name(rawValue: GET_LIST_SERVICE), object: nil)
    }
    //MARK: Notificaiton
    func setDataListService(notification : Notification){
        if notification.object != nil {
            let listServ = notification.object as! ServiceEntity
            listService = listServ
        }
    }
    
}
