//
//  CourseTableViewController.swift
//  NPU_Life
//
//  Created by BigAnna on 2021/7/25.
//

import UIKit
import SwiftyJSON

class CourseTableViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    var user = User()
    @IBOutlet weak var tableView: UIView!
    @IBOutlet weak var backview: UIView!
    let weekName = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    var courseView:CourseTableTableViewController?
    var setAlertView:CourseAlertTableViewController?
    var alertList:[CourseAlert] = [CourseAlert]()
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        let barAppearance =  UINavigationBarAppearance()
        barAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        barAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = barAppearance
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.courseView?.user = self.user
        self.setAlertView?.alertList = self.alertList
        self.title = "查課表"
        
        courseView?.superUIView = self
        getCourse()
    }
    
    @IBAction func settingAlert(_ sender: UIButton) {
        performSegue(withIdentifier: "setAlert", sender: nil)
    }
    

    
    func shareCourse(){
        let renderer = UIGraphicsImageRenderer(size: tableView.frame.size)
        let image = renderer.image(actions: { (context) in
            tableView.drawHierarchy(in: tableView.bounds, afterScreenUpdates: true)
        })
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    func getCourse(){
        self.loadingView.startAnimating()
        let url = URL(string:"https://app.npu.edu.tw/api/coursetable?token=\(self.user.token)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let newURL = URLSession(configuration: .default)
        let myTask = newURL.dataTask(with: request, completionHandler: {
            (data,respond,error) in
            if error != nil {
                let myErrorCode = (error! as NSError).code
                var errorMsg = ""
                switch myErrorCode {
                case -1009:
                    errorMsg = "你好想沒有網路連線耶！\n要不要再檢查看看呢"
                case -1004:
                    errorMsg = "登入伺服器出了點問題！\n稍後再試試看\n選課期間異常是正常現象唷"
                default:
                    errorMsg = "出了點未知錯誤，請聯繫作者回報，謝謝您!"
                }
                DispatchQueue.main.async {
                    self.showMessage(title: "哎呀！", message: errorMsg)
                }
                return
            }else if let response = respond as? HTTPURLResponse{
                if response.statusCode == 500{
                    DispatchQueue.main.async {
                        self.showMessage(title: "哎呀❗️", message: "系統出了點問題！\n請稍後再試\n若一直無法正常運作請聯絡作者\n謝謝您！")
                        self.loadingView.stopAnimating()
                        return
                    }
                }
            }
            let myData = JSON(data!)
            if myData["msg"].string != nil {
                DispatchQueue.main.async {
                    self.showMessage(title: "閒置過久", message: "請重新登入！")
                }
                return
            }else if myData["error"].string != nil{
                DispatchQueue.main.async {
                    self.showMessage(title: "哎呀！查不到課表", message: "如果校務系統正常麻煩幫我回報Bug讓程式正常使用！")
                }
                return
            }
            if self.user.course.count <= 1{
                self.user.course = [[Course]()]
                if self.user.stdType == "Night"{
                    for i in 9...13{
                        var tempdata = [Course]()
                        for j in 0...5{
                            let myCourse:Course = Course()
                            var courseName:String = myData["value"][i]["No\(i+1)"][self.weekName[j]]["courseName"].string!
                            if courseName.contains("*"){
                                courseName.remove(at:courseName.startIndex)
                            }
                            if courseName.contains("-"){
                                myCourse.fullCourseName = courseName
                                courseName.removeSubrange(courseName.index(courseName.endIndex, offsetBy: -5) ..< courseName.endIndex)
                            }
                            if courseName.contains("全民國防"){
                                myCourse.fullCourseName = courseName
                                courseName = "國防"
                            }
                            myCourse.courseName = courseName
                            myCourse.courseRoom = myData["value"][i]["No\(i+1)"][self.weekName[j]]["room"].string!
                            myCourse.courseTeacher = myData["value"][i]["No\(i+1)"][self.weekName[j]]["teacher"].string!
                            tempdata.append(myCourse)
                        }
                        self.user.course.append(tempdata)
                    }
                }else{
                    for i in 0...8{
                        var tempdata = [Course]()
                        for j in 0...5{
                            let myCourse:Course = Course()
                            var courseName:String = myData["value"][i]["No\(i+1)"][self.weekName[j]]["courseName"].string!
                            if courseName.contains("*"){
                                courseName.remove(at:courseName.startIndex)
                            }
                            if courseName.contains("-"){
                                myCourse.fullCourseName = courseName
                                courseName.removeSubrange(courseName.index(courseName.endIndex, offsetBy: -5) ..< courseName.endIndex)
                            }
                            if courseName.contains("全民國防"){
                                myCourse.fullCourseName = courseName
                                courseName = "國防"
                            }
                            myCourse.courseName = courseName
                            myCourse.courseRoom = myData["value"][i]["No\(i+1)"][self.weekName[j]]["room"].string!
                            myCourse.courseTeacher = myData["value"][i]["No\(i+1)"][self.weekName[j]]["teacher"].string!
                            tempdata.append(myCourse)
                        }
                        self.user.course.append(tempdata)
                    }
                }
                self.user.course.remove(at: 0)
                self.courseView?.isInit = false
                self.user.haveSat = myData["haveSatDay"].string!
                for (_,timeTable):(String,JSON) in myData["timeList"]{
                    let tempTimeList = CourseAlert(Name: timeTable["courseName"].string!, Time: timeTable["courseTime"].string!, Room: timeTable["room"].string!)

                    self.alertList.append(tempTimeList)
                }
            }else{
                for (_,timeTable):(String,JSON) in myData["timeList"]{
                    let tempTimeList = CourseAlert(Name: timeTable["courseName"].string!, Time: timeTable["courseTime"].string!, Room: timeTable["room"].string!)
                    
                    self.alertList.append(tempTimeList)
                }
                self.courseView?.isInit = false
            }
            self.courseView?.getColor()
            DispatchQueue.main.async {
                self.courseView?.height = self.tableView.frame.size.height
                self.courseView?.animateTable()
                self.loadingView.stopAnimating()
            }
            
        })
        myTask.resume()
    }
    
    func showMessage(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: {
            _ in
            self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "courseTableDetail"{
            courseView = segue.destination as? CourseTableTableViewController
        }else if segue.identifier == "setAlert"{
            setAlertView = segue.destination as? CourseAlertTableViewController
            setAlertView?.alertList = self.alertList
            setAlertView?.stdType = self.user.stdType
        }
    }

}
