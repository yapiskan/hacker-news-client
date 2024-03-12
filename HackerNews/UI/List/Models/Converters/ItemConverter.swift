//
//  ItemConverter.swift
//  HackerNews
//
//  Created by Ali Ersöz on 3/11/24.
//

import Foundation

class ItemConverter {
    static func mapToStory(_ item: Endpoints.Response.Item) -> Story {
        .init(
            id: item.id,
            title: item.title ?? "",
            author: item.by ?? "no-author",
            score: item.score ?? 0,
            time: item.time,
            url: item.url
        )
    }

    static func mapToComment(_ comment: Endpoints.Response.Item, level: Int) -> Comment {
        .init(
            id: comment.id,
            text: comment.text ?? "",
            author: comment.by ?? "no-author",
            time: comment.time,
            url: comment.url,
            level: level
        )
    }
}
