//
//  MockServiceRepository.swift
//  HackerNews
//
//  Created by Ali Ersöz on 3/9/24.
//

import Foundation

class MockStoryRepository: StoryRepositing {
    func fetchDetails(from: Int, limit: Int) async throws -> [Endpoints.Response.Item] {
        try readJSON("items")
    }

    func fetchNewStories(refresh: Bool) async throws -> [Int] {
        try readJSON("stories")
    }

    func item(by id: Int) -> Endpoints.Response.Item? {
        try? readJSON("item")
    }
}

enum MockError: Error {
    case fileNotFound
}

func readJSON<T: Decodable>(_ resource: String) throws -> T {
    if let path = Bundle.main.path(forResource: resource, ofType: "json") {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let response = try JSONDecoder().decode(T.self, from: data)

        return response
    } else {
        throw MockError.fileNotFound
    }
}
