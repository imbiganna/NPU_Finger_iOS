//
//  CalendarTableViewController.swift
//  NPU_Life
//
//  Created by BigAnna on 2021/8/2.
//

import UIKit

class CalendarTableViewController: UITableViewController {

    var myCal:[Calendar] = [Calendar]()
    var isInit = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isInit{
            return 0
        }else{
            return myCal.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isInit{
            return UITableViewCell()
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! CalendarTableViewCell
            cell.dateLabel.text = myCal[indexPath.row].startTime
            cell.eventLabel.text = myCal[indexPath.row].eventName
            cell.mySuperView = self
            return cell
        }
        

        // Configure the cell...

    }

    func animateTable() {
            self.tableView.reloadData()
            let cells = tableView.visibleCells
            let tableHeight = tableView.bounds.size.height
            
            cells.forEach {
                $0.transform = CGAffineTransform(translationX: 0, y: tableHeight)
            }
            var index = 0
            cells.forEach {
                let cell = $0
                UIView.animate(withDuration: 1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                    }, completion: nil)
                index += 1
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
