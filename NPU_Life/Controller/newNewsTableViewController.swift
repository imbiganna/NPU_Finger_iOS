//
//  NewsTableViewController.swift
//  NPU_Life
//
//  Created by BigAnna on 2021/7/23.
//

import UIKit
import SwiftyJSON
import SafariServices

class newNewsTableViewController: UITableViewController {
    var newsTitleArray = [String]()
    var newsDateArray = [String]()
    var newsTeamArray = [String]()
    var newsURL = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getNewsList()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsTitleArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "newsInfoCell", for: indexPath) as? newNewsTableViewCell{
            cell.newsTitle.text = newsTitleArray[indexPath.row]
            cell.newsDate.text = newsDateArray[indexPath.row]
            cell.newsTeam.text = newsTeamArray[indexPath.row]
            return cell
        }else{
            let cell = UITableViewCell()
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let safariVC = SFSafariViewController(url: URL(string: newsURL[indexPath.row])!)
        present(safariVC, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section){
        case 0 : return "校園公告"
        default : return nil
        }
    }
    
    
    func getNewsList(){
        let url = URL(string:"https://api.nasss.ml/api/newsList")!
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
                for (_,news):(String,JSON) in myData{
                    self.newsTitleArray.append(news["newsTitle"].string!)
                    self.newsDateArray.append(news["newsDate"].string!)
                    self.newsTeamArray.append(news["newsTeam"].string!)
                    self.newsURL.append(news["newsURL"].string!)
                }
                DispatchQueue.main.async {
                    self.animateTable()
                }
            }
        })
        myTask.resume()
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
