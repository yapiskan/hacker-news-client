//
//  ResponseModels.swift
//  HackerNews
//
//  Created by Ali Ersöz on 3/9/24.
//

import Foundation

enum Endpoints {
    enum Response {
        struct Item: Decodable {
            let id: Int
            let time: Double
            let deleted: Bool?
            let type: String
            let by: String?
            let title: String?
            let text: String?
            let url: String?
            let score: Int?
            let kids: [Int]?
        }
    }
}
