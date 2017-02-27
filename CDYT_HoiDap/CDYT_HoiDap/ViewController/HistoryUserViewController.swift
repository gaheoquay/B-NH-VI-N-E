//
//  HistoryUserViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 26/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class HistoryUserViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tbListHistory: UITableView!
    @IBOutlet weak var heightTbListHistory: NSLayoutConstraint!
    @IBOutlet weak var imgCV: UIImageView!
    @IBOutlet weak var lbCV: UILabel!
    
     var arrayPrice =  [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        for a in 1...20 {
//            arrayPrice.append(a)
//        }
        setupTable()
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
        return arrayPrice.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell") as! FileCell
        if arrayPrice.count > 0 {
        cell.lbName.text = String(arrayPrice[indexPath.row])
        cell.lbPrice.text = String(arrayPrice[indexPath.row])
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("abc")
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func setupTable(){
        
        if arrayPrice.count > 0 {
            tbListHistory.register(UINib.init(nibName: "FileCell", bundle: nil), forCellReuseIdentifier: "FileCell")
            heightTbListHistory.constant = UIScreen.main.bounds.size.height - 185
            tbListHistory.estimatedRowHeight = 9999
            tbListHistory.rowHeight = UITableViewAutomaticDimension
            tbListHistory.delegate = self
            tbListHistory.dataSource = self
            tbListHistory.isHidden = false
            lbCV.isHidden = true
            imgCV.isHidden = true
        }else {
            heightTbListHistory.constant = 0
            tbListHistory.estimatedRowHeight = 0
            tbListHistory.rowHeight = UITableViewAutomaticDimension
            tbListHistory.isHidden = true
            lbCV.isHidden = false
            imgCV.isHidden = false
        }
        self.view.layoutIfNeeded()
    }
   
}
