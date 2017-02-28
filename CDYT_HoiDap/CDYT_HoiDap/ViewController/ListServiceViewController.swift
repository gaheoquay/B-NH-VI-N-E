//
//  ListServiceViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 24/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit
protocol ListServiceViewControllerDelegate {
    func dissMisPopup()
}


class ListServiceViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,FileCellDelegate {
    
    @IBOutlet weak var tbListService: UITableView!
    
    var listService = [ServiceEntity]()
    var delegate: ListServiceViewControllerDelegate?
    
    var indexPath = IndexPath()

    override func viewDidLoad() {
        super.viewDidLoad()
        tbListService.register(UINib.init(nibName: "FileCell", bundle: nil), forCellReuseIdentifier: "FileCell")
        tbListService.estimatedRowHeight = 9999
        tbListService.rowHeight = UITableViewAutomaticDimension
        requestListService()
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
        return listService.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell") as! FileCell
        cell.setData(entity: listService[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("name:\(listService[indexPath.row].name),price\(listService[indexPath.row].priceService)")
        delegate?.dissMisPopup()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: GET_LIST_SERVICE), object: self.listService[indexPath.row])

    }
    
    func requestListService(){
        listService = ServiceEntity().initListCountry()
    }
    
    
    func setupButton() {
        
    }
    
    func gotoDetailFileUser() {
        
    }
    
    func deleteFileUser() {
        
    }

}
