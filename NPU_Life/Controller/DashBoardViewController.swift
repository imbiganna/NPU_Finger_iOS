//
//  DashBoardViewController.swift
//  NPU_Life
//
//  Created by BigAnna on 2021/7/22.
//

import UIKit
import LocalAuthentication
import SafariServices
import SwiftyJSON
class DashBoardViewController: UIViewController {
    
    var user = User()
    var loadSettings = newSettings()
    var dataView : ShowDataViewController?
    var dataType:DataType?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var downView: UIView!
    @IBOutlet weak var stdidLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downView.layer.masksToBounds = true
        downView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        nameLabel.text = "嗨！"+user.name
        stdidLabel.text = user.stdid
        classLabel.text = user.Class
        
        if user.name != "王大明"{
            if UserDefaults.standard.object(forKey: "LOCAL_AUTH_ON") == nil {
                let faceIDAlert = UIAlertController(title: "要啟用生物辨識快速登入嗎", message: "稍後可在設定中更改", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "好阿！", style: .default, handler: {
                    _ in
                    self.faceid()
                })
                faceIDAlert.addAction(UIAlertAction(title: "不要！", style: .destructive, handler: {
                    _ in
                    self.loadSettings.updateSetting(LOCALAUTH: false, AUTOUPDATE: self.loadSettings.AUTO_UPDATE)
                }))
                faceIDAlert.addAction(okAction)
                DispatchQueue.main.async {
                    self.present(faceIDAlert, animated: true, completion: nil)
                }
            }
        }
        
        if let AUTOUPDATE = UserDefaults.standard.object(forKey: "AUTO_UPDATE") as? Bool{
            if AUTOUPDATE == true {
                checkUpdate()
            }
        }
    }
    
    func checkUpdate(){
        let url = URL(string:"https://api.nasss.ml/api/ckeckVersion")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let newURL = URLSession(configuration: .default)
        let myTask = newURL.dataTask(with: request, completionHandler: {
            (data,respond,error) in
            if error != nil {
                return
            }else{
                let myData = JSON(data!)
                if Double(myData["iOS"].string!)! > 1.00{
                    DispatchQueue.main.async {
                        let updateAlert = UIAlertController(title: "發現新版本！", message: "檢查到新版本！要立即前往更新嗎？", preferredStyle: .alert)
                        updateAlert.addAction(UIAlertAction(title: "好阿！", style: .default, handler: {
                            _ in
                            let updateURL = URL(string: myData["URL"].string!)!
                            UIApplication.shared.open(updateURL)
                        }))
                        updateAlert.addAction(UIAlertAction(title: "先不要", style: .cancel, handler: nil))
                        self.present(updateAlert, animated: true, completion: nil)
                    }
                }
            }
        })
        myTask.resume()
        
    }
    
    @IBAction func settingButton(_ sender: UIButton) {
        if user.name == "王大明"{
            self.showMessage(title: "哎呀", message: "你還沒登入沒辦法做設定唷！")
            return
        }
        if let settingsView = self.storyboard?.instantiateViewController(identifier: "settings") as? SettingsTableViewController{
            settingsView.modalPresentationStyle = .pageSheet
            settingsView.settings = loadSettings
            self.present(settingsView, animated: true, completion: nil)
        }
    }
    
    @IBAction func calendarVC(_ sender: UIButton) {
        performSegue(withIdentifier: "goCalendat", sender: nil)
    }
    

    
    @IBAction func showData(_ sender: UIButton) {
        if user.name == "王大明"{
            self.showMessage(title: "哎呀", message: "你還沒登入想做什麼？")
            return
        }
        
        switch sender.tag {
        case 0:
            dataType = .Score
        case 1:
            dataType = .NoShow
        case 2:
            dataType = .Reward
        default:
            return
        }
        performSegue(withIdentifier: "showData", sender: nil)
    }
    

    
    @IBAction func goCourseTable(_ sender: UIButton) {
        if user.name == "王大明"{
            self.showMessage(title: "哎呀", message: "你還沒登入要怎麼看課表呢？")
            return
        }
        performSegue(withIdentifier: "courseTable", sender: nil)
    }
    
    @IBAction func callEmergency(_ sender: Any) {
        let callController = UIAlertController(title: "！！", message: "確定要撥打給校安中心嗎？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "不要", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "確定！", style: .destructive, handler: {
            _ in
            let phoneURL = URL(string: "tel://0928483123")!
            if UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL)
            }
        })
        callController.addAction(cancelAction)
        callController.addAction(okAction)
        present(callController, animated: true, completion: nil)
    }
    
    
    @IBAction func logout(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showMessage(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func faceid(){
        let context = LAContext()
        context.localizedCancelTitle = "取消"
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            if error != nil{
                return
            }
            let reason = "啟用生物辨識快速登入"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { (success, error) in
                if success {
                    DispatchQueue.main.async { [unowned self] in
                        self.showMessage(title: "辨識成功！", message: "已成功啟用快速登入！")
                        self.loadSettings.updateSetting(LOCALAUTH: true, AUTOUPDATE: self.loadSettings.AUTO_UPDATE)
                    }
                } else {
                    self.showMessage(title: "失敗", message: "辨識失敗！可稍後於設定啟用")
                }
            }
        } else {
            showMessage(title: "失敗", message: "辨識失敗！可稍後於設定啟用")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "courseTable"{
            let courseTableView = segue.destination as? CourseTableViewController
            courseTableView?.user = self.user
        }else if segue.identifier == "showData"{
            dataView = segue.destination as? ShowDataViewController
            dataView?.myUser = self.user
            dataView?.dataType = self.dataType

        }
        let backItem = UIBarButtonItem()
        backItem.title = "返回"
        backItem.tintColor = .white
        navigationItem.backBarButtonItem = backItem
        navigationItem.title = "test"
        let barAppearance = UINavigationBarAppearance()
        barAppearance.configureWithTransparentBackground()
        UINavigationBar.appearance().scrollEdgeAppearance = barAppearance
    }
    
}
