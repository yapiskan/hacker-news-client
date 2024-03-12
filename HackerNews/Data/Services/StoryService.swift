//
//  StoryService.swift
//  HackerNews
//
//  Created by Ali Ersöz on 3/9/24.
//

import Foundation
import Networking

protocol StoryServicable {
    func new() async throws -> [Int]
}

class StoryService: StoryServicable {
    private let networkManager: HackerNewsNetworkManager

    init(networkManager: HackerNewsNetworkManager) {
        self.networkManager = networkManager
    }
    
    func new() async throws -> [Int]  {
        try await networkManager.performRequest(
            path: "/v0/topstories.json",
            method: .get,
            responseType: [Int].self
        )
    }
}

typealias HackerNewsNetworkManager = NetworkManager<APIError>

struct APIError: Codable {

}
