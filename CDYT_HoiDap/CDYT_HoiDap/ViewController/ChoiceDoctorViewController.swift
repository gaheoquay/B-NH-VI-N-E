//
//  ChoiceDoctorViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 14/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class ChoiceDoctorViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tbListDoctor: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupUi(){
        tbListDoctor.register(UINib.init(nibName: "DoctorCell", bundle: nil), forCellReuseIdentifier: "DoctorCell")
        tbListDoctor.estimatedRowHeight = 9999
        tbListDoctor.rowHeight = UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorCell") as! DoctorCell
        return cell
    }
}
