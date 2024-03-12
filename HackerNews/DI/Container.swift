//
//  Container.swift
//  HackerNews
//
//  Created by Ali Ersöz on 3/11/24.
//

import Foundation
import Networking

// TODO: use a proper DI Container: Swinject, needle etc
class Container {
    static func networkConfiguration() -> HackerNewsNetworkManager {
        let configuration = NetworkConfiguration(
            baseURL: "https://hacker-news.firebaseio.com",
            logging: .init(printResponse: false, printRequest: false))
        return HackerNewsNetworkManager(configuration: configuration)
    }
}
