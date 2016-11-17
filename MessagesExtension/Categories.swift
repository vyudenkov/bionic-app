//
//  Categories.swift
//  bionic-app
//
//  Created by Vitaliy on 11/11/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import Foundation

enum CategoryType {
    case Title
    case Button
    case Question
}

class Category : Serializable {
    
    static let Title = "Title"
    static let Button = "Button"
    static let Question = "Question"
    static let FMK = "FMK"
    
    static let Result = "Result"
    static let FMKResult = "FMKResult"

    var type : String
    var code : String
    
    init(type: String, code: String) {
        self.type = type
        self.code = code
    }
}

class Categories : Serializable {
    
    static let Info = "Info"
    static let MiddleInfo = "MiddleInfo"
    static let QuestionButtons = "QuestionButtons"
    static let QuestionList = "QuestionList"
    static let Game = "Game"
    static let GameSelection = "GameSelection"
    static let GameResult = "GameResult"
    static let YesNo = "YesNo"
    static let TwoQuestion = "TwoQuestion"
    
    static let Result = "Result"
    static let FMKResult = "FMKResult"
    
    var userIdentifier : UUID
    // category type - the kind of question: school selection, etc
    // TODO: if static - make enum
    // on server - identify how to process received from client result
    // on client - identify how to represent the data
    var type : String
    
    var code : String
    
    var categories : [Category] = []
    
    var isFullScreen : Bool
    
    // This is the result which is sent to server
    //var selectedCategories : [Category] { get }
    
    init(code: String, type: String, userIdentifier: UUID)
    {
        self.type = type
        self.code = code
        self.userIdentifier = userIdentifier
        self.isFullScreen = true
    }
    
    init(code: String, type: String, isFullScreen: Bool, userIdentifier: UUID)
    {
        self.type = type
        self.code = code
        self.userIdentifier = userIdentifier
        self.isFullScreen = isFullScreen
    }
}
