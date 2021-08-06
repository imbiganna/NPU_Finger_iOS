//
//  ViewController.swift
//  NPU_Life
//
//  Created by BigAnna on 2021/7/20.
//

import UIKit
import SwiftyJSON
import LocalAuthentication

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var uidTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var myUser = User()
    
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
        uidTextField.delegate = self
        initApp()

    }

    @IBAction func guestMode(_ sender: Any) {
        myUser.name = "王大明"
        myUser.stdid = "8888888888"
        myUser.Class = "尚未登入"
        self.performSegue(withIdentifier: "goDashboard", sender: nil)
    }
    @IBAction func loginButton(_ sender: UIButton) {
        goLogin()
    }
    
    func goLogin(){
        if uidTextField.text == "" || pwdTextField.text == "" {
            showMessage(title: "糟糕！！", message: "請輸入帳號密碼")
        }else if uidTextField.text!.count < 10 || pwdTextField.text!.count > 10{
            showMessage(title: "糟糕！", message: "請檢查帳號密碼格式\n密碼僅限十位")
        }else if !uidTextField.text![0].isNumber && uidTextField.text![1].isNumber{
            showMessage(title: "糟糕！", message: "暫不開放教職員登入")
        }else
        {
            loadingView.startAnimating()
            myUser.pwd = self.pwdTextField.text!
            let myUid = uidTextField.text!
            let myPwd = pwdTextField.text!
            getToken(userID: myUid, userPWD: myPwd)
        }
    }
    
    func getToken(userID uid:String , userPWD pwd:String){
        let url = URL(string:"https://api.nasss.ml/api/login?")!
        let postUser:String = "uid=\(uid)&pwd=\(pwd)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postUser.data(using: String.Encoding.utf8)
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
            }else{
                let myToken = JSON(data!)
                if myToken["error"].string! == "帳號密碼錯誤" || myToken["error"].string! == "帳號或密碼為空"{
                    self.myUser.token = "Error"
                    DispatchQueue.main.async {
                        self.showMessage(title: "糟糕！！", message: "帳號或密碼錯誤")
                        self.loadingView.stopAnimating()
                    }
                }else{
                    self.myUser.token = myToken["token"].string!
                    self.getUserInfo(UserToken: self.myUser.token)
                }
            }
        })
        myTask.resume()
    }
    
    func getUserInfo(UserToken token:String){
        let url = URL(string:"https://api.nasss.ml/api/info?token=\(token)")!
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
                self.myUser.Class = myData["myClass"].string!
                self.myUser.grade = myData["grade"].string!
                self.myUser.name = myData["name"].string!
                self.myUser.stdid = myData["stdid"].string!
                DispatchQueue.main.async {
                    UserDefaults.standard.setValue(self.uidTextField.text!, forKey: "uid")
                    UserDefaults.standard.setValue(self.pwdTextField.text!, forKey: "pwd")
                    self.pwdTextField.text = ""
                    self.performSegue(withIdentifier: "goDashboard", sender: nil)
                    self.myUser = User()
                    self.loadingView.stopAnimating()
                    
                }
            }
        })
        myTask.resume()
    }
    
    func faceid(){
        let context = LAContext()
        context.localizedCancelTitle = "取消"
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            if error != nil{
                return
            }
            let reason = "快速登入你的帳號"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { (success, error) in
                if success {
                    DispatchQueue.main.async { [unowned self] in
                        self.pwdTextField.text = self.myUser.pwd
                        self.goLogin()
                    }
                }
            }
        }
    }
    
    func initApp(){
        loginView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        if let loaduser = UserDefaults.standard.object(forKey: "uid") as? String {
            myUser.stdid = loaduser
        }

        if let loaduser = UserDefaults.standard.object(forKey: "pwd") as? String {
            myUser.pwd = loaduser
            if let LOCALAUTH = UserDefaults.standard.object(forKey: "LOCAL_AUTH_ON") as? Bool{
                if LOCALAUTH == true {
                    faceid()}
            }
        }
        if myUser.stdid != ""{
            uidTextField.text = myUser.stdid
        }
    }
    
    func showMessage(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.loadingView.stopAnimating()
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == uidTextField{
            pwdTextField.becomeFirstResponder()
        }else{
            textField.endEditing(true)
            goLogin()
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDashboard"{
            let dashView = segue.destination as? DashBoardViewController
            dashView?.user = myUser
            dashView?.modalPresentationStyle = .fullScreen
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let text = textField.text!
            let len = text.count + string.count - range.length
        
            return len<=10
    }

    
}

extension StringProtocol {
    subscript(_ offset: Int)                     -> Element     { self[index(startIndex, offsetBy: offset)] }
    subscript(_ range: Range<Int>)               -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: ClosedRange<Int>)         -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: PartialRangeThrough<Int>) -> SubSequence { prefix(range.upperBound.advanced(by: 1)) }
    subscript(_ range: PartialRangeUpTo<Int>)    -> SubSequence { prefix(range.upperBound) }
    subscript(_ range: PartialRangeFrom<Int>)    -> SubSequence { suffix(Swift.max(0, count-range.lowerBound)) }
}
extension LosslessStringConvertible {
    var string: String { .init(self) }
}

extension BidirectionalCollection {
    subscript(safe offset: Int) -> Element? {
        guard !isEmpty, let i = index(startIndex, offsetBy: offset, limitedBy: index(before: endIndex)) else { return nil }
        return self[i]
    }
}
