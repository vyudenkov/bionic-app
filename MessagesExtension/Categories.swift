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
    static let GameInfo = "GameInfo"

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
    static let YesNo = "YesNo"
    static let TwoQuestion = "TwoQuestion"
    
    static let Result = "Result"
    static let SelectionResult = "SelectionResult"
    
    static let GameSelection = "GameSelection"
    static let GameSelectionResult = "GameSelectionResult"
    static let GameStart = "GameStart"
    static let GameResponse = "GameResponse"
    static let GameProductResult = "GameProductResult"
    static let GameFulfilment = "GameFulfilment"
    static let GameEnd = "GameEnd"
    
    /*static let FMKResult1 = "FMKResult1"
    static let FMKResult2 = "FMKResult2"
    static let FMKResult3 = "FMKResult3"
    static let FMKResult4 = "FMKResult4"*/
    
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
