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
        /*if type == Categories.GameSelection || type == Categories.GameSelectionResult || type == Categories.GameStart || type == Categories.GameResponse || type == Categories.GameProductResult || type == Categories.GameFulfilment {
            return FMKGame.fromJson(json: json)
        }*/
        return Schema.fromJson(json: json)
    }
}
