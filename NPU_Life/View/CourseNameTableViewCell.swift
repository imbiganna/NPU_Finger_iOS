//
//  CourseNameTableViewCell.swift
//  NPU_Life
//
//  Created by BigAnna on 2021/7/26.
//

import UIKit

class CourseNameTableViewCell: UITableViewCell {

        
    @IBOutlet var courseDetailButton: [UIButton]!
    @IBOutlet weak var rowName: UILabel!
    var myUser = User()
    var superVC:CourseTableTableViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func anyCourse(_ sender: UIButton) {
        for course in myUser.course{
            for myCourse in course{
                if myCourse?.courseName == sender.currentTitle{
                    var tmpCourseName = myCourse?.courseName
                    if myCourse?.fullCourseName != ""{
                        tmpCourseName = myCourse?.fullCourseName
                    }
                    alertCourse(CourseName: tmpCourseName!, CourseRoom: (myCourse?.courseRoom)!, Teacher: (myCourse?.courseTeacher)!)
                }
            }
        }
    }
    
    
    func alertCourse(CourseName name:String ,CourseRoom room:String , Teacher teacher:String){
        let myAlert = UIAlertController(title: "科目名稱：\(name)", message: "👨🏻‍🏫授課老師：\(teacher) 老師\n⛪️上課教室：\(room)", preferredStyle: .alert)
        myAlert.addAction(UIAlertAction(title: "好！", style: .default, handler: nil))
        superVC?.present(myAlert, animated: true, completion: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
