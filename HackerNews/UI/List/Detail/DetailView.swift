//
//  DetailView.swift
//  HackerNews
//
//  Created by Ali Ersöz on 3/9/24.
//

import SwiftUI
import WebKit

struct DetailView: View {
    private var viewModel: DetailViewModel

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                header()
                
                ForEach(viewModel.comments) { comment in
                    commentRow(comment)
                }

                footer()
            }
            .scenePadding()
        }
        .task {
            await viewModel.fetchComments()
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    func header() -> some View {
        Group {
            Text(viewModel.story.title)
                .font(.title3.bold())
            Text("\(viewModel.story.score) \(viewModel.story.score > 1 ? "points" : "point") by: \(viewModel.story.author) \(viewModel.story.timeAgo)")
                .font(.caption)
                .padding(.bottom, 8)
        }
    }

    func commentRow(_ comment: Comment) -> some View {
        VStack(alignment: .leading) {
            Text("\(comment.author) - \(comment.timeAgo)")
                .font(.caption.bold())
            HTMLText(html: comment.text)
            // TODO: The HTMLText view above causing the warning belowl
            // === AttributeGraph: cycle detected through attribute 611024 ===
            // the NSAttributedString inside the HTMLText is causing that issue.
            // To prevent that you can use enable the code below however that would
            // cause the text not to be respecitng html styling and unicodes.
            // Text(comment.text)
                .font(.caption)
        }
        .padding(.leading, 8 * CGFloat(comment.level + 1))
        .overlay(alignment: .leading) {
            Rectangle()
                .frame(width: 2)
                .foregroundStyle(Color.gray)
                .padding(.leading, 8 * CGFloat(comment.level + 1) - 4)
                .padding(.bottom, 4)
        }
    }

    func footer() -> some View {
        LoadingFooter(
            isLoading: viewModel.isLoading,
            hasMore: viewModel.hasMore) {
                Task {
                    await viewModel.fetchComments()
                }
            }
    }
}

#Preview {
    let item = Endpoints.Response.Item(id: 1, time: 0, deleted: false, type: "story", by: "ali", title: "this is the title", text: "text", url: "", score: 100, kids: [
        9224,
        8917,
        8884,
        8887,
        8952])
    return DetailView(viewModel: .init(story: item, commentRepository: MockCommentRepository()))
}

