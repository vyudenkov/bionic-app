//
//  History.swift
//  bionic-app
//
//  Created by Vitaliy on 11/17/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import Foundation

class HistoryItem : Serializable {
    
    var gameIdentifier : UUID
    var title : String
    
    var percentDone : Double
    
    var gameItems : [String] = []
    
    init (gameIdentifier: UUID, title: String, percentDone: Double) {
        self.percentDone = percentDone
        self.gameIdentifier = gameIdentifier
        self.title = title
    }
}


class History {
    
    var userIdentifier : UUID
    
    var items : [HistoryItem] = []
    
    init (userIdentifier: UUID) {
        self.userIdentifier = userIdentifier
    }
    
    static func fromJson(json: Dictionary<String, Any>) -> History {
        
        let userIdentifier = UUID(uuidString: (json["userIdentifier"] as? String)!)
        
        let result = History(userIdentifier: userIdentifier!)
        
        if let categories = json["items"] as? [Dictionary<String, Any>] {
            for category in categories {
                let gameIdentifier = UUID(uuidString: (category["gameIdentifier"] as? String)!)
                let title = category["title"] as! String
                let percentDone = category["percentDone"] as! Double
                
                let historyItem = HistoryItem(gameIdentifier: gameIdentifier!, title: title, percentDone: percentDone)
                if let items = json["gameItems"] as? [String] {
                    for item in items {
                        historyItem.gameItems.append(item)
                    }
                }
            }
        }
        return result
    }
}
