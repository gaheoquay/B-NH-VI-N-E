//
//  BookingCalenderController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 23/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit
protocol BookingCalenderControllerDelegate {
    func gotoService()
    func gotoFile()
}

class BookingCalenderController: UIViewController,FSCalendarDataSource,FSCalendarDelegate {

   
    @IBOutlet weak var btnSendBooking: UIButton!
    @IBOutlet weak var btnService: UIButton!
    @IBOutlet weak var btnBrifUser: UIButton!
    
    var listService = ServiceEntity()
    var listFileUser = FileUserEntity()
    
    var timeStamp: Double = 0
    var delegate: BookingCalenderControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnService.layer.borderWidth = 0
        btnBrifUser.layer.borderWidth = 0
        btnSendBooking.layer.cornerRadius = 5
        btnSendBooking.clipsToBounds = true
        registerNotification()
        // Do any additional setup after loading the view.
    }
    
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapService(_ sender: Any) {
        delegate?.gotoService()
    }
    @IBAction func btnSelectFileUser(_ sender: Any) {
        delegate?.gotoFile()
    }
    
    @IBAction func btnSendBooking(_ sender: Any) {
        requestBoking()
    }
    
    
    func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(setDataListService(notification:)), name: NSNotification.Name(rawValue: GET_LIST_SERVICE), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDataFileUser(notification:)), name: NSNotification.Name(rawValue: GET_LIST_FILE_USER), object: nil)
    }
    //MARK: Notificaiton
    func setDataListService(notification : Notification){
        if notification.object != nil {
            let listServ = notification.object as! ServiceEntity
            listService = listServ
            btnService.setTitle(listServ.name, for: .normal)
        }
    }
    func setDataFileUser(notification: Notification){
        if notification.object != nil {
            let fileUser = notification.object as! FileUserEntity
            listFileUser = fileUser
            btnBrifUser.setTitle(fileUser.patientName, for: .normal)
        }
    }
    //MARK: SetupDate
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            print("calendar did select date \(String().convertDatetoString(date: date, dateFormat: "dd/MM/YYYY"))")
            timeStamp = date.timeIntervalSince1970
            print(timeStamp)
            if monthPosition == .previous || monthPosition == .next {
                calendar.setCurrentPage(date, animated: true)
            }
        }
    //MARK: request Api
    func requestBoking(){
        let param : [String : Any] = [
            "serviceId" : listService.serviceId,
            "serName" : listService.name,
            "date" : timeStamp,
            "idUSer" : listFileUser.id,
            "nameUser" : listFileUser.patientName
        ]
        
        print(param)
        
    }
    
}
