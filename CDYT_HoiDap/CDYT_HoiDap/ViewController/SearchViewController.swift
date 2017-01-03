//
//  SearchViewController.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 1/3/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
      setUpTableView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  @IBAction func searching(_ sender: Any) {
    listSearch.removeAll()
    timer.invalidate()
    let searchText = txtSearch.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    if searchText.isEmpty {
      isShowFooter = false
      tbResult.reloadData()
    }else{
      isShowFooter = true
      timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(requestData), userInfo: nil, repeats: false)
    }
  }
//  MARK: request data
  func requestData(){
    let param : [String : Any] = [
      "Auth": Until.getAuthKey(),
      "Page": 1,
      "Size": 5,
      "SearchString" : txtSearch.text!
    ]
    Until.showLoading()
    Alamofire.request(SEARCH, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
      if let status = response.response?.statusCode {
        
        if status == 200{
          if let result = response.result.value {
            let jsonData = result as! [NSDictionary]
            
            for item in jsonData {
              let entity = PostEntity.init(dictionary: item)
              self.listSearch.append(entity)
            }
            self.tbResult.reloadData()
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
//  MARK: setup table
  func setUpTableView(){
    tbResult.delegate = self
    tbResult.dataSource = self
    tbResult.register(UINib.init(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
  }
  //MARK:UITableViewDelegate,UITableViewDataSource
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return isShowFooter ? listSearch.count + 1 : 0
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as! SearchTableViewCell
    if indexPath.row == listSearch.count {
      cell.setData(result: "", isAsk: true)
    }else{
      cell.setData(result: listSearch[indexPath.row].title, isAsk: false)
    }
    return cell
  }
//  MARK: Outlet
  @IBOutlet weak var txtSearch: UITextField!
  @IBOutlet weak var tbResult: UITableView!
  var listSearch = [PostEntity]()
  var timer = Timer()
  var isShowFooter = false
		
}
