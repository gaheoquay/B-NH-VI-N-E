//
//  ResultsViewController.swift
//  CDYT_HoiDap
//
//  Created by Quang anh Vu on 4/17/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbPantienHistory: UILabel!
    @IBOutlet weak var tbListGroupId: UITableView!
    
    var booKing = BookingEntity()
    var listDetailBooKing = AllUserEntity()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestBookingDetail()
        // Do any additional setup after loading the view.
    }
    
    func setupUi(){
        tbListGroupId.delegate = self
        tbListGroupId.dataSource = self
        tbListGroupId.estimatedRowHeight = 999
        tbListGroupId.rowHeight = UITableViewAutomaticDimension
        tbListGroupId.register(UINib.init(nibName: "CodeFormAnalysisCell", bundle: nil), forCellReuseIdentifier: "CodeFormAnalysisCell")
        lbPantienHistory.text = String(listDetailBooKing.patientHistory.hisPatientHistoryID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    func requestBookingDetail(){
        let Param : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "BookingRecordId" : booKing.id
        ]
        print(Param)
        Until.showLoading()
        Alamofire.request(GET_BOOKING_RECORD, method: .post, parameters: Param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        self.listDetailBooKing = AllUserEntity.init(dictionary: jsonData)
                    }
                    
                }else{
                }
            }
            else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
            self.setupUi()
            Until.hideLoading()
        }
    }
}

extension ResultsViewController : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDetailBooKing.listMedicalGroups.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CodeFormAnalysisCell") as! CodeFormAnalysisCell
        cell.setDataResult(entity: listDetailBooKing.listMedicalGroups[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "DetailAnalysisFormViewController") as! DetailAnalysisFormViewController
        viewcontroller.medicalGroups = listDetailBooKing.listMedicalGroups[indexPath.row]
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    
}
