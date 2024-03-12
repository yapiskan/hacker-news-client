//
//  DetailViewModel.swift
//  HackerNews
//
//  Created by Ali Ersöz on 3/9/24.
//

import SwiftUI
import Observation

@Observable
class DetailViewModel {
    private let commentRepository: CommentRepositing
    private let storyItem: Endpoints.Response.Item
    let story: Story

    private(set) var comments = [Comment]()
    private(set) var isLoading = false
    private(set) var hasMore = true
    private var offset = 0
    private let limit = 10

    init(story: Endpoints.Response.Item, commentRepository: CommentRepositing) {
        self.storyItem = story
        self.commentRepository = commentRepository
        self.story = ItemConverter.mapToStory(story)
        self.hasMore = (story.kids?.count ?? 0) > 0
    }

    @MainActor
    func fetchComments() async {
        guard hasMore, !isLoading else { return }

        let kids = (storyItem.kids ?? [])
        isLoading = true
        do {
            // fetch comments by 10 root comment batches. while doing so, make sure to go to the
            // leaves of each comment and fetch them recursively as well.
            // this means that some api calls may take much longer than some other, depending on
            // their response rate.
            try await commentRepository.prepareComments(forItem: storyItem, offset: offset, limit: limit)
            let comments = kids[offset..<min(offset + limit, kids.count)]
                .compactMap { commentRepository.items[$0] }
            
            // flatten those comments and provide a level to display on the ui properly
            self.comments += flattenComments(comments, level: 0)

            offset += limit
            hasMore = offset < storyItem.kids?.count ?? 0
        } catch {
            // handle errors
        }

        isLoading = false
    }

    private func flattenComments(_ comments: [Endpoints.Response.Item], level: Int) -> [Comment] {
        var allComments = [Comment]()
        for comment in comments {
            allComments.append(ItemConverter.mapToComment(comment, level: level))
            let kids = (comment.kids ?? [])
                .compactMap { kid in
                    commentRepository.items[kid]
                }
                .filter { item in
                    item.by != nil
                }
            // recursively go traverse comments and flatten them.
            allComments += flattenComments(kids, level: level + 1)
        }

        return allComments
    }
}


