//
//  LoadingFooter.swift
//  HackerNews
//
//  Created by Ali Ersöz on 3/11/24.
//

import Foundation
import SwiftUI

struct LoadingFooter: View {
    var isLoading: Bool
    var hasMore: Bool

    var onLoadMore: () -> Void

    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            if isLoading {
                ProgressView("Loading")
            } else if hasMore  {
                Button {
                    onLoadMore()
                } label: {
                    Text("Load More...")
                }
            }
            Spacer()
        }
        .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
            return 0
        }
    }
}

