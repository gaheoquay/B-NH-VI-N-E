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
    
   
    
    let arrayImages = ["khamtainha.png","khamtaivien.png","xntainha.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func popView(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func gotoDetailService(indentfier: String){
        let viewcontroller = storyboard?.instantiateViewController(withIdentifier: indentfier)
        self.navigationController?.pushViewController(viewcontroller!, animated: true)
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
        cell.btnGotoDetail = {
            switch (indexPath.section) {
            case 0:
                self.gotoDetailService(indentfier: "HomeAnalysisViewController")
            case 1:
                self.gotoDetailService(indentfier: "")
            default:
                self.gotoDetailService(indentfier: "")
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightScreen = UIScreen.main.bounds.size.height
        return (heightScreen - 98) / 3
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
