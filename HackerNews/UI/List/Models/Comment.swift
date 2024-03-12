//
//  Comment.swift
//  HackerNews
//
//  Created by Ali Ersöz on 3/11/24.
//

import Foundation

struct Comment: Identifiable, Hashable {
    let id: Int
    let text: String
    let author: String
    let time: Double
    let url: String?
    var kids: [Story]?
    var level: Int = 0

    var timeAgo: String {
        Date(timeIntervalSince1970: time).timeAgoDisplay()
    }
}
