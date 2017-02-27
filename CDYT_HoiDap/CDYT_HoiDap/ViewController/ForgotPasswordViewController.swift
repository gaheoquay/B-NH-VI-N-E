//
//  ForgotPasswordViewController.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 1/9/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
    override func viewDidAppear(_ animated: Bool) {
        Until.sendAndSetTracer(value: FORGOT_PASS)
    }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func actionBack(_ sender: Any) {
    _ = self.navigationController?.popViewController(animated: true)
  }
  @IBAction func actionSend(_ sender: Any) {
    
  }
  //MARK: Outlet
  @IBOutlet weak var txtEmail: UITextField!
  
}
