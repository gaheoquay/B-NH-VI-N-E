//
//  NotificationViewController.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/28/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var notifyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        notifyTableView.dataSource = self
        notifyTableView.delegate = self
        notifyTableView.estimatedRowHeight = 200
        notifyTableView.rowHeight = UITableViewAutomaticDimension
        notifyTableView.register(UINib.init(nibName: "NotifyTableViewCell", bundle: nil), forCellReuseIdentifier: "NotifyTableViewCell")
        notifyTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotifyTableViewCell") as! NotifyTableViewCell
        cell.titleLbl.text = "helo 21231a3s13da21s3d132s3"
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
