//
//  ItemService.swift
//  HackerNews
//
//  Created by Ali Ersöz on 3/9/24.
//

import Foundation

protocol ItemServicable {
    func detail(id: Int) async throws -> Endpoints.Response.Item
}

class ItemService: ItemServicable {
    private let networkManager: HackerNewsNetworkManager

    init(networkManager: HackerNewsNetworkManager) {
        self.networkManager = networkManager
    }

    func detail(id: Int) async throws -> Endpoints.Response.Item {
        try await networkManager.performRequest(
            path: "/v0/item/\(id).json",
            method: .get,
            responseType: Endpoints.Response.Item.self
        )
    }
}
