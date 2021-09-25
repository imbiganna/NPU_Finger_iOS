//
//  GreaduateViewController.swift
//  NPU_Finger
//
//  Created by BigAnna on 2021/8/16.
//

import UIKit
import WebKit
import SwiftyJSON

class GreaduateViewController: UIViewController {
    let searchItem = ["查詢畢業審核結果","查詢欠修學分","查詢畢業審核結果(明細)"]
    var myUser = User()
    var picker = UIPickerView()
    var toolBar = UIToolbar()
    var nowSelect = 0
    @IBOutlet weak var pdfWebView: WKWebView!
    @IBOutlet weak var loadinView: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let barAppearance =  UINavigationBarAppearance()
        barAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = barAppearance
        loadinView.startAnimating()
        getMyPDF()
    }
    
    @IBAction func selectSearch(_ sender: UIButton) {
        picker = UIPickerView.init()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.white
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.size.width, height: 250)
        picker.selectRow(nowSelect, inComponent: 0, animated: true)
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(self.picker)
        }, completion: nil)
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.size.width, height: 40))
        toolBar.barStyle = .default
        toolBar.items = [UIBarButtonItem.init(title: "完成", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(self.toolBar)
        }, completion: nil)
    }
    
    
    @objc func onDoneButtonTapped(){
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.toolBar.removeFromSuperview()
            self.picker.removeFromSuperview()
        }, completion: nil)
        getMyPDF()
    }

    func getMyPDF(){
        let url = URL(string:"https://app.npu.edu.tw/api/getGreaduate?token=\(myUser.token)&numberOf=0\(nowSelect+1)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        self.loadinView.startAnimating()
        let newURL = URLSession(configuration: .default)
        let myTask = newURL.dataTask(with: request, completionHandler: {
            (data,respond,error) in
            if error != nil {
                return
            }else{
                let myData = JSON(data!)
                let myURL = myData["URL"].string!
                let randID = myData["randID"].string!
                let randVal = myData["randVal"].string!
                let cookieFirst = HTTPCookie(properties: [
                    .domain: "as1.npu.edu.tw",
                    .path: "/",
                    .name: randID,
                    .value: randVal,
                    .secure: "FALSE",
                    .expires: NSDate(timeIntervalSinceNow: 31556926)
                ])!

                DispatchQueue.main.async {
                    let URLRequest = URLRequest(url: URL(string: myURL)!)
                    self.pdfWebView.configuration.websiteDataStore.httpCookieStore.setCookie(cookieFirst, completionHandler: nil)
                    self.pdfWebView.load(URLRequest)
                    self.loadinView.stopAnimating()
                    
                }
            }
        })
        myTask.resume()

    }
}

extension GreaduateViewController : UIPickerViewDataSource , UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return searchItem[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        nowSelect = row
    }
    
    
}
