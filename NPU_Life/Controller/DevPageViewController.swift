//
//  DevPageViewController.swift
//  NPU_Finger
//
//  Created by BigAnna on 2021/9/21.
//

import UIKit
import SwiftyJSON
class DevPageViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func testButton(_ sender: UIButton) {
        let content = UNMutableNotificationContent()
        content.title = "上課提醒"
        content.subtitle = "課程名稱：網路程式設計"
        content.body = "上課地點：E001"
        content.badge = 0
        content.sound = .default
        
        var date = DateComponents()
        date.weekday = 5
        date.hour = 19
        date.minute = 42
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "courseAlert", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler:{ _ in
            DispatchQueue.main.async {
                self.showMessage(title: "新增通知成功", msg: "成功")
            }
        })
        
    }
    
    func showMessage(title:String? ,msg:String?){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }

}
