//
//  MenuDetailView.swift
//  MenuApp
//
//  Created by Stefan Tagarski on 27.3.26.
//

import SwiftUI

struct MenuDetailView: View {
    let item: MenuItem
    @EnvironmentObject var viewModel: MenuViewModel

    @State private var newCommentAuthor: String = ""
    @State private var newCommentText: String = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(item.color.opacity(0.15))
                        .frame(width: 120, height: 120)

                    Image(systemName: item.systemIcon)
                        .font(.system(size: 48))
                        .foregroundColor(item.color)
                }
                .padding(.top, 20)

                VStack(spacing: 6) {
                    Text(item.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(item.subtitle)
                        .font(.title3)
                        .foregroundColor(.secondary)
                }

                Text(item.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .foregroundColor(.secondary)

                Divider()
                    .padding(.horizontal)

                VStack(spacing: 8) {
                    HStack {
                        Text("Quote of the Day")
                            .font(.headline)
                        Spacer()
                        Button(action: { viewModel.fetchQuote() }) {
                            Image(systemName: "arrow.clockwise")
                                .font(.subheadline)
                        }
                    }

                    if viewModel.isLoadingQuote {
                        ProgressView()
                            .padding()
                    } else if !viewModel.dailyQuote.isEmpty {
                        Text(viewModel.dailyQuote)
                            .font(.callout)
                            .italic()
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    } else {
                        Text("Tap refresh to load a quote")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 24)

                Divider()
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Comments")
                        .font(.headline)
                        .padding(.horizontal, 24)

                    VStack(spacing: 10) {
                        TextField("Your name", text: $newCommentAuthor)
                            .textFieldStyle(.roundedBorder)

                        TextField("Write a comment...", text: $newCommentText)
                            .textFieldStyle(.roundedBorder)

                        Button(action: addComment) {
                            Text("Post Comment")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(item.color)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(newCommentAuthor.isEmpty || newCommentText.isEmpty)
                        .opacity(newCommentAuthor.isEmpty || newCommentText.isEmpty ? 0.5 : 1.0)
                    }
                    .padding(.horizontal, 24)

                    let comments = viewModel.getComments(for: item.id)
                    if comments.isEmpty {
                        Text("No comments yet. Be the first!")
                            .font(.callout)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 24)
                            .padding(.top, 4)
                    } else {
                        ForEach(comments) { comment in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(comment.author)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Text(comment.date, style: .relative)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Text(comment.text)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal, 24)
                        }
                    }
                }

                Spacer(minLength: 30)
            }
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel.dailyQuote.isEmpty {
                viewModel.fetchQuote()
            }
        }
    }

    private func addComment() {
        viewModel.addComment(for: item.id, author: newCommentAuthor, text: newCommentText)
        newCommentAuthor = ""
        newCommentText = ""
    }
}

#Preview {
    NavigationStack {
        MenuDetailView(item: MenuData.drinks[0])
            .environmentObject(MenuViewModel())
    }
}
