//
//  MenuViewModel.swift
//  MenuApp
//
//  Created by Stefan Tagarski on 27.3.26.
//

import Foundation
import Combine

class MenuViewModel: ObservableObject {
    @Published var comments: [UUID: [Comment]] = [:]
    @Published var dailyQuote: String = ""
    @Published var isLoadingQuote: Bool = false

    func addComment(for itemId: UUID, author: String, text: String) {
        let comment = Comment(author: author, text: text, date: Date())
        if comments[itemId] != nil {
            comments[itemId]?.append(comment)
        } else {
            comments[itemId] = [comment]
        }
    }

    func getComments(for itemId: UUID) -> [Comment] {
        return comments[itemId] ?? []
    }

    func fetchQuote() {
        isLoadingQuote = true
        QuoteService.fetchRandomQuote { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoadingQuote = false
                switch result {
                case .success(let quote):
                    self?.dailyQuote = quote
                case .failure:
                    self?.dailyQuote = "Could not load quote."
                }
            }
        }
    }
}
