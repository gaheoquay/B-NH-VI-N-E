//
//  ListServiceViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 24/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit
protocol ListServiceViewControllerDelegate {
    func gotoListChoiceService()
}

class ListServiceViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tbListService: UITableView!
    
    let arrayName = ["abasdqdcsdfdfc","asdasdsadsadsadvcvsdf"]
    let arrayPrice =  [10000,20000]
    
    var name = ""
    var price = 0
    var indexPath = IndexPath()
    var delegate: ListServiceViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tbListService.register(UINib.init(nibName: "FileCell", bundle: nil), forCellReuseIdentifier: "FileCell")
        tbListService.estimatedRowHeight = 9999
        tbListService.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayName.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell") as! FileCell
        cell.btnDelete.setImage(UIImage.init(named: "Check0-2.png"), for: .normal)
        cell.lbName.text = arrayName[indexPath.row]
        cell.lbPrice.text = String(arrayPrice[indexPath.row])
        return cell
    }
    
    @IBAction func btnDone(_ sender: Any) {
        delegate?.gotoListChoiceService()
    }
    

}
