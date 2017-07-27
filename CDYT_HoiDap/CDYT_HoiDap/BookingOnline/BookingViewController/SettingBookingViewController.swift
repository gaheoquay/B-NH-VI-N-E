//
//  SettingBookingViewController.swift
//  CDYT_HoiDap
//
//  Created by Quang anh Vu on 7/25/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class SettingBookingViewController: UIViewController {

    @IBOutlet weak var tbListSetting: UITableView!
    var arrayTitle = ["Lịch khám/ xét nghiệm","Kết quả khám","Hồ sơ khám bệnh"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gotoDetailSetting(indentifier: String){
        let viewcontroller = storyboard?.instantiateViewController(withIdentifier: indentifier)
        viewcontroller?.show(viewcontroller!, sender: nil)
    }
    
}
extension SettingBookingViewController: UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayTitle.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.gotoDetailSetting(indentifier: "")
        case 1:
            self.gotoDetailSetting(indentifier: "")
        default:
            self.gotoDetailSetting(indentifier: "")
        }
    }
}
