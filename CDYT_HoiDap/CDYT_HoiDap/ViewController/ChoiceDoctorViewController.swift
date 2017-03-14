//
//  ChoiceDoctorViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 14/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit
protocol ChoiceDoctorViewControllerDelegate {
    func setDataDoctor(doctor: AuthorEntity)
}

class ChoiceDoctorViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tbListDoctor: UITableView!
    
    var listDoctors = [DoctorEntity]()
    var delegate : ChoiceDoctorViewControllerDelegate?
    
    override func viewDidLoad() {
        setupUI()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setupUI(){
        tbListDoctor.delegate = self
        tbListDoctor.dataSource = self
        tbListDoctor.register(UINib.init(nibName: "DoctorCell", bundle: nil), forCellReuseIdentifier: "DoctorCell")
        tbListDoctor.estimatedRowHeight = 9999
        tbListDoctor.rowHeight = UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDoctors.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorCell") as! DoctorCell
        if listDoctors.count > 0 {
        cell.setData(entity: listDoctors[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.setDataDoctor(doctor: listDoctors[indexPath.row].doctorEntity)
    }
}
