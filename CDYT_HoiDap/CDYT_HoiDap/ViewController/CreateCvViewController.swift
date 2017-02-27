//
//  CreateCvViewController.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 25/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class CreateCvViewController: UIViewController {
    
    @IBOutlet weak var lbGender: UILabel!
    @IBOutlet weak var lbDateOfYear: UILabel!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    
    
    var genderType = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Button
    
    @IBAction func btnGender(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let manTap = UIAlertAction(title: "Nam", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.genderType = "1"
            self.lbGender.text = "Nam"
        })
        
        let femaleTap = UIAlertAction(title: "Nữ", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.genderType = "0"
            self.lbGender.text = "Nữ"
        })
        
        let cancelTap = UIAlertAction(title: "Huỷ", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        optionMenu.addAction(manTap)
        optionMenu.addAction(femaleTap)
        optionMenu.addAction(cancelTap)
        
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    @IBAction func btnDateOfBirth(_ sender: Any) {
        DatePickerDialog().show(title: "Ngày sinh", doneButtonTitle: "Xong", cancelButtonTitle: "Hủy", datePickerMode: .date) {
            (date) -> Void in
            if date != nil {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                self.lbDateOfYear.text = "\(dateFormatter.string(from: date! as Date))"
            }
        }
    }
    
    @IBAction func btnJob(_ sender: Any) {
    }
    
    @IBAction func btnCitizenship(_ sender: Any) {
    }
    
    @IBAction func btnCity(_ sender: Any) {
    }
    
    @IBAction func btnCreateCv(_ sender: Any) {
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)

    }

   
}
