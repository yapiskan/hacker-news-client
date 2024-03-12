//
//  ItemRepository.swift
//  HackerNews
//
//  Created by Ali Ersöz on 3/9/24.
//

import Foundation

protocol CommentRepositing {
    var items: [Int: Endpoints.Response.Item] { get }

    func prepareComments(forItem item: Endpoints.Response.Item, offset: Int, limit: Int)  async throws
}

class CommentRepository: CommentRepositing {
    private let itemService: ItemServicable

    init(itemService: ItemServicable) {
        self.itemService = itemService
    }
    
    // TODO: implement a cache invalidation policy
    private(set) var items: [Int: Endpoints.Response.Item] = [:]

    func prepareComments(forItem item: Endpoints.Response.Item, offset: Int, limit: Int) async throws {
        guard let kids = item.kids else { return }
        let fetchingKids = kids[offset..<min(offset + limit, kids.count)]
        try await prepareComments(kids: Array(fetchingKids))
    }

    private func prepareComments(kids: [Int]) async throws {
        // to avoid thread concurrency issues, create a copy of the items
        let items = self.items
        try await withThrowingTaskGroup(of: Endpoints.Response.Item.self) { group in
            for id in kids {
                // concurrently make all api calls
                group.addTask{
                    do {
                        // if we already fetched this comment, return immeditaely from cache
                        if items.keys.contains(id), let item = items[id] {
                            return item
                        }

                        return try await self.itemService.detail(id: id)
                    } catch {
                        throw error
                    }
                }
            }

            var items = [Endpoints.Response.Item]()
            // collect all responses and put them into a dictionary for caching purposes and fast
            // access
            for try await item in group {
                self.items[item.id] = item
                items.append(item)
            }
            
            // traverse the fetched items and collect their kids in an array
            var kids = [Int]()
            for i in items {
                kids += (i.kids ?? [])
            }

            // recursively fetch their children's detail using bfs until we reach to the bottom of
            // the comment tree
            if kids.count > 0 {
                try await prepareComments(kids: kids)
            }
        }
    }
}

