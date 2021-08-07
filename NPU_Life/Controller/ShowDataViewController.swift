//
//  ShowDataViewController.swift
//  NPU_Finger
//
//  Created by BigAnna on 2021/8/5.
//

import UIKit
import SwiftyJSON

class ShowDataViewController: UIViewController {

    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelSecond: UILabel!
    @IBOutlet weak var labelThird: UILabel!
    var dataView:ShowDataTableViewController?
    var myUser = User()
    var myNoShow = [[String()]]
    var dataType:DataType?
    var myReward = [[String()]]
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonView.layer.cornerRadius = 20
        self.buttonView.layer.masksToBounds = true
        let barAppearance =  UINavigationBarAppearance()
        barAppearance.configureWithTransparentBackground()
        barAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = barAppearance
    
        switch dataType {
        case .Score:
            self.title = "查成績"
            getScore()
        case .NoShow:
            self.title = "查缺曠"
            self.labelOne.text = "曠課節數：讀取中..."
            self.labelSecond.text = "已請節數：讀取中..."
            self.labelThird.isHidden = true
            getNoShow()
        case .Reward:
            self.title = "查獎懲"
            getMyReward()
        default:
            return
        }
        
        
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        buttonView.layer.masksToBounds = true
        buttonView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        buttonView.layer.cornerRadius = 40
    }
    
    func getScore(){
        self.loadingView.startAnimating()
        let url = URL(string:"https://api.nasss.ml/api/score?token=\(myUser.token)")!
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
                }
                if myData["error"].string == "未填寫教學評量"{
                    DispatchQueue.main.async {
                        self.showMessage(title: "哎呀！", message: "你好像沒填寫教學評量\n查不到成績唷！")
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.labelOne.text = myData["avgScore"].string
                    self.labelSecond.text = myData["conduct"].string
                    self.labelThird.text = myData["rank"].string
                }
                for (_,score):(String,JSON) in myData["value"]{
                    let tmpScore = Score()
                    tmpScore.courseName = score["courseName"].string!
                    tmpScore.finalScore = score["finalScore"].string!
                    tmpScore.midScore = score["midScore"].string!
                    self.myUser.score.append(tmpScore)
                }
                self.dataView?.dataType = self.dataType
                self.dataView?.user = self.myUser
                self.dataView?.isInit = false
                DispatchQueue.main.async {
                    self.dataView?.animateTable()
                    self.loadingView.stopAnimating()
                }
            }
        })
        myTask.resume()
    }
    
    
    func getNoShow(){
        let url = URL(string:"https://api.nasss.ml/api/noshow?token=\(myUser.token)")!
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
                    self.navigationController?.popViewController(animated: true)
                    return
                }
                if myData["error"].string == "查無缺曠資料"{
                    DispatchQueue.main.async {
                        let myAlert = UIAlertController(title: "哎呀！", message: "查無缺曠資料！\n看來是個不翹課的乖學生！", preferredStyle: .alert)
                        myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                            _ in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(myAlert, animated: true, completion: nil)
                    }
                }
                var noShowCount = 0
                var canNoShowCount = 0
                for (_,noShow):(String,JSON) in myData["value"]{
                    var temp = [String()]
                    temp.append(noShow["id"].string!)
                    temp.append(noShow["date"].string!)
                    for j in 1...8{
                        if noShow["course\(j)"].string! == "缺曠"{
                            noShowCount += 1
                        }else if Array(noShow["course\(j)"].string!).count >= 2 {
                            canNoShowCount += 1
                        }
                        print(noShow["course\(j)"].string!)
                        temp.append(noShow["course\(j)"].string!)
                    }
                    temp.remove(at: 0)
                    self.myNoShow.append(temp)
                }
                self.myNoShow.remove(at: 0)
                self.dataView?.myNoShow = self.myNoShow
                self.dataView?.dataType = self.dataType
                self.dataView?.isInit = false
                DispatchQueue.main.async {
                    self.labelOne.text = "曠課節數：\(noShowCount)"
                    self.labelSecond.text = "已請節數：\(canNoShowCount)"
                    self.dataView?.animateTable()
                }
            }
        })
        myTask.resume()
    }
    
    func getMyReward(){
        let url = URL(string:"https://api.nasss.ml/api/reward?token=\(myUser.token)")!
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
                if myData["msg"].string != nil{
                    self.dismiss(animated: true, completion: nil)
                    return
                }
                if myData["status"].string == "沒有獎懲紀錄"{
                    DispatchQueue.main.async {
                        let myAlert = UIAlertController(title: "哎呀！", message: "查不到這學期的獎懲紀錄唷！", preferredStyle: .alert)
                        myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                            _ in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(myAlert, animated: true, completion: nil)
                    }
                }
                var goodReward = 0
                var badRewad = 0
                for (_,noShow):(String,JSON) in myData["value"]{
                    var temp = [String()]
                    temp.append(noShow["date"].string!)
                    temp.append(noShow["count"].string!)
                    temp.append(noShow["info"].string!)
                    temp.append(noShow["category"].string!)
                    temp.remove(at: 0)
                    if noShow["category"].string!.contains("過") || noShow["category"].string!.contains("申"){
                        badRewad += 1
                    }else if noShow["category"].string!.contains("嘉") || noShow["category"].string!.contains("功"){
                        goodReward += 1
                    }
                    self.myReward.append(temp)
                }
                self.myReward.remove(at: 0)
                self.dataView?.isInit = false
                self.dataView?.myReward = self.myReward
                DispatchQueue.main.async {
                    if badRewad > 0 {
                        self.labelOne.text = "哎呀，好像有被記過了，趕快確認一下吧"
                    }else if goodReward > 0{
                        self.labelOne.text = "哎唷！這學期有被記功，不錯麻！"
                    }
                    self.labelSecond.isHidden = true
                    self.labelThird.isHidden = true
                    self.dataView?.animateTable()
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
        if segue.identifier == "dataTableView"{
            dataView = segue.destination as? ShowDataTableViewController
            dataView?.dataType = self.dataType
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
