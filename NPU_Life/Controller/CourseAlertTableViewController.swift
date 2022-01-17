//
//  CourseAlertTableViewController.swift
//  NPU_Finger
//
//  Created by BigAnna on 2021/9/24.
//

import UIKit

class CourseAlertTableViewController: UITableViewController {

    var alertList:[CourseAlert] = [CourseAlert]()
    var stdType = "Day"
    var defaultTime = 5
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "課程提醒設定"
        let barAppearance =  UINavigationBarAppearance()
        barAppearance.configureWithOpaqueBackground()
        navigationController?.navigationBar.standardAppearance = barAppearance
        if UserDefaults.standard.object(forKey: "setAlertTime") == nil{
            UserDefaults.standard.setValue(5, forKey: "setAlertTime")
        }else{
            defaultTime = UserDefaults.standard.object(forKey: "setAlertTime") as! Int
        }
    }

    // MARK: - Table view data source

    @IBAction func removeOldCourseAlert(_ sender: Any){
        let checkOld = UIAlertController(title: "警告❗️", message: "使用此功能會移除所有通知❗️\n包含現有通知\n確定要執行嗎？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定！", style: .default, handler: {
            _ in
            var haveAny:Bool = false
            let checkAgain = UIAlertController(title: "警告❗️", message: "確定要移除嗎？", preferredStyle: .alert)
            let okAgain = UIAlertAction(title: "確定啦！", style: .default, handler: {
                _ in
                let center = UNUserNotificationCenter.current()
                center.getPendingNotificationRequests(completionHandler: { requests in
                    for request in requests {
                        haveAny = true
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
                        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [request.identifier])
                        UserDefaults.standard.setValue(false, forKey: String(request.identifier.prefix(request.identifier.count-1)))
                    }
                    var turnOffAlert:UIAlertController
                    if haveAny {
                        turnOffAlert = UIAlertController(title: "移除成功！", message: "所有通知已經成功移除\n即將重新開啟App來完成清除", preferredStyle: .alert)
                        turnOffAlert.addAction(UIAlertAction(title: "好！", style: .default, handler: { _ in exit(0)}))

                    }else{
                        turnOffAlert = UIAlertController(title: "哎呀", message: "你好像沒有開啟任何通知耶！", preferredStyle: .alert)
                        turnOffAlert.addAction(UIAlertAction(title: "好！", style: .default, handler: nil))
                    }
                    DispatchQueue.main.async {
                        self.present(turnOffAlert, animated: true, completion: nil)
                    }
                    
                })
                

                
            })
            let cancelAgain = UIAlertAction(title: "不要好了", style: .destructive, handler: nil)
            checkAgain.addAction(okAgain)
            checkAgain.addAction(cancelAgain)
            self.present(checkAgain, animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "不要！", style: .destructive, handler: nil)
        checkOld.addAction(okAction)
        checkOld.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(checkOld, animated: true, completion: nil)
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return alertList.count
        }else{
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "提醒開關"
        }else{
            return "提醒設定"
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "alertList", for: indexPath) as! CourseAlertTableViewCell
            
            cell.courseName.text = alertList[indexPath.row].courseName
            cell.alertSwitch.isOn = self.alertList[indexPath.row].alertIsOn
            cell.superTableView = self

            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "setting_alert", for: indexPath) as! CourseAlertTableViewCell
            cell.defaultTime = self.defaultTime
            cell.alertTIme.text = self.defaultTime.string
            cell.alertTIme.text = defaultTime.string
            cell.superTableView = self
            return cell
        }

    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 105.0
        }else{
            return 44.333
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
