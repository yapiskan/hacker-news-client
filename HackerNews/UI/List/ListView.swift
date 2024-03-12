//
//  ContentView.swift
//  HackerNews
//
//  Created by Ali Ersöz on 3/9/24.
//

import SwiftUI
import WebKit

struct ListView: View {
    enum Route: Hashable {
        case detail(story: Story)
    }

    enum PresentationRoute: Identifiable {
        var id: String {
            switch self {
            case .url(let destination):
                return destination.absoluteString
            }
        }

        case url(destination: URL)
    }

    private var viewModel: ListViewModel

    @State private var navigationRoute: Route?
    @State private var presentationRoute: PresentationRoute?

    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List {
            ForEach(viewModel.stories) { story in
                row(forStory: story)
            }

            footer()
        }
        .listRowSeparator(.visible, edges: .all)
        .listStyle(.plain)
        .sheet(item: $presentationRoute) { route in
            switch route {
            case .url(let url):
                WebView(url: url)
            }
        }
        .navigationDestination(item: $navigationRoute) { route in
            switch route {
            case .detail(let item):
                if let viewModel = viewModel.detail(for: item) {
                    DetailView(viewModel: viewModel)
                } else {
                    EmptyView()
                }
            }
        }
        .navigationTitle("News")
        .navigationBarTitleDisplayMode(.large)
        .onFirstAppear {
            Task {
                await viewModel.fetchNews()
            }
        }
    }

    func row(forStory story: Story) -> some View {
        Button {
            navigationRoute = .detail(story: story)
        } label: {
            VStack(alignment: .leading) {
                Text(story.title)
                    .font(.headline)
                Text("\(story.score) \(story.score > 1 ? "points" : "point") by: \(story.author) \(story.timeAgo)")
                    .font(.caption)

                if let urlString = story.url, let url = URL(string: urlString) {
                    Button {
                        presentationRoute = .url(destination: url)
                    } label: {
                        Text(url.host() ?? "no-host")
                    }
                    .foregroundStyle(.blue)
                }
            }
        }
        .foregroundStyle(.black)
    }

    func footer() -> some View {
        LoadingFooter(
            isLoading: viewModel.isLoading,
            hasMore: viewModel.hasMore) {
                Task {
                    await viewModel.fetchNews()
                }
            }
    }
}

#Preview {
    NavigationStack {
        ListView(viewModel: .init(storyRepository: MockStoryRepository(), commentRepository: MockCommentRepository()))
    }
}
