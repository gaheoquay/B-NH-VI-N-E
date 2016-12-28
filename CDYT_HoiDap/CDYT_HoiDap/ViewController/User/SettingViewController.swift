//
//  SettingViewController.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/28/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var settingTbl: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingTbl.dataSource = self
        settingTbl.delegate = self
        settingTbl.estimatedRowHeight = 200
        settingTbl.rowHeight = UITableViewAutomaticDimension
        settingTbl.register(UINib.init(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCell")
        settingTbl.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell") as! SettingTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.titleLbl.text = "Nâng cấp"
        case 1:
            cell.titleLbl.text = "Chính sách riêng tư"
        case 2:
            cell.titleLbl.text = "Điều khoản sử dụng"
        case 3:
            cell.titleLbl.text = "Đánh giá ứng dụng"
        case 4:
            cell.titleLbl.text = "Góp ý báo lỗi"
        case 5:
            cell.titleLbl.text = "Chia sẻ cho bạn bè"
        case 6:
            cell.titleLbl.text = "Phiên bản"
        default:
            cell.titleLbl.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("Nâng cấp")
        case 1:
            print("Chính sách riêng tư")
        case 2:
            print("Điều khoản sử dụng")
        case 3:
            print("Đánh giá ứng dụng")
        case 4:
            print("Góp ý báo lỗi")
        case 5:
            print("Chia sẻ cho bạn bè")
        case 6:
            print("Phiên bản")
        default:
            print("")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backTapAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func logoutTapAction(_ sender: Any) {
        let realm = try! Realm()
        let user = realm.objects(UserEntity.self)
        try! realm.write {
            realm.delete(user)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
