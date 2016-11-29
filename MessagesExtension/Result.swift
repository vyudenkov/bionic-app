//
//  Result.swift
//  bionic-app
//
//  Created by Vitaliy on 11/11/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import Foundation


protocol ExecutionContext {
    
    var userIdentifier : UUID { get }
}

class Empty : Categories {
    
    init(userIdentifier: UUID)
    {
        super.init(code: "", type: "Empty", userIdentifier: userIdentifier)
    }
}

class Selection : Category {
    
    init(_ code: String)
    {
        super.init(type: Category.Result, code: code)
    }
}

class Result : Categories, ExecutionContext {
    
    init(userIdentifier: UUID, code: String)
    {
        super.init(code: code, type: Categories.Result, userIdentifier: userIdentifier)
        super.categories = [ ]
    }
    
    // Selected categories
    init(userIdentifier: UUID, code: String, selectionCode: String)
    {
        super.init(code: code, type: Categories.Result, userIdentifier: userIdentifier)
        super.categories = [ Selection(selectionCode) ]
    }
}

class SelectionResult : Categories, ExecutionContext {
    
    init(userIdentifier: UUID, code: String)
    {
        super.init(code: code, type: Categories.SelectionResult, userIdentifier: userIdentifier)
        super.categories = [ ]
    }
}

