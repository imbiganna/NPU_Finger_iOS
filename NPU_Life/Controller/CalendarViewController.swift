//
//  CalendarViewController.swift
//  NPU_Life
//
//  Created by BigAnna on 2021/7/30.
//

import UIKit
import SwiftyJSON

class CalendarViewController: UIViewController{
    
    @IBOutlet weak var dateBarTextField: UITextField!
    @IBOutlet weak var dolphinLoading: LoadingImages!
    
    let today = Date()
    let dateFormatter = DateFormatter()
    
    var calYear = ["2021","2022"]
    var calMonth = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    var nowRow = [0,0]
    var isInit = true
    @IBOutlet weak var myContainer: UIView!
    var calTableView:CalendarTableViewController?
    var myCal:[Calendar] = [Calendar]()
    var selectYear = "2021"
    var selectMonth = "08"
    var pickerField:UITextField!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    
    @IBAction func selectDone(_ sender: UIBarButtonItem) {
        pickerField.resignFirstResponder()
        dateBarTextField.text = "\(selectYear)-\(selectMonth)"
        getCalenderList(queryYear: selectYear, queryMonth: selectMonth)
    }
    
    @IBAction func seleceCancel(_ sender: UIBarButtonItem) {
        pickerField.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dolphinLoading.rotate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myContainer.layer.cornerRadius = 20
        myContainer.layer.masksToBounds = true
        dateBarTextField.delegate = self
        let barAppearance =  UINavigationBarAppearance()
        barAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = barAppearance
        dateFormatter.dateFormat = "MM"
        let month = dateFormatter.string(from: today)
        getCalenderList(queryYear: "2021", queryMonth: month)

    
    }
    
    func initPickerView(){
        isInit = false
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .systemBlue
        toolBar.sizeToFit()
        //加入toolbar的按鈕跟中間的空白
        let doneButton = UIBarButtonItem(title: "確認", style: .plain, target: self, action: #selector(selectDone))
        //將doneButton設定跟pickerView一樣的tag，submit方法裡可以比對要顯示哪個textField的text
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolBar.setItems([spaceButton, doneButton], animated: false)
        //設定toolBar可以使用
        toolBar.isUserInteractionEnabled = true
        
        //初始化textField，要先加入subView，才能設定他的inputView跟inputAccessoryView
        pickerField = UITextField(frame: CGRect.zero)
        view.addSubview(pickerField)
        pickerField.inputView = pickerView
        pickerField.inputAccessoryView = toolBar
        //彈出pickerField
        pickerField.becomeFirstResponder()
        pickerView.selectRow(nowRow[0], inComponent: 0, animated: false)
        pickerView.selectRow(nowRow[1], inComponent: 1, animated: false)

    }
    
    
    func getCalenderList(searchItems query:String = "",queryYear year:String , queryMonth month:String){
        self.dolphinLoading.isHidden = false
        let key = "GOOGLE API KEY"
        let calID = "gms.npu.edu.tw_dktg99t2p2sqlvcoorpd67h7ok@group.calendar.google.com"
        let queryMoneth = "\(year)-\(month)"
        let startTime = "\(queryMoneth)-01T00:00:00Z"
        var endTime = "\(queryMoneth)-\(getDay(year: year, month: month))T23:59:59Z"
        if isInit{
            endTime = "2022-06-30T23:59:59Z"
        }
        var getURL = "https://www.googleapis.com/calendar/v3/calendars/\(calID)/events?key=\(key)&timeMin=\(startTime)&timeMax=\(endTime)"
        if query != ""{
            getURL += "&q=\(query)"
        }
        let url = URL(string:getURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let newURL = URLSession(configuration: .default)
        let myTask = newURL.dataTask(with: request, completionHandler: {
            (data,respond,error) in
            if error != nil {
                print(error!.localizedDescription)
            }else{
                let data = JSON(data!)
                self.myCal = [Calendar]()
                if data["items"][0]["summary"].string == nil{
                    let alert = UIAlertController(title: "哎呀", message: "這個月份沒有任何事件！", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                    return
                }
                for (_,myData) in data["items"]{
                    let tempCal = Calendar()
                    tempCal.eventName = myData["summary"].string!
                    
                    if myData["start"]["date"].string != nil {
                        tempCal.startTime = myData["start"]["date"].string!
                    }else{
                        tempCal.startTime = myData["start"]["dateTime"].string!
                    }
                    if myData["end"]["date"].string != nil{
                        tempCal.startTime = myData["end"]["date"].string!
                    }else{
                        tempCal.startTime = myData["end"]["dateTime"].string!
                    }
                    self.myCal.append(tempCal)
                }
                DispatchQueue.main.async {
                    self.calTableView?.myCal = self.myCal
                    self.calTableView?.isInit = false
                    self.calTableView?.animateTable()
                    self.dolphinLoading.isHidden = true
                }

            }
        })
        myTask.resume()
    }
    
    func getDay(year:String ,month:String) -> String{
        let yearInt = Int(year)!
        var day = [31,28,31,30,31,30,31,31,30,31,30,31]
        if (yearInt%4) == 0 && (yearInt%100) != 0 || (yearInt%400) == 0{
            day[1] = 29
        }
        return String(day[Int(month)!-1])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CalTableView"{
            calTableView = segue.destination as? CalendarTableViewController
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        dateBarTextField.text = "\(selectYear)-\(selectMonth)"
        getCalenderList(queryYear: selectYear, queryMonth: selectMonth)
    }
}

extension CalendarViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            self.initPickerView()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension CalendarViewController : UIPickerViewDelegate,UIPickerViewDataSource{

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return 2
        }else{
            return 12
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return calYear[row]
        }else{
            return calMonth[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            self.selectYear = calYear[row]
            nowRow[0]=row
        }else{
            if row < 9{
                self.selectMonth = "0" + calMonth[row]
            }else{
                self.selectMonth =  calMonth[row]
            }
            nowRow[1]=row
        }
    }
}

