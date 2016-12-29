//
//  QuestionDetailViewController.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/29/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class QuestionDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var detailTbl: UITableView!
    
    var feed = FeedsEntity()
    var listComment = [MainCommentEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailTbl.delegate = self
        detailTbl.dataSource = self
        detailTbl.estimatedRowHeight = 1000
        detailTbl.rowHeight = UITableViewAutomaticDimension
        detailTbl.register(UINib.init(nibName: "DetailQuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailQuestionTableViewCell")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + listComment.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listComment.count > 0 {
            return listComment[section - 1].subComment.count
        }else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailQuestionTableViewCell") as! DetailQuestionTableViewCell
        cell.feed = self.feed
        cell.setData()
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backTapAction(_ sender: Any) {
    
    }

}
