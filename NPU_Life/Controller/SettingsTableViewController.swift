//
//  SettingsTableViewController.swift
//  NPU_Life
//
//  Created by BigAnna on 2021/7/23.
//

import UIKit
import LocalAuthentication
import SafariServices

class SettingsTableViewController: UITableViewController {
 
    @IBOutlet weak var LOCAL_AUTH_BUTTON: UISwitch!
    @IBOutlet weak var AUTO_UPDATE_BUTTON: UISwitch!
    @IBOutlet weak var myTextView: UITextView!
    var settings = newSettings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LOCAL_AUTH_BUTTON.isOn = settings.LOCAL_AUTH!
        AUTO_UPDATE_BUTTON.isOn = settings.AUTO_UPDATE
        myTextView.text = "All Apps icon made by Freepik.com"
    }

    @IBAction func LOCALAUTH(_ sender: UISwitch) {
        if sender.isOn {
            let context = LAContext()
            context.localizedCancelTitle = "取消"
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                let reason = "啟用生物辨識快速登入"
                // 評估指定方案
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { (success, error) in
                    if success {
                        DispatchQueue.main.async { [unowned self] in
                            self.settings.updateSetting(LOCALAUTH: self.LOCAL_AUTH_BUTTON.isOn, AUTOUPDATE: self.settings.AUTO_UPDATE)
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.settings.updateSetting(LOCALAUTH: sender.isOn, AUTOUPDATE: self.settings.AUTO_UPDATE)
                            self.LOCAL_AUTH_BUTTON.isOn = false
                        }
                    }
                }
            }
        }else{
            settings.updateSetting(LOCALAUTH: sender.isOn, AUTOUPDATE: settings.AUTO_UPDATE)
            self.LOCAL_AUTH_BUTTON.isOn = false
        }

    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            let myURL = ["https://www.instagram.com/imbiganna","https://github.com/a29174332/NPU_Finger_iOS","https://forms.gle/7Lbnx7B5zKCge6Lu5"]
            let safariVC = SFSafariViewController(url: URL(string: myURL[indexPath.row])!)
            present(safariVC, animated: true, completion: nil)
        }

        
    }
    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }*/

    /* override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return icon.count
    }*/

    
    /*override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "settitem", for: indexPath) as? SettingsTableViewCell{
            cell.icon.image = UIImage(named: icon[indexPath.row])
            cell.title.text = Mytitle[indexPath.row]
            return cell
        }else{
            let cell = UITableViewCell()
            return cell
        }

    }*/
    
    /*override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "設定"
        default:
            return nil
        }
    }*/

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
