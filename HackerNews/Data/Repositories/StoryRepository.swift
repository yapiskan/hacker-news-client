//
//  ItemRepository.swift
//  HackerNews
//
//  Created by Ali Ersöz on 3/9/24.
//

import Foundation

protocol StoryRepositing {
    @discardableResult
    func fetchNewStories(refresh: Bool) async throws -> [Int]
    func fetchDetails(from: Int, limit: Int) async throws -> [Endpoints.Response.Item]
    func item(by id: Int) -> Endpoints.Response.Item?
}

class StoryRepository: StoryRepositing {
    private let storyService: StoryServicable
    private let itemService: ItemServicable

    init(storyService: StoryServicable, itemService: ItemServicable) {
        self.storyService = storyService
        self.itemService = itemService
    }

    private var newStoriesToFetchDetail: [Int] = []
    private var details: [Int: Endpoints.Response.Item] = [:]

    @discardableResult
    func fetchNewStories(refresh: Bool = false) async throws -> [Int] {
        if !refresh && newStoriesToFetchDetail.count > 0 {
            return newStoriesToFetchDetail
        }

        newStoriesToFetchDetail = try await storyService.new()
        return newStoriesToFetchDetail
    }

    func fetchDetails(from: Int, limit: Int) async throws -> [Endpoints.Response.Item] {
        try await withThrowingTaskGroup(of: Endpoints.Response.Item.self) { group in
            for id in self.newStoriesToFetchDetail[from..<(from + limit)] {
                group.addTask{
                    let detail = try await self.itemService.detail(id: id)
                    return detail
                }
            }

            for try await detail in group {
                self.details[detail.id] = detail
            }

            var items = [Endpoints.Response.Item]()
            for i in newStoriesToFetchDetail[from..<from + limit] {
                if let item = details[i] {
                    items.append(item)
                }
            }

            return items
        }
    }

    func item(by id: Int) -> Endpoints.Response.Item? {
        details[id]
    }
}
