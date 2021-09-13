//
//  CourseTableTableViewController.swift
//  NPU_Life
//
//  Created by BigAnna on 2021/7/25.
//

import UIKit

class CourseTableTableViewController: UITableViewController {
    
    var tableTitle = [" ","一","二","三","四","五","六"]
    var mySetColor:[UIColor] = [UIColor(red: 245/255, green: 250/255, blue: 170/255, alpha: 0.6),UIColor(red: 248/255, green: 195/255, blue: 205/255, alpha: 0.6) , .brown.withAlphaComponent(0.6) , .yellow.withAlphaComponent(0.4), UIColor(red: 238/255, green: 169/255, blue: 169/255, alpha: 0.6) , UIColor(red: 254/255, green: 233/255, blue: 225/255, alpha: 0.6) , .lightGray.withAlphaComponent(0.6) , .orange.withAlphaComponent(0.6) , UIColor(red: 220/255, green: 159/255, blue: 180/255, alpha: 0.6),.red.withAlphaComponent(0.6),.systemTeal.withAlphaComponent(0.6),.systemIndigo.withAlphaComponent(0.6),UIColor(red: 140/255, green: 124/255, blue: 130/255, alpha: 0.6),UIColor(red: 127/255, green: 180/255, blue: 184/255, alpha: 0.6),UIColor(red: 240/255, green: 169/255, blue: 134/255, alpha: 0.6),UIColor(red: 236/255, green: 184/255, blue: 138/255, alpha: 0.6),UIColor(red: 218/255, green: 201/255, blue: 166/255, alpha: 0.6),UIColor(red: 155/255, green: 144/255, blue: 194/255, alpha: 0.6),UIColor(red: 123/255, green: 144/255, blue: 210/255, alpha: 0.6),UIColor(red: 125/255, green: 185/255, blue: 222/255, alpha: 0.6)]
    var myColor:[String:UIColor] = ["TEST" : .blue]
    var user = User()
    var tableDetail = [[String()]]
    var token = User().token
    var height:CGFloat = CGFloat(10.0)
    var isInit = true
    var myTag = 0
    var haveSat:String = "False"
    var isNight:String = "False"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 20
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        haveSat = user.haveSat
    }

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
        haveSat = user.haveSat
        if isInit{
            let cell = UITableViewCell()
            return cell
        }else if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CourseTitleCell", for: indexPath) as! CourseTableViewCell
            for label in cell.WeekNameCollection ?? []{
                if haveSat == "false"{
                    if label.tag == 6{
                        label.isHidden = true
                        label.isEnabled = false
                    }
                    continue
                }
                label.text = tableTitle[label.tag]
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CourseNameCell", for: indexPath) as! CourseNameTableViewCell
            if self.user.stdType == "Night"{
                cell.rowName.text = "\(indexPath.row+9)"
            }else{
                cell.rowName.text = "\(indexPath.row)"
            }
            cell.superVC = self
            cell.myUser = self.user
            for textView in cell.courseDetailButton{
                if textView.tag == 5{
                    if haveSat == "false"{
                        textView.isHidden = true
                        textView.isEnabled = false
                    }
                }
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
        if self.user.stdType == "Night"{
            self.tableView.rowHeight = height / 6.0
        }else{
            self.tableView.rowHeight = height / 10.0
        }
        self.tableView.reloadData()
        let cells = tableView.visibleCells
        let tableHeight = tableView.bounds.size.height
        print(self.height)
        
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


}
