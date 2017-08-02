//
//  HomeAnalysisViewController.swift
//  CDYT_HoiDap
//
//  Created by Quang anh Vu on 7/26/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class HomeAnalysisViewController: UIViewController {

    @IBOutlet weak var tbAnlysis: UITableView!
    var array = ["A","B","C"]
    var arrayPlacehoder = ["Họ và tên","Thời gian","Nhập số điện thoại","Nhập địa chỉ sử dụng dịch vụ"]
    var titHeader = ["Thông tin","Dịch vụ","Ghi chú"]
    var subHedaer = ["(Bắt buộc)","(Chúng tôi sẽ gọi tư vấn)",""]
    var checkShow = CheckShowName(isShow: false)
    override func viewDidLoad() {
        super.viewDidLoad()
        tbAnlysis.register(UINib.init(nibName: "CellTableInfomation", bundle: nil), forCellReuseIdentifier: "CellTableInfomation")
        tbAnlysis.estimatedRowHeight = 999
        tbAnlysis.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pushViewController(identifier: String){
        let viewcontroller = storyboard?.instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(viewcontroller!, animated: true)
    }
    
}

extension HomeAnalysisViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return titHeader.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return arrayPlacehoder.count
        case 1:
            return 1
        default:
            return 2
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2Infomation") as! Cell2Infomation
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTableInfomation") as! CellTableInfomation
        let cell3 = tableView.dequeueReusableCell(withIdentifier: "Cell3TableInfomation") as! Cell3TableInfomation
        let requestCell = tableView.dequeueReusableCell(withIdentifier: "RequestCell") as! RequestCell
        
        switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
            case 0:
                cell.setHeightViewProfile = {
                    self.checkShow.isShow = !self.checkShow.isShow
                    self.tbAnlysis.reloadRows(at: [indexPath], with: .automatic)
                }
                cell.gotoListUser = { (identifier) -> Void in
                    self.pushViewController(identifier: identifier)
                }
                cell.setData(arrayProfile: array, checShow: checkShow)
                return cell
            case 1:
                cell2.setData(plachoder: arrayPlacehoder[indexPath.row], isDate: true)
            default:
                cell2.setData(plachoder: arrayPlacehoder[indexPath.row], isDate: false)
            }
        case 1:
            cell2.setData(plachoder: "Chọn dịch vụ xét nghiệm", isDate: true)
            cell2.gotoSelectService = { (identifier) -> Void in
                self.pushViewController(identifier: identifier)
            }
        default:
            if indexPath.row == 0 {
                return cell3
            }else {
                return requestCell
            }
        }
        
        return cell2
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let frameImage = CGRect(x: 8, y: 8, width: 20, height: 20)
        let image = UIImageView(frame: frameImage)
        let labelTit = UILabel.init()
        labelTit.font = UIFont.systemFont(ofSize: 16)
        labelTit.text = titHeader[section]
        labelTit.textColor = UIColor.black
        labelTit.sizeToFit()
        
        let labelSubTit = UILabel.init()
        labelSubTit.font = UIFont.systemFont(ofSize: 12)
        labelSubTit.text = subHedaer[section]
        labelSubTit.textColor = UIColor.black
        labelSubTit.sizeToFit()

        let frameLabelTit = CGRect(x: 36, y: 8, width: labelTit.frame.size.width, height: labelTit.frame.size.height)
        let frameLabelSub = CGRect(x: 42 + labelTit.frame.size.width, y: 10, width: labelSubTit.frame.size.width, height: labelSubTit.frame.size.height)
        labelTit.frame = frameLabelTit
        labelSubTit.frame = frameLabelSub
        
        view.addSubview(image)
        view.addSubview(labelSubTit)
        view.addSubview(labelTit)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
}


