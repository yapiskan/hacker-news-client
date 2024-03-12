//
//  MockItemRepository.swift
//  HackerNews
//
//  Created by Ali Ersöz on 3/9/24.
//

import Foundation

class MockCommentRepository: CommentRepositing {
    var items: [Int : Endpoints.Response.Item] = [:]

    func prepareComments(forItem item: Endpoints.Response.Item, offset: Int, limit: Int) async throws {
        let items: [Endpoints.Response.Item] = try readJSON("items-details")
        for item in items {
            self.items[item.id] = item
        }
    }
}
