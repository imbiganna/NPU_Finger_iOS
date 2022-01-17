//
//  Settings.swift
//  NPU_Life
//
//  Created by BigAnna on 2021/7/23.
//

import Foundation

class newSettings{
    var LOCAL_AUTH:Bool?
    var AUTO_UPDATE:Bool = true
    var DASHBOARD_WEATHER:Bool = false
    func updateSetting (LOCALAUTH:Bool , AUTOUPDATE:Bool, DASHBOARD_WEATHER:Bool){
        self.LOCAL_AUTH = LOCALAUTH
        self.AUTO_UPDATE = AUTOUPDATE
        self.DASHBOARD_WEATHER = DASHBOARD_WEATHER
        UserDefaults.standard.setValue(LOCALAUTH, forKey: "LOCAL_AUTH_ON")
        UserDefaults.standard.setValue(AUTOUPDATE, forKey: "AUTO_UPDATE")
        UserDefaults.standard.setValue(DASHBOARD_WEATHER, forKey: "DASHBOARD_WEATHER")
    }
    
    init(){
        if UserDefaults.standard.object(forKey: "LOCAL_AUTH_ON") != nil{
            self.LOCAL_AUTH = UserDefaults.standard.object(forKey: "LOCAL_AUTH_ON") as? Bool
            self.AUTO_UPDATE = UserDefaults.standard.object(forKey: "AUTO_UPDATE") as! Bool
        }
        if UserDefaults.standard.object(forKey: "DASHBOARD_WEATHER") != nil{
            self.DASHBOARD_WEATHER = UserDefaults.standard.object(forKey: "DASHBOARD_WEATHER") as! Bool
        }

        
    }
}

