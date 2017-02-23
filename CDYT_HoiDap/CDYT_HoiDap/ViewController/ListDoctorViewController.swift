//
//  ListDoctorViewController.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 2/20/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

protocol ListDoctorViewControllerDelegate {
  func gotoProfile(authorEntity:AuthorEntity)
}

class ListDoctorViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
  var delegate:ListDoctorViewControllerDelegate?
  
  @IBOutlet weak var tbDoctor: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      initTableView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  func initTableView(){
    tbDoctor.delegate = self
    tbDoctor.dataSource = self
//    tbDoctor.estimatedRowHeight = 9999
//    tbDoctor.rowHeight = UITableViewAutomaticDimension
    tbDoctor.register(UINib.init(nibName: "DoctorTableViewCell", bundle: nil), forCellReuseIdentifier: "DoctorTableViewCell")
  }

  
//  MARK: UITableViewDelegate +
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let entity = listAllDoctor[indexPath.section]
    delegate?.gotoProfile(authorEntity: entity.doctors[indexPath.row])
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return listAllDoctor.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let entity = listAllDoctor[section]
    if !entity.isExpand {
      return 0
    }
    return entity.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorTableViewCell") as! DoctorTableViewCell
    let entity = listAllDoctor[indexPath.section]
    cell.setData(entity: entity.doctors[indexPath.row])
    return cell
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 77
  }
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let entity = listAllDoctor[section]
    let vw = UIView()
    vw.backgroundColor = UIColor.white
    let lbCateName = UILabel.init()
    lbCateName.font = UIFont.systemFont(ofSize: 13)
    lbCateName.text = entity.category.name
    lbCateName.sizeToFit()
    lbCateName.frame = CGRect.init(x: 8, y: 25 - lbCateName.frame.size.height/2 , width: lbCateName.frame.size.width, height: lbCateName.frame.size.height)
    vw.addSubview(lbCateName)
    
    
    let lbNumberOfDoctor = UILabel.init()
    lbNumberOfDoctor.font = UIFont.systemFont(ofSize: 13)
    lbNumberOfDoctor.text = "  " + String(entity.count) + " bác sĩ  "
    lbNumberOfDoctor.sizeToFit()
    lbNumberOfDoctor.frame = CGRect.init(x: UIScreen.main.bounds.width - lbNumberOfDoctor.frame.size.width - 8, y: 10 , width: lbNumberOfDoctor.frame.size.width, height: 30)
    lbNumberOfDoctor.backgroundColor = UIColor.init(netHex: 0xcfe8ff)
    lbNumberOfDoctor.layer.cornerRadius = 5
    lbNumberOfDoctor.clipsToBounds = true
    vw.addSubview(lbNumberOfDoctor)
    let viewLine = UIView.init(frame: CGRect.init(x: 8, y: 49, width: UIScreen.main.bounds.width - 16, height: 1))
    viewLine.backgroundColor = UIColor.init(netHex: 0xd6d6d6)
    vw.addSubview(viewLine)
    let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height:50 ))
    button.tag = section
    button.setTitle("", for: UIControlState.normal)
    button.addTarget(self, action: #selector(clickHeader(button:)), for: UIControlEvents.touchUpInside)
    vw.addSubview(button)
    return vw
    
  }
  func clickHeader(button:UIButton){
    print(button.tag)
    let entity = listAllDoctor[button.tag]
    entity.isExpand = !entity.isExpand
    tbDoctor.beginUpdates()
    tbDoctor.reloadSections(IndexSet.init(integer: button.tag), with: UITableViewRowAnimation.automatic)
    tbDoctor.endUpdates()
  }

}
