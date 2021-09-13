//
//  user.swift
//  NPU_Life
//
//  Created by BigAnna on 2021/7/22.
//

import Foundation

class User{
    var pwd:String = ""
    var grade:String? = ""
    var Class:String = ""
    var name:String = ""
    var stdid:String = ""
    var token:String = ""
    var course:[[Course?]] = [[Course]()]
    var score:[Score?] = [Score]()
    var haveSat:String = "False"
    var stdType:String = "Day"
}
