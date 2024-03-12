//
//  WebView.swift
//  HackerNews
//
//  Created by Ali Ersöz on 3/11/24.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let webView: WKWebView
    let url: URL

    init(url: URL) {
        self.url = url
        webView = WKWebView(frame: .zero)
    }

    func makeUIView(context: Context) -> WKWebView {
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        webView.load(URLRequest(url: url))
    }
}
