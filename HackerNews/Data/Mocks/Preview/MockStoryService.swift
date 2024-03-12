//
//  MockStoryService.swift
//  HackerNews
//
//  Created by Ali Ersöz on 3/9/24.
//

import Foundation

class MockStoryService: StoryServicable {
    func new() async throws -> [Int] {
        [1, 2, 3, 4, 5]
    }
}
