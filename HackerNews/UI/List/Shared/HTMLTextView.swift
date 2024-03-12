//
//  HTMLTextView.swift
//  HackerNews
//
//  Created by Ali Ersöz on 3/11/24.
//

import Foundation
import SwiftUI

struct HTMLText: View {
    var html: String

    var body: some View {
        let htmlTextWithStyle = html + ("<style> body { font-family: -apple-system; font-size: 14px;}; p { margin-top: 10;};</style>")
        guard let htmlData = NSString(string: htmlTextWithStyle).data(using: String.Encoding.unicode.rawValue) else {
            return Text(html)
        }

        if let nsAttributedString = try? NSAttributedString(data: htmlData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil),
           let attributedString = try? AttributedString(nsAttributedString, including: \.uiKit) {
            return Text(attributedString)
        } else {
            // fallback...
            return Text(html)
        }
    }
}
