//
//  HomeBookingViewController.swift
//  CDYT_HoiDap
//
//  Created by Quang anh Vu on 7/24/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class HomeBookingViewController: UIViewController {

    @IBOutlet weak var tbListService: UITableView!
    @IBOutlet weak var customTopView: CustomTopView!
    var pushView : ((_ indentifier: String) -> Void)?
    
    let arrayImages = ["khamtainha.png","khamtaivien.png","xntainha.png"]
    let arrayTitle = ["Khám tại viện E","Khám tại nhà","Xét nghiệm tại nhà"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

      
}

extension HomeBookingViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayImages.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeCell
        cell.imgBackGround.image = UIImage(named: arrayImages[indexPath.section])
        cell.lbTitle.text = arrayTitle[indexPath.row]
        cell.btnGotoDetail = {
            switch (indexPath.section) {
            case 0:
                self.pushView!("")
            case 1:
                self.pushView!("")
            default:
                self.pushView!("HomeAnalysisViewController")
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightCell = ( ViewManager.screentHeight - (ViewManager.heightBar + ViewManager.heightTopView + ViewManager.marginTopAndBot*CGFloat(arrayImages.count + 1)) ) / CGFloat(arrayImages.count)
        return heightCell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }
}
