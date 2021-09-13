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
import Photos
import PhotosUI

class DashBoardViewController: UIViewController {
    var user = User()
    var loadSettings = newSettings()
    var dataView : ShowDataViewController?
    var dataType:DataType?
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var downView: UIView!
    @IBOutlet weak var stdidLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(changePhoto))
        self.imageButton.addGestureRecognizer(pressGesture)
        let settingImage = UIImage(named: "SETTINGIMG")!.withRenderingMode(.alwaysTemplate)
        settingButton.setImage(settingImage, for: .normal)
        settingButton.tintColor = .white
        
        
        downView.layer.masksToBounds = true
        downView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        nameLabel.text = "嗨！"+user.name
        stdidLabel.text = user.stdid
        classLabel.text = user.Class
        
        if user.name != "訪客模式"{
            if UserDefaults.standard.object(forKey: "LOCAL_AUTH_ON") == nil {
                let localAuthAlert = UIAlertController(title: "要啟用生物辨識快速登入嗎", message: "稍後可在設定中更改", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "好阿！", style: .default, handler: {
                    _ in
                    self.localAuth()
                })
                localAuthAlert.addAction(UIAlertAction(title: "不要！", style: .destructive, handler: {
                    _ in
                    self.loadSettings.updateSetting(LOCALAUTH: false, AUTOUPDATE: self.loadSettings.AUTO_UPDATE)
                }))
                localAuthAlert.addAction(okAction)
                DispatchQueue.main.async {
                    self.present(localAuthAlert, animated: true, completion: nil)
                }
            }
            if UserDefaults.standard.object(forKey: "profile\(self.user.stdid)") != nil{
                let profilePhoto = (UserDefaults.standard.object(forKey: "profile\(self.user.stdid)") as? Data)!
                let mySaveImage = UIImage(data: profilePhoto)!
                self.imageButton.setImage(mySaveImage, for: .normal)
            }
        }
        
        if let AUTOUPDATE = UserDefaults.standard.object(forKey: "AUTO_UPDATE") as? Bool{
            if AUTOUPDATE == true {
                checkUpdate()
            }
        }
    }
    
    @objc func changePhoto(){
        let myChangeAlert = UIAlertController(title: "想換頭嗎？", message:nil, preferredStyle: .actionSheet)
        myChangeAlert.addAction(UIAlertAction(title: "從相簿挑選！", style: .default, handler: {
            _ in
            self.selectPhoto()
        }))
        myChangeAlert.addAction(UIAlertAction(title: "沒事啦哈哈", style: .cancel, handler: nil))
        self.present(myChangeAlert, animated: true, completion: nil)
    }
    
    func checkUpdate(){
        let url = URL(string:"https://app.npu.edu.tw/api/ckeckVersion")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let newURL = URLSession(configuration: .default)
        let myTask = newURL.dataTask(with: request, completionHandler: {
            (data,respond,error) in
            if error != nil {
                return
            }else{
                let myData = JSON(data!)
                if myData["iOS"].string! != "1.21" && myData["iOS"].string! != "1.2"{
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
        if user.name == "訪客模式"{
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
        if user.name == "訪客模式"{
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
    

    
    @IBAction func showGread(_ sender: FancyButton) {
        if user.name == "訪客模式"{
            self.showMessage(title: "哎呀", message: "你還沒登入想做什麼？")
            return
        }
        performSegue(withIdentifier: "showGread", sender: nil)
    }
    @IBAction func goCourseTable(_ sender: UIButton) {
        if user.name == "訪客模式"{
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
    
    func localAuth(){
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
                        showMessage(title: "辨識成功！", message: "已成功啟用快速登入！")
                        loadSettings.updateSetting(LOCALAUTH: true, AUTOUPDATE: self.loadSettings.AUTO_UPDATE)
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
        }else if segue.identifier == "showGread"
        {
            let greadView = segue.destination as? GreaduateViewController
            greadView?.myUser = self.user
        }
        let backItem = UIBarButtonItem()
        backItem.title = "返回"
        backItem.tintColor = .white
        navigationItem.backBarButtonItem = backItem
    }
    
}

extension DashBoardViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    func selectPhoto(){
        checkAuth()
    }
    
    func takePhoto(){
        let controller = UIImagePickerController()
        controller.sourceType = .camera
        controller.delegate = self

    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let myImage = info[.editedImage] as? UIImage
        let imageData = myImage?.jpegData(compressionQuality: 1.0)
        if imageData != nil {
            UserDefaults.standard.setValue(imageData, forKey: "profile\(self.user.stdid)")
        }
        self.dismiss(animated: true, completion: nil)
        DispatchQueue.main.async {
            self.imageButton.setImage(myImage, for: .normal)
        }
        
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkAuth(){
        let photoLibraryStatus = PHPhotoLibrary.authorizationStatus()
        switch photoLibraryStatus {
        case .denied:
            let alertController = UIAlertController(title: "哎呀！", message: "你好像沒有允許使用相簿耶\n要去設定允許嗎？", preferredStyle: .alert)
            let settingAction = UIAlertAction(title: "好阿", style: .default, handler: { (action) in
                let url = URL(string: UIApplication.openSettingsURLString)
                    if let url = url, UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
            })
            alertController.addAction(UIAlertAction(title: "先不要", style: .cancel, handler: nil))
            alertController.addAction(settingAction)
            self.present(alertController, animated: true, completion: nil)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (statusFirst) in
                self.selectPhoto()
            })
        case .authorized:
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = .photoLibrary
            controller.allowsEditing = true
            self.present(controller, animated: true, completion: nil)
        default:
            let alertController = UIAlertController(title: "哎呀！", message: "你好像沒有允許使用相簿耶\n要去設定允許嗎？", preferredStyle: .alert)
            let settingAction = UIAlertAction(title: "好阿", style: .default, handler: { (action) in
                let url = URL(string: UIApplication.openSettingsURLString)
                    if let url = url, UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
            })
            alertController.addAction(UIAlertAction(title: "先不要", style: .cancel, handler: nil))
            alertController.addAction(settingAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
