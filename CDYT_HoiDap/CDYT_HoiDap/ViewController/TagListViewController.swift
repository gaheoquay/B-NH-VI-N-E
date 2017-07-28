//
//  TagListViewController.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 12/26/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class TagListViewController: BaseViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tagTableView: UITableView!
    var listHotTag = [HotTagEntity]()
    var page = 1
    var time: Timer?
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        let textField = searchBar.value(forKey: "_searchField") as? UITextField
        textField?.layer.borderColor = UIColor.lightGray.cgColor
        textField?.layer.borderWidth = 1
        textField?.layer.cornerRadius = 15
        initTaleView()
        searchTag()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Until.sendAndSetTracer(value: SLECT_TAG)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listHotTag.count
    }
    
    func initTaleView(){
        tagTableView.delegate = self
        tagTableView.dataSource = self
        tagTableView.estimatedRowHeight = 200
        tagTableView.rowHeight = UITableViewAutomaticDimension
        tagTableView.register(UINib.init(nibName: "QuestionTagTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTagTableViewCell")
        tagTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tagTableView.addPullToRefreshHandler {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
        tagTableView.addInfiniteScrollingWithHandler {
            DispatchQueue.main.async {
                self.loadMore()
            }
        }
    }
    func reloadData(){
        page = 1
        isSearching = false
        listHotTag.removeAll()
        searchTag()
        
    }
    func loadMore(){
        page += 1
        isSearching = false
        searchTag()
    }
    
    func searchTag(){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            let searchText = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let requestUrl = SEARCH_TAG + "?page=\(page)&size=10&userId=\(Until.getCurrentId())&query=\(searchText ?? "")"
            Alamofire.request(requestUrl, method: .get, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            if self.isSearching {
                                self.listHotTag.removeAll()
                            }
                            let jsonData = (result as! NSDictionary)["Tags"] as! [NSDictionary]
                                for item in jsonData {
                                    let hotTag = HotTagEntity.init(dictionary: item)
                                    self.listHotTag.append(hotTag)
                                }
                            self.tagTableView.reloadData()
                        }
                    }else{
                        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                    }
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
                self.tagTableView.pullToRefreshView?.stopAnimating()
                self.tagTableView.infiniteScrollingView?.stopAnimating()
            }
        } catch let error as NSError {
            print(error)
        }
    }
}

//  MARK: UITableViewDataSource, UITableViewDelegate
extension TagListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTagTableViewCell") as! QuestionTagTableViewCell
        cell.delegate = self
        if listHotTag.count > 0 {
            cell.hotTag = listHotTag[indexPath.row]
            cell.setData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let entity = listHotTag[indexPath.row]
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.send(GAIDictionaryBuilder.createEvent(withCategory: "Tag", action: "ClickTagInPage", label: "\(entity.tag.tagName)", value: nil).build() as [NSObject : AnyObject])
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestionByTagViewController") as! QuestionByTagViewController
        viewController.hotTag = entity.tag
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
}
//  MARK: QuestionTagTableViewCellDelegate
extension TagListViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
//  MARK: QuestionTagTableViewCellDelegate
extension TagListViewController: QuestionTagTableViewCellDelegate {
    func checkLogin() {
        Until.gotoLogin(_self: self, cannotBack: false)
    }
}

//  MARK: UISearchBarDelegate
extension TagListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        time?.invalidate()
        isSearching = true
        if #available(iOS 10.0, *) {
            time = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { (_) in
                self.page = 1
                self.listHotTag.removeAll()
                self.searchTag()
            })
        } else {
            time = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.searchTag), userInfo: nil, repeats: false)
            self.page = 1
            self.listHotTag.removeAll()
            self.searchTag()
        }
    }
}
