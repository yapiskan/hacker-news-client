//
//  HackerNewsApp.swift
//  HackerNews
//
//  Created by Ali Ersöz on 3/9/24.
//

import SwiftUI

@main
struct HackerNewsApp: App {
    var networkManager: HackerNewsNetworkManager {
        Container.networkConfiguration()
    }

    var body: some Scene {
        let storyService = StoryService(networkManager: networkManager)
        let itemService = ItemService(networkManager: networkManager)
        
        WindowGroup {
            NavigationStack {
                ListView(
                    viewModel: .init(
                        storyRepository: StoryRepository(
                            storyService: storyService,
                            itemService: itemService),
                        commentRepository: CommentRepository(
                            itemService: itemService)
                    )
                )
            }
        }
    }
}

