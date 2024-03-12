//
//  NetworkConfiguration.swift
//
//
//  Created by Ali Ersöz on 3/9/24.
//

import Foundation

public struct NetworkConfiguration {
    var baseURL: String
    var logging: LoggingConfiguration

    public init(baseURL: String, logging: LoggingConfiguration = .init()) {
        self.baseURL = baseURL
        self.logging = logging
    }

    public struct LoggingConfiguration {
        var printResponse: Bool
        var printRequest: Bool

        public init(printResponse: Bool = true, printRequest: Bool = true) {
            self.printResponse = printResponse
            self.printRequest = printRequest
        }
    }
}
