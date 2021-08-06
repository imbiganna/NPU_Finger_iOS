//
//  CourseTableTableViewController.swift
//  NPU_Life
//
//  Created by BigAnna on 2021/7/25.
//

import UIKit

class CourseTableTableViewController: UITableViewController {
    
    var tableTitle = [" ","一","二","三","四","五"]
    var mySetColor:[UIColor] = [.blue.withAlphaComponent(0.6) , .brown.withAlphaComponent(0.6) , .yellow.withAlphaComponent(0.6), .gray.withAlphaComponent(0.6) , .green.withAlphaComponent(0.6) , .lightGray.withAlphaComponent(0.6) , .orange.withAlphaComponent(0.6) , .purple.withAlphaComponent(0.6),.red.withAlphaComponent(0.6),.systemTeal.withAlphaComponent(0.6)]
    var myColor:[String:UIColor] = ["TEST" : .blue]
    var user = User()
    var tableDetail = [[String()]]
    var token = User().token
    var height:CGFloat = CGFloat(10.0)
    var isInit = true
    var myTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 20
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    // MARK: - Table view data source
    func getColor() {
        for table in user.course{
            for courseName in table{
                if myColor.keys.contains((courseName?.courseName)!){
                    continue
                }else{
                    let randNum = Int.random(in:Range(0...mySetColor.count-1))
                    myColor[(courseName?.courseName)!] = mySetColor[randNum]
                    mySetColor.remove(at: randNum)
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.course.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isInit{
            let cell = UITableViewCell()
            return cell
        }else if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CourseTitleCell", for: indexPath) as! CourseTableViewCell
            for label in cell.WeekNameCollection ?? []{
                label.text = tableTitle[label.tag]
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CourseNameCell", for: indexPath) as! CourseNameTableViewCell
            cell.rowName.text = "\(indexPath.row)"
            cell.superVC = self
            cell.myUser = self.user
            for textView in cell.courseDetailButton{
                let index = textView.tag
                user.course[indexPath.row-1][index]?.tag = myTag
                textView.setTitle(user.course[indexPath.row-1][index]?.courseName, for: .normal)
                textView.titleLabel?.adjustsFontSizeToFitWidth = true
                if user.course[indexPath.row-1][index]?.courseName != " "{
                    textView.backgroundColor = myColor[(user.course[indexPath.row-1][index]?.courseName)!]
                }else{
                    textView.isEnabled = false
                }
                textView.tag = myTag
                myTag += 1
            }
            return cell
        }
    }
    
    func animateTable() {
            self.tableView.rowHeight = height / 10.0
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
