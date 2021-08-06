//
//  ShowDataTableViewController.swift
//  NPU_Finger
//
//  Created by BigAnna on 2021/8/5.
//

import UIKit

class ShowDataTableViewController: UITableViewController {
    
    var isInit = true
    var user = User()
    var dataType:DataType?
    var myNoShow = [[String()]]
    var myReward = [[String()]]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isInit{
            return 1
        }
        
        switch dataType {
        case .Score:
            return user.score.count + 1
        case .NoShow:
            return self.myNoShow.count + 1
        case .Reward:
            return self.myReward.count + 1
        default:
            return 0
        }

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isInit{
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingTableViewCell
            cell.loading.startAnimating()
            return cell
        }
        if dataType == .Score{
            if indexPath.row == 0{
                let scoreTitle:[String] = ["科目","期中成績","期末成績"]
                let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath) as! ScoreTableViewCell
                cell.courseName.text = scoreTitle[0]
                cell.midScore.text = scoreTitle[1]
                cell.finalScore.text = scoreTitle[2]
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath) as! ScoreTableViewCell
                cell.courseName.text = user.score[indexPath.row-1]?.courseName
                cell.midScore.text = user.score[indexPath.row-1]?.midScore
                cell.finalScore.text = user.score[indexPath.row-1]?.finalScore
                return cell
            }
        }else if dataType == .NoShow{
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "NoShowCell", for: indexPath) as! NoShowTableViewCell
                let needPrint = ["日期","1","2","3","4","5","6","7","8"]
                for myLabel in cell.labelCollection{
                    myLabel.text = needPrint[myLabel.tag]
                    myLabel.font.withSize(20)
                }
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "NoShowCell", for: indexPath) as! NoShowTableViewCell
                for myLabel in cell.labelCollection{
                    myLabel.text = self.myNoShow[indexPath.row-1][myLabel.tag + 1]
                }
                return cell
            }
        }else if dataType == .Reward{
            let cell = tableView.dequeueReusableCell(withIdentifier: "rewardCell", for: indexPath) as! RewardTableViewCell
            for myLabel in cell.labelOutlet{
                if indexPath.row == 0 {
                    let mytitle = ["日期","數量","事由","類別"]
                    myLabel.text = mytitle[myLabel.tag]
                }else{
                    myLabel.text = myReward[indexPath.row-1][myLabel.tag]
                }
            }
            return cell
        }
        else{
            let cell = UITableViewCell()
            return cell
        }
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
    

}
