//
//  ModelBuilder.swift
//  bionic-app
//
//  Created by Vitaliy on 10/31/16.
//  Copyright © 2016 Vitaliy. All rights reserved.
//

import Foundation


class ModelBuilder {

    static func create(userIdentifier: UUID, type: String, json: Dictionary<String, Any>) -> Categories {
    
        return Schema.fromJson(json: json)
    }
}
