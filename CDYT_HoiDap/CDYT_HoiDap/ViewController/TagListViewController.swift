//
//  TagListViewController.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 12/26/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class TagListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tagTableView: UITableView!
    var userEntity = UserEntity()
    var listHotTag = [HotTagEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tagTableView.delegate = self
        tagTableView.dataSource = self
        tagTableView.estimatedRowHeight = 200
        tagTableView.rowHeight = UITableViewAutomaticDimension
        tagTableView.register(UINib.init(nibName: "QuestionTagTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTagTableViewCell")
        tagTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)

        getHotTagFromServer()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listHotTag.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTagTableViewCell") as! QuestionTagTableViewCell
        cell.hotTag = listHotTag[indexPath.row]
        cell.setData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func getHotTagFromServer(){
        let realm = try! Realm()
        let users = realm.objects(UserEntity.self)
        if users.count > 0 {
            userEntity = users.first!
            
        }
        
        let hotParam : [String : Any] = [
            "Auth": Until.getAuthKey(),
            "Page": 1,
            "Size": 10,
            "RequestedUserId" : userEntity.id
        ]
        
        print(JSON.init(hotParam))
        
        Until.showLoading()
        Alamofire.request(HOTEST_TAG, method: .post, parameters: hotParam, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                if status == 200{
                    if let result = response.result.value {
                        let jsonData = result as! [NSDictionary]
                        
                        for item in jsonData {
                            let hotTag = HotTagEntity.init(dictionary: item)
                            self.listHotTag.append(hotTag)
                        }
                        
                        self.tagTableView.reloadData()
                        
                    }
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }else{
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
            }
            Until.hideLoading()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
