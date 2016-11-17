//
//  Settings.swift
//  bionic-app
//
//  Created by Vitaliy on 11/16/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import Foundation
import UIKit

class Settings {

    static let SERVER_PATH : String = "SERVER_PATH"
    
    static var settings : NSDictionary {
        get {
            guard let path = Bundle.main.path(forResource: "Info", ofType: "plist") else { fatalError("settings file absent") }
            return NSDictionary(contentsOfFile: path)!
        }
    }
    static var serverPath : String {
        get {
            return settings[SERVER_PATH] as! String
        }
    }
}
