//
//  QuestionViewController.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 12/26/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class QuestionViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource, QuestionTableViewCellDelegate ,UIPickerViewDelegate,UIPickerViewDataSource,WYPopoverControllerDelegate,ChoiceDoctorViewControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataFromServer(notification:)), name: Notification.Name.init(RELOAD_ALL_DATA), object: nil)
        initTableView()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let realm = try! Realm()
        let user = realm.objects(UserEntity.self).first
        if (user != nil) && user?.role == 2 {
            if !isFeeds || !isAssigned || !isNotAssignedYet {
                reloadDataAssigned()
                reloadDataNotAssignedYet()
            }else{
                if isFeeds {
                    reloadDataAssigned()
                    reloadDataNotAssignedYet()
                }
            }
            
            isFeeds = false
            isAssigned = true
            isNotAssignedYet = false
        }else{
            if !isFeeds || !isAssigned || !isNotAssignedYet {
                reloadDataForUser()
            }else{
                if !isFeeds {
                    reloadDataForUser()
                }
            }
            isFeeds = true
            isAssigned = false
            isNotAssignedYet = false
        }
        setupUI()
        tbQuestion.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Until.sendAndSetTracer(value: SLECT_QUESTION_NO_ANSWER)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI(){
        if isFeeds {
            layoutHeightHeaderView.constant = 0
            viewHeader.isHidden = true
        }else{
            layoutHeightHeaderView.constant = 50
            viewHeader.isHidden = false
        }
        setupView(view: viewAssigned, check: isAssigned)
        setupView(view: viewNotAssignedYet, check: isNotAssignedYet)
        self.view.layoutIfNeeded()
    }
    
    func setupView(view:UIView,check:Bool){
        if check {
            view.backgroundColor = UIColor.init(netHex: 0xf0f1f2)
        }else{
            view.backgroundColor = UIColor.white
        }
    }
    
    func reloadDataAssigned(){
        pageAssigned = 1
        self.listAssigned.removeAll()
        getQuestionsUncommentedByAnyDoctorAndAssigned()
        requestListDoctor()
    }
    func loadMoreAssigned(){
        pageAssigned += 1
        getQuestionsUncommentedByAnyDoctorAndAssigned()
        requestListDoctor()
    }
    func reloadDataNotAssignedYet(){
        pageNotAssignedYet = 1
        listNotAssignedYet.removeAll()
        getQuestionsUncommentedByAnyDoctorAndNotAssignedYet()
        requestListDoctor()
    }
    func loadMoreNotAssignedYet(){
        pageNotAssignedYet += 1
        getQuestionsUncommentedByAnyDoctorAndNotAssignedYet()
        requestListDoctor()
    }
    //MARK: init table view
    func initTableView(){
        tbQuestion.dataSource = self
        tbQuestion.delegate = self
        tbQuestion.estimatedRowHeight = 999
        tbQuestion.rowHeight = UITableViewAutomaticDimension
        tbQuestion.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tbQuestion.register(UINib.init(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTableViewCell")
        tbQuestion.addPullToRefreshHandler {
            DispatchQueue.main.async {
                if self.isFeeds{
                    self.reloadDataForUser()
                }else if self.isAssigned{
                    self.reloadDataAssigned()
                }else if self.isNotAssignedYet{
                    self.reloadDataNotAssignedYet()
                }
            }
        }
        tbQuestion.addInfiniteScrollingWithHandler {
            DispatchQueue.main.async {
                if self.isFeeds{
                    self.loadMoreForUser()
                }else if self.isAssigned{
                    self.loadMoreAssigned()
                }else if self.isNotAssignedYet{
                    self.loadMoreNotAssignedYet()
                }
            }
        }
    }
    func reloadDataForUser(){
        pageFeed = 1
        listFedds.removeAll()
        getFeeds_UnAnswerForUser()
    }
    func loadMoreForUser(){
        pageFeed += 1
        getFeeds_UnAnswerForUser()
    }
    //  MARK: Action
    
    @IBAction func actionAssigned(_ sender: Any) {
        isAssigned = true
        isNotAssignedYet = false
        setupUI()
        tbQuestion.reloadData()
    }
    
    @IBAction func actionNotAssignedYet(_ sender: Any) {
        isAssigned = false
        isNotAssignedYet = true
        setupUI()
        tbQuestion.reloadData()
    }
    
    //  MARK: request data
    //  danh sách câu hỏi chưa được BS trả lời và đã được assign
    func getQuestionsUncommentedByAnyDoctorAndAssigned(){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            let hotParam : [String : Any] = [
                "Page": pageAssigned,
                "Size": 10,
                "RequestedUserId" : Until.getCurrentId()
            ]
            Alamofire.request(GET_QUESTIONS_UNCOMMENTED_BY_ANY_DOCTOR_AND_ASSIGNED, method: .post, parameters: hotParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            let jsonData = result as! [NSDictionary]
                            for item in jsonData {
                                let entity = FeedsEntity.init(dictionary: item)
                                self.listAssigned.append(entity)
                            }
                        }
                        self.tbQuestion.reloadData()
                    }else{
                        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                    }
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
                self.tbQuestion.pullToRefreshView?.stopAnimating()
                self.tbQuestion.infiniteScrollingView?.stopAnimating()
            }
        } catch let error as NSError {
            print(error)
        }
    }
    //  danh sách câu hỏi chưa được BS trả lời và chưa được assign
    func getQuestionsUncommentedByAnyDoctorAndNotAssignedYet(){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            let hotParam : [String : Any] = [
                "Page": pageNotAssignedYet,
                "Size": 10,
                "RequestedUserId" : Until.getCurrentId()
            ]
            Alamofire.request(GET_QUESTIONS_UNCOMMENTED_BY_ANY_DOCTOR_AND_NOT_ASSIGNED_YET, method: .post, parameters: hotParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            let jsonData = result as! [NSDictionary]
                            for item in jsonData {
                                let entity = FeedsEntity.init(dictionary: item)
                                self.listNotAssignedYet.append(entity)
                            }
                        }
                        self.tbQuestion.reloadData()
                    }else{
                        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                    }
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
                self.tbQuestion.pullToRefreshView?.stopAnimating()
                self.tbQuestion.infiniteScrollingView?.stopAnimating()
            }
        } catch let error as NSError {
            print(error)
        }
    }
    func getFeeds_UnAnswerForUser(){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            let hotParam : [String : Any] = [
                "Page": pageFeed,
                "Size": 10,
                "RequestedUserId" : Until.getCurrentId()
            ]
            Alamofire.request(GET_UNANSWER, method: .post, parameters: hotParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            let jsonData = result as! [NSDictionary]
                            
                            for item in jsonData {
                                let entity = FeedsEntity.init(dictionary: item)
                                self.listFedds.append(entity)
                            }
                        }
                        self.tbQuestion.reloadData()
                    }else{
                        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                    }
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
                self.tbQuestion.pullToRefreshView?.stopAnimating()
                self.tbQuestion.infiniteScrollingView?.stopAnimating()
            }

        } catch let error as NSError {
            print(error)
        }
        
    }
    func requestApproval(){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            var entity : FeedsEntity!
            if isNotAssignedYet {
                entity = listNotAssignedYet[indexPathOfCell.row]
            }else{
                entity = listAssigned[indexPathOfCell.row]
            }
            
            let post : [String : Any] = [
                "Id" : entity.postEntity.id,
                "Title" : entity.postEntity.title,
                "Content" : entity.postEntity.content,
                "ImageUrls" : entity.postEntity.imageUrls,
                "ThumbnailImageUrls" : entity.postEntity.thumbnailImageUrls,
                "Status" : 0,
                "Rating" : 0,
                "UpdatedDate" : 0,
                "CategoryId": idCate,
                "IsPrivate": entity.postEntity.isPrivate,
                "IsClassified": false,
                "CreatedDate" : 0
            ]
            
            let questionParam : [String : Any] = [
                "RequestedUserId": Until.getCurrentId(),
                "Post": post,
                "AssignToUserId": idDoc
            ]
            Alamofire.request(GET_LASTED_POST, method: .post, parameters: questionParam, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        entity.postEntity.isClassified = true
                        if self.isNotAssignedYet {
                            self.listNotAssignedYet.remove(at: self.indexPathOfCell.row)
                        }
                        self.requestListDoctor()
                        self.tbQuestion.reloadData()
                    }else{
                        UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Có lỗi xảy ra. Vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                    }
                }else{
                    UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Không có kết nối mạng, vui lòng thử lại sau", cancelBtnTitle: "Đóng")
                }
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    //MARK: UIViewController,UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFeeds {
            return listFedds.count
        }
        if isAssigned {
            return listAssigned.count
        }
        return listNotAssignedYet.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell") as! QuestionTableViewCell
        cell.delegate = self
        cell.indexPath = indexPath
        if isFeeds {
            if listFedds.count > 0 {
                cell.feedEntity = listFedds[indexPath.row]
                cell.setData(isHiddenCateAndDoctor: true)
                //        cell.layoutBottomCreateDate.constant = 0
            }
        }else{
            if isAssigned {
                if listAssigned.count > 0 {
                    cell.feedEntity = listAssigned[indexPath.row]
                    cell.setData(isHiddenCateAndDoctor: true)
                }
            }else{
                if listNotAssignedYet.count > 0 {
                    cell.feedEntity = listNotAssignedYet[indexPath.row]
                    cell.setData(isHiddenCateAndDoctor: true)
                }
            }
        }
        return cell
    }
    
    
    //MARK: QuestionTableViewCellDelegate
    func showQuestionDetail(indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuestionDetailViewController") as! QuestionDetailViewController
        if isFeeds {
            vc.feedObj = listFedds[indexPath.row]
        }else if isAssigned {
            vc.feedObj = listAssigned[indexPath.row]
        }else{
            vc.feedObj = listNotAssignedYet[indexPath.row]
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func gotoListQuestionByTag(hotTag: TagEntity) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestionByTagViewController") as! QuestionByTagViewController
        viewController.hotTag = hotTag
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func gotoUserProfileFromQuestionCell(user: AuthorEntity) {
        let storyboard = UIStoryboard.init(name: "User", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "OtherUserViewController") as! OtherUserViewController
        viewController.user = user
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func gotoUserProfileFromQuestionDoctor(doctor: AuthorEntity) {
        
    }
    
    //MARK: receive notifiy when mark an comment is solution
    func reloadDataFromServer(notification : Notification){
        reloadDataForUser()
    }
    
    func selectSpecialist(indexPath: IndexPath) {
        creatAlert(title: "Chọn chuyên khoa",picker: pickerViewCate)
        indexPathOfCell = indexPath
    }
    
    func selectDoctor(indexPath: IndexPath) {
        var entity : FeedsEntity!
        if isNotAssignedYet {
            entity = listNotAssignedYet[indexPath.row]
        }else{
            entity = listAssigned[indexPath.row]
        }
        
        if !entity.cateGory.id.isEmpty {
            idCate = entity.cateGory.id
            nameCate = entity.cateGory.name
            let listDocWithCate = listAllDoctors.filter({ (doctorEntity) -> Bool in
                doctorEntity.category.id == idCate
            })
            listDoctorInCate = listDocWithCate[0].doctors
            
            if listDoctorInCate.count > 0 {
                indexPathOfCell = indexPath
                //      creatAlert(title: "Chọn bác sỹ",picker: pickerViewDoctor)
                if popupViewController == nil {
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let popoverVC = mainStoryboard.instantiateViewController(withIdentifier: "ChoiceDoctorViewController") as! ChoiceDoctorViewController
                    popoverVC.preferredContentSize = CGSize.init(width: UIScreen.main.bounds.size.width - 32, height: UIScreen.main.bounds.size.height - 120 )
                    popoverVC.isModalInPopover = false
                    popoverVC.listDoctors = self.listDoctorInCate
                    popoverVC.delegate = self
                    self.popupViewController = WYPopoverController(contentViewController: popoverVC)
                    self.popupViewController.delegate = self
                    self.popupViewController.wantsDefaultContentAppearance = false;
                    self.popupViewController.presentPopover(from: CGRect.init(x: 0, y: 0, width: 0, height: 0), in: self.view, permittedArrowDirections: WYPopoverArrowDirection.none, animated: true, options: WYPopoverAnimationOptions.fadeWithScale, completion: nil)
                }
                
            }else {
                UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Vui lòng chọn chuyên khoa trước", cancelBtnTitle: "Đóng")
                
            }
        }
        
        
    }
    
    func popoverControllerDidDismissPopover(_ popoverController: WYPopoverController!) {
        if popupViewController != nil {
            popupViewController.delegate = nil
            popupViewController = nil
        }
    }
    
    
    func creatAlert(title: String, picker: UIPickerView){
        let alertView = UIAlertController(title: title, message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        alertView.view.addSubview(picker)
        
        picker.delegate = self
        picker.dataSource = self
        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                if self.idCate != self.listAllDoctors[self.indexPickerViewCate].category.id {
                    self.idCate = self.listAllDoctors[self.indexPickerViewCate].category.id
                    self.nameCate = self.listAllDoctors[self.indexPickerViewCate].category.name
                    if self.isNotAssignedYet {
                        self.listNotAssignedYet[self.indexPathOfCell.row].cateGory.id = self.idCate
                        self.listNotAssignedYet[self.indexPathOfCell.row].cateGory.name = self.nameCate
                        self.nameCate = ""
                        self.idCate = ""
                    }else if self.isAssigned {
                        self.listAssigned[self.indexPathOfCell.row].cateGory.id = self.idCate
                        self.listAssigned[self.indexPathOfCell.row].cateGory.name = self.nameCate
                        self.listAssigned[self.indexPathOfCell.row].postEntity.isClassified = false
                    }
                }else {
                    if self.isNotAssignedYet {
                        self.listNotAssignedYet[self.indexPathOfCell.row].cateGory.id = self.idCate
                        self.listNotAssignedYet[self.indexPathOfCell.row].cateGory.name = self.nameCate
                        self.nameCate = ""
                        self.idCate = ""
                    }else if self.isAssigned {
                        self.listAssigned[self.indexPathOfCell.row].cateGory.id = self.idCate
                        self.listAssigned[self.indexPathOfCell.row].cateGory.name = self.nameCate
                        self.listAssigned[self.indexPathOfCell.row].postEntity.isClassified = false
                    }
            }
            self.tbQuestion.beginUpdates()
            self.tbQuestion.reloadRows(at: [self.indexPathOfCell], with: .automatic)
            self.tbQuestion.endUpdates()
        })
        
        alertView.addAction(action)
        present(alertView, animated: true, completion: nil)
    }
    //  MARK: UIPickerViewDelegate + UIPickerViewDatasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewCate {
            return listAllDoctors.count
        }else {
            return listDoctorInCate.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerViewCate {
            return listAllDoctors[row].category.name
        }else {
            return listDoctorInCate[row].doctorEntity.fullname
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerViewCate {
            indexPickerViewCate = row
        }
        
    }
    
    //MARK: Delegate PIck Doctor
    
    
    func setDataDoctor(doctor: AuthorEntity) {
        
        idDoc = doctor.id
        nameDoc = doctor.fullname
        
        if isNotAssignedYet {
            listNotAssignedYet[indexPathOfCell.row].assigneeEntity.id = idDoc
            listNotAssignedYet[indexPathOfCell.row].assigneeEntity.fullname = nameDoc
        }else if isAssigned {
            listAssigned[indexPathOfCell.row].assigneeEntity.id = idDoc
            listAssigned[indexPathOfCell.row].assigneeEntity.fullname = nameDoc
            listAssigned[indexPathOfCell.row].postEntity.isClassified = false
        }
        
        
        popupViewController.dismissPopover(animated: true)
        popupViewController.delegate = nil
        popupViewController = nil
        
        self.tbQuestion.beginUpdates()
        self.tbQuestion.reloadRows(at: [self.indexPathOfCell], with: .automatic)
        self.tbQuestion.endUpdates()
    }
    
    
    func approVal(indexPath : IndexPath) {
        var entity : FeedsEntity!
        if isNotAssignedYet {
            entity = listNotAssignedYet[indexPath.row]
        }else{
            entity = listAssigned[indexPath.row]
        }
        if entity.cateGory.id.isEmpty {
            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Vui lòng chọn chuyên khoa trước", cancelBtnTitle: "Đóng")
            return
        }
        if entity.assigneeEntity.id.isEmpty {
            UIAlertController().showAlertWith(vc: self, title: "Thông báo", message: "Vui lòng chọn bác sĩ cần duyệt", cancelBtnTitle: "Đóng")
            return
        }
        if !entity.cateGory.id.isEmpty && !entity.assigneeEntity.id.isEmpty {
            idCate = entity.cateGory.id
            nameCate = entity.cateGory.name
            idDoc = entity.assigneeEntity.id
            nameDoc = entity.assigneeEntity.fullname
            indexPathOfCell = indexPath
            if isAssigned {
                let alert = UIAlertController.init(title: "Thông báo", message: "Bạn có muốn duyệt lại câu hỏi này?", preferredStyle: UIAlertControllerStyle.alert)
                let actionOk = UIAlertAction.init(title: "Đồng ý", style: UIAlertActionStyle.default, handler: { (action) in
                    self.requestApproval()
                })
                let actionNo = UIAlertAction.init(title: "Không", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(actionOk)
                alert.addAction(actionNo)
                self.present(alert, animated: true, completion: nil)
            }else{
                requestApproval()
            }
        }
    }
    
    func requestListDoctor(){
        do {
            let data = try JSONSerialization.data(withJSONObject: Until.getAuthKey(), options: JSONSerialization.WritingOptions.prettyPrinted)
            let code = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            let auth = code.replacingOccurrences(of: "\n", with: "")
            let header = [
                "Auth": auth
            ]
            listAllDoctors.removeAll()
            Alamofire.request(GET_LIST_DOCTOR, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
                if let status = response.response?.statusCode {
                    if status == 200{
                        if let result = response.result.value {
                            let jsonData = result as! [NSDictionary]
                            for item in jsonData {
                                let entity = ListDoctorEntity.init(dictionary: item)
                                self.listAllDoctors.append(entity)
                            }
                            
                        }
                    }
                }
            }
        } catch let error as NSError {
            print(error)
        }
    }

    
    //  MARK: Outlet
    @IBOutlet weak var tbQuestion: UITableView!
    var isFeeds = false
    var isAssigned = false
    var isNotAssignedYet = false
    var listFedds = [FeedsEntity]()
    var listAssigned = [FeedsEntity]()
    var listNotAssignedYet = [FeedsEntity]()
    var listAllDoctors = [ListDoctorEntity]()
    
    var pageFeed = 1
    var pageAssigned = 1
    var pageNotAssignedYet = 1
    
    let pickerViewDoctor = UIPickerView(frame: CGRect(x: 0, y: 50, width: 270, height: 150))
    var indexPickerViewDoctor = 0
    let pickerViewCate = UIPickerView(frame: CGRect(x: 0, y: 50, width: 270, height: 150))
    var indexPickerViewCate = 0
    var indexPathOfCell = IndexPath()
    var idCate = ""
    var idDoc = ""
    var nameCate = ""
    var nameDoc = ""
    var ischeckHide = true
    var listDoctorInCate = [DoctorEntity]()
    var popupViewController:WYPopoverController!
    
    
    @IBOutlet weak var layoutHeightHeaderView: NSLayoutConstraint!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewAssigned: UIView!
    @IBOutlet weak var viewNotAssignedYet: UIView!
    
}
