//
//  ServerContext.swift
//  bionic-apps
//
//  Created by Vitaliy on 10/28/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import Foundation

class Element : Category {

    var text: String?
    var imageUrl: String?
    
    init(type: String, code: String, text: String?, imageUrl: String?)
    {
        self.text = text
        self.imageUrl = imageUrl
        super.init(type: type, code: code)
    }
    
    static func Question(code: String, text: String, imageUrl: String) -> Element {
        return Element(type: Category.Question, code: code, text: text, imageUrl: imageUrl)
    }
    
    static func Button(code: String, text: String, imageUrl: String) -> Element {
        return Element(type: Category.Button, code: code, text: text, imageUrl: imageUrl)
    }
    
    static func Title(code: String, text: String, imageUrl: String) -> Element {
        return Element(type: Category.Title, code: code, text: text, imageUrl: imageUrl)
    }
    
    static func Fmk(code: String, imageUrl: String) -> Element {
        return Element(type: Category.FMK, code: code, text: nil, imageUrl: imageUrl)
    }
    
    init?(json: Dictionary<String, Any>)
    {
        var code : String?
        var imageUrl : String?
        for (key, value) in json {
            if key == "code" {
                code = value as? String
            }
            else if key == "imageUrl" {
                imageUrl = value as? String
            }
        }
        if let code = code, let imageUrl = imageUrl {
            self.imageUrl = imageUrl
            self.text = ""
            super.init(type: Category.FMKResult, code: code)
        }
        else {
            return nil
        }
    }
    
    static func fromJson(json: Dictionary<String, Any>) -> Element? {
        if let type = json["type"] as? String {
            let code = json["code"] as? String ?? ""
            let imageUrl = json["imageUrl"] as? String
            let text = json["text"] as? String
            return Element(type: type, code: code, text: text, imageUrl: imageUrl)
        }
        return nil
    }
}

// abstract
class Schema : Categories {
    
    var gameIdentifier: UUID?
    var respondents : [String] = []
    
    var elements : [Element] {
        get {
            return categories as! [Element]
        }
    }
    
    var questions : [Element] {
        get {
            let questions = categories.filter { (c: Category) -> Bool in return c.type == Category.Question }
            return questions as! [Element]
        }
    }
    
    var fmks : [Element] {
        get {
            let questions = categories.filter { (c: Category) -> Bool in return c.type == Category.FMK }
            return questions as! [Element]
        }
    }
    
    var buttons : [Element] {
        get {
            let buttons = categories.filter { (c: Category) -> Bool in return c.type == Category.Button }
            return buttons as! [Element]
        }
    }
    
    var titles : [Element] {
        get {
            let titles = categories.filter { (c: Category) -> Bool in return c.type == Category.Title }
            return titles as! [Element]
        }
    }

    var games : [FMKGameItem] {
        get {
            let items = categories.filter { (c: Category) -> Bool in return c.type == Category.FMKResult }
            return items as! [FMKGameItem]
        }
    }
    
    func getMarryKill() -> [FMKGameItem] {
        return self.categories
            .filter { (c: Category) -> Bool in
                if let g = c as? FMKGameItem, let r = g.data {
                    return r == FMKGameItem.Fuck || r == FMKGameItem.Marry
                }
                return false
            } as! [FMKGameItem]
    }
    
    init(type: String, code: String, isFullScreen: Bool, userIdentifier: UUID, gameIdentifier: UUID?) {
        
        self.gameIdentifier = gameIdentifier
        super.init(code: code, type: type, isFullScreen: isFullScreen, userIdentifier: userIdentifier)
    }
    
    
    func toResult() -> FMKGame {
        let result = FMKGame(type: self.type, code: self.code, userIdentifier: self.userIdentifier, gameIdentifier: self.gameIdentifier!)
        return result
    }
    
    static func fromJson(json: Dictionary<String, Any>) -> Schema {
        
        let userIdentifier = UUID(uuidString: (json["userIdentifier"] as? String)!)
        var gameIdentifier : UUID? = nil
        if let g = json["gameIdentifier"] as? String { gameIdentifier = UUID(uuidString: g)}
        
        let type = json["type"] as! String
        let code = json["code"] as! String
        
        let isFullScreen = json["isFullScreen"] as? String ?? "true" == "true"
        let result = Schema(type: type, code: code, isFullScreen: isFullScreen, userIdentifier: userIdentifier!, gameIdentifier: gameIdentifier)
        
        if let respondents = json["respondents"] as? [String] {
            result.respondents = respondents
        }
        
        if let categories = json["categories"] as? [Dictionary<String, Any>] {
            for category in categories {
                if let type = category["type"] as? String, type != Category.FMKResult {
                    result.categories.append(Element.fromJson(json: category)!)
                } else {
                    result.categories.append(FMKGameItem.fromJson(json: category)!)
                }
            }
        }
        return result
    }
}
