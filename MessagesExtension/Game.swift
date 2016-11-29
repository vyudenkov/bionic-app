
//
//  Game.swift
//  bionic-app
//
//  Created by Vitaliy on 11/23/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import Foundation
import UIKit
import Messages

class FMKGameResponse : Serializable {
    
    var userIdentifier : UUID!
    var data : String!
    
    init(userIdentifier: UUID, data: String)
    {
        self.data = data
        self.userIdentifier = userIdentifier
    }
    
    static func fromJson(json: Dictionary<String, Any>) -> FMKGameResponse? {
        if let userIdentifier = json["userIdentifier"] as? String, let id = UUID(uuidString: userIdentifier) {
            let data = json["data"] as! String
            return FMKGameResponse(userIdentifier: id, data: data)
        }
        return nil
    }
}

class FMKGameInfo : Category {
    
    var title: String!
    
    init(_ code: String, title: String)
    {
        self.title = title
        super.init(type: Category.GameInfo, code: code)
    }
    
    static func fromJson(json: Dictionary<String, Any>) -> FMKGameInfo? {
        if let code = json["code"] as? String, let title = json["title"] as? String {
            
            return FMKGameInfo(code, title: title)
        }
        return nil
    }
}

class FMKGameItem : Category {
    
    static let Fuck = "Fuck"
    static let Marry = "Marry"
    static let Kill = "Kill"
    
    var data : String?
    var imageUrl : String?
    var responses : [FMKGameResponse] = []
    
    init(_ code: String, imageUrl: String?, data: String?)
    {
        self.data = data
        self.imageUrl = imageUrl
        super.init(type: Category.FMKResult, code: code)
    }
    
    static func fromJson(json: Dictionary<String, Any>) -> FMKGameItem? {
        if let code = json["code"] as? String {
            let imageUrl = json["imageUrl"] as? String
            let data = json["data"] as? String
            let result = FMKGameItem(code, imageUrl: imageUrl, data: data!)
            if let responses = json["responses"] as? [Dictionary<String, Any>] {
                for response in responses {
                    result.responses.append(FMKGameResponse.fromJson(json: response)!)
                }
            }
            return result
        }
        return nil
    }
    
    func marryCount() -> Int {
        return self.responses
            .filter { (c: FMKGameResponse) -> Bool in
                return c.data == FMKGameItem.Marry
            }.count
    }
    func fuckCount() -> Int {
        return self.responses
            .filter { (c: FMKGameResponse) -> Bool in
                return c.data == FMKGameItem.Fuck
            }.count
    }
    func killCount() -> Int {
        return self.responses
            .filter { (c: FMKGameResponse) -> Bool in
                return c.data == FMKGameItem.Kill
            }.count
    }
    
}

class FMKGame : Categories, ExecutionContext {
    
    var gameIdentifier : UUID?
    
    var respondents : [String] = []
    
    var games : [FMKGameItem] {
        get {
            let items = categories.filter { (c: Category) -> Bool in return c.type == Category.FMKResult }
            return items as! [FMKGameItem]
        }
    }
    
    var gameInfo : FMKGameInfo? {
        get {
            let items = categories.filter { (c: Category) -> Bool in return c.type == Category.GameInfo }
            if items.count > 0 { return items[0] as? FMKGameInfo }
            return nil
        }
    }
    
    var fmks : [Element] {
        get {
            let items = categories.filter { (c: Category) -> Bool in return c.type == Category.FMK }
            return items as! [Element]
        }
    }
    
    var questions : [Element] {
        get {
            let items = categories.filter { (c: Category) -> Bool in return c.type == Category.Question }
            return items as! [Element]
        }
    }
    
    var buttons : [Element] {
        get {
            let items = categories.filter { (c: Category) -> Bool in return c.type == Category.Button }
            return items as! [Element]
        }
    }
    
    var titles : [Element] {
        get {
            let items = categories.filter { (c: Category) -> Bool in return c.type == Category.Title }
            return items as! [Element]
        }
    }

    
    init(type: String, code: String, userIdentifier: UUID, gameIdentifier: UUID?)
    {
        self.gameIdentifier = gameIdentifier
        //self.title = title
        super.init(code: code, type: type, userIdentifier: userIdentifier)
        super.categories = [ ]
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
    
    static func fromJson(json: Dictionary<String, Any>) -> FMKGame {
        
        let userIdentifier = UUID(uuidString: (json["userIdentifier"] as? String)!)
        var gameIdentifier : UUID? = nil
        if let uuid = json["gameIdentifier"] as? String { gameIdentifier = UUID(uuidString: uuid) }
        
        let type = json["type"] as! String
        let code = json["code"] as! String
        
        let result = FMKGame(type: type, code: code, userIdentifier: userIdentifier!, gameIdentifier: gameIdentifier)
        
        if let respondents = json["respondents"] as? [String] {
            result.respondents = respondents
        }
        
        if let categories = json["categories"] as? [Dictionary<String, Any>] {
            for category in categories {
                if let type = category["type"] as? String, type == Category.FMKResult {
                    result.categories.append(FMKGameItem.fromJson(json: category)!)
                } else if let type = category["type"] as? String, type == Category.GameInfo {
                    result.categories.append(FMKGameInfo.fromJson(json: category)!)
                } else{
                    result.categories.append(Element.fromJson(json: category)!)
                }
            }
        }
        return result
    }
}

extension FMKGame {
    
    var queryItems: [URLQueryItem] {
        return [URLQueryItem(name: "game", value: self.toJsonString()?.toBase64())]
    }
    
    convenience init?(queryItems: [URLQueryItem], isOriginal: Bool) {
        
        if !isOriginal, let response = queryItems.first(where:{$0.name == "response"}), let r = Serializable.fromJson(jsonString: (response.value?.fromBase64()!)!, createFunction: FMKGame.fromJson) {
            self.init(type: r.type, code: r.code, userIdentifier: r.userIdentifier, gameIdentifier: r.gameIdentifier)
            self.categories = r.categories
        } else {
            if let game = queryItems.first(where:{$0.name == "game"}), let r = Serializable.fromJson(jsonString: (game.value?.fromBase64()!)!, createFunction: FMKGame.fromJson) {
                self.init(type: r.type, code: r.code, userIdentifier: r.userIdentifier, gameIdentifier: r.gameIdentifier)
                self.categories = r.categories
            } else {
                return nil
            }
        }
        
    }
    
    convenience init?(message: MSMessage?, isOriginal: Bool) {
        guard let messageURL = message?.url else { return nil }
        guard let urlComponents = NSURLComponents(url: messageURL, resolvingAgainstBaseURL: false), let queryItems = urlComponents.queryItems else { return nil }
        
        self.init(queryItems: queryItems, isOriginal: isOriginal)
    }
}

extension FMKGame {
    
    func render() -> UIImage {
        
        let view = UIView()
        view.layer.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
        
        var images = self.getMarryKill()
        var frame : CGRect
        var imageView : UIImageView
        
        if images.count > 0 {
            if let url = images[0].imageUrl {
                frame = CGRect(x: 0, y: 0, width: 250, height: 250)
                imageView = UIImageView(frame: frame)
                imageView.showImage(imageUrl: url, sync: true)
                view.addSubview(imageView)
            }
        }
        
        if images.count > 1 {
            if let url = images[1].imageUrl {
                frame = CGRect(x: 250, y: 0, width: 250, height: 250)
                imageView = UIImageView(frame: frame)
                imageView.showImage(imageUrl: url, sync: true)
                view.addSubview(imageView)
            }
        }
        
        if images.count > 2 {
            if let url = images[2].imageUrl {
                frame = CGRect(x: 0, y: 250, width: 250, height: 250)
                imageView = UIImageView(frame: frame)
                imageView.showImage(imageUrl: url, sync: true)
                view.addSubview(imageView)
            }
        }
        
        if images.count > 3 {
            if let url = images[3].imageUrl {
                frame = CGRect(x: 250, y: 250, width: 250, height: 250)
                imageView = UIImageView(frame: frame)
                imageView.showImage(imageUrl: url, sync: true)
                view.addSubview(imageView)
            }
        }
        
        return UIImage(view: view)
    }
}


