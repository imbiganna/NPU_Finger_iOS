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
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UIView!
    let weekName = ["Monday","Tuesday","Wednesday","Thursday","Friday"]
    
    var courseView:CourseTableTableViewController?
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user.course = [[Course]()]
        self.title = "查課表"
        shareButton.tintColor = .white
        let barAppearance =  UINavigationBarAppearance()
        barAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        barAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = barAppearance
        getCourse()
    }
    
    @IBAction func shareTable(_ sender: UIBarButtonItem) {
        let renderer = UIGraphicsImageRenderer(size: tableView.frame.size)
        let image = renderer.image(actions: { (context) in
            tableView.drawHierarchy(in: tableView.bounds, afterScreenUpdates: true)
        })
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    
    }
    
    
    func getCourse(){
        self.loadingView.startAnimating()
        let url = URL(string:"https://api.nasss.ml/api/coursetable?token=\(self.user.token)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let newURL = URLSession(configuration: .default)
        let myTask = newURL.dataTask(with: request, completionHandler: {
            (data,respond,error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }else{
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
                
                for i in 0...8{
                    var tempdata = [Course]()
                    for j in 0...4{
                        let myCourse:Course = Course()
                        var courseName:String = myData["value"][i]["No\(i+1)"][self.weekName[j]]["courseName"].string!
                        if courseName.contains("*"){
                            courseName.remove(at:courseName.startIndex)
                        }
                        if courseName.contains("-"){
                            courseName.removeSubrange(courseName.index(courseName.endIndex, offsetBy: -5) ..< courseName.endIndex)
                        }
                        myCourse.courseName = courseName
                        myCourse.courseRoom = myData["value"][i]["No\(i+1)"][self.weekName[j]]["room"].string!
                        myCourse.courseTeacher = myData["value"][i]["No\(i+1)"][self.weekName[j]]["teacher"].string!
                        tempdata.append(myCourse)
                    }
                    self.user.course.append(tempdata)
                }
                self.user.course.remove(at: 0)
                self.courseView?.user = self.user
                self.courseView?.isInit = false
                self.courseView?.getColor()
                DispatchQueue.main.async {
                    self.courseView?.height = self.tableView.frame.size.height
                    self.courseView?.animateTable()
                    self.loadingView.stopAnimating()
                }
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
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
