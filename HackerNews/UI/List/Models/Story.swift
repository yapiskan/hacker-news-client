//
//  Story.swift
//  HackerNews
//
//  Created by Ali Ersöz on 3/11/24.
//

import Foundation


struct Story: Identifiable, Hashable {
    let id: Int
    let title: String
    let author: String
    let score: Int
    let time: Double
    let url: String?
    var kids: [Story]?

    var timeAgo: String {
        Date(timeIntervalSince1970: time).timeAgoDisplay()
    }
}
