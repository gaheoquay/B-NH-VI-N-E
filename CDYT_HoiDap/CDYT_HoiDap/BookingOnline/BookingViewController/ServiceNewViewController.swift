//
//  ServiceNewViewController.swift
//  CDYT_HoiDap
//
//  Created by Quang Anh on 8/2/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class ServiceNewViewController: UIViewController {

    @IBOutlet weak var tbService: UITableView!
    
    var arrayName: [String] = ["Vu Quang Anh","Developer","IOS","Ha Noi","aaa","bbb","ccc"]
    var arrayPrice: [Int] = [1000,2000,3000,4000,1111,1111,1111]
    var totalPrice = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbService.estimatedRowHeight = 999
        tbService.rowHeight = UITableViewAutomaticDimension
        for a in arrayPrice {
            totalPrice = totalPrice + a
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnDeleteService(_ sender: Any) {

    }
}

extension ServiceNewViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayName.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellHeader = tableView.dequeueReusableCell(withIdentifier: "HeaderCellService") as! HeaderCellService
        let cellService = tableView.dequeueReusableCell(withIdentifier: "ServiceTbCell") as! ServiceTbCell
        switch indexPath.row {
        case 0:
            return cellHeader
        default:
            cellService.lbServiceName.text = arrayName[indexPath.row - 1]
            cellService.lbPrice.text = String(arrayPrice[indexPath.row - 1])
            return cellService
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cellFooter = tableView.dequeueReusableCell(withIdentifier: "FooterServiceCell") as! FooterServiceCell
        cellFooter.lbTotalService.text = "Tổng dịch vụ được chọn : \(arrayName.count)"
        cellFooter.totalPrice.text = String(totalPrice)
        return cellFooter
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
}
