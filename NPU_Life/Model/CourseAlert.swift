//
//  CourseAlert.swift
//  NPU_Finger
//
//  Created by BigAnna on 2021/9/21.
//

import Foundation

class CourseAlert:Codable{
    var courseName:String?
    var courseTime:String?
    var courseRoom:String?
    var alertTime:String?
    var alertIsOn:Bool = false
    
    init(Name:String , Time:String ,Room:String){
        self.courseName = Name
        self.courseTime = Time
        self.courseRoom = Room
        if UserDefaults.standard.object(forKey: self.courseName!) != nil{
            self.alertIsOn = UserDefaults.standard.object(forKey: self.courseName!) as! Bool
        }else{
            UserDefaults.standard.setValue(self.alertIsOn, forKey: self.courseName!)
        }
        
    }
    
    func updateSetting (ALERT:Bool){
        self.alertIsOn = ALERT
        UserDefaults.standard.setValue(self.alertIsOn, forKey: self.courseName!)
    }
    
}
