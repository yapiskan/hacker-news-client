//
//  Date.Extensions.swift
//  HackerNews
//
//  Created by Ali Ersöz on 3/11/24.
//

import Foundation

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
