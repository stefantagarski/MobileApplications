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
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var imagePickerSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var photoGallery: [UIImage] = []
    @State private var showActionSheet = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // Hero icon
                ZStack {
                    Circle()
                        .fill(item.color.opacity(0.15))
                        .frame(width: 120, height: 120)

                    Image(systemName: item.systemIcon)
                        .font(.system(size: 48))
                        .foregroundColor(item.color)
                }
                .padding(.top, 20)

                // Title & subtitle
                VStack(spacing: 6) {
                    Text(item.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(item.subtitle)
                        .font(.title3)
                        .foregroundColor(.secondary)
                }

                // Description
                Text(item.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .foregroundColor(.secondary)

                Divider().padding(.horizontal)

                // Photo section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Photos")
                            .font(.headline)
                        Spacer()
                        Button(action: { showActionSheet = true }) {
                            HStack(spacing: 4) {
                                Image(systemName: "camera.fill")
                                Text("Add Photo")
                                    .font(.subheadline)
                            }
                        }
                    }
                    .padding(.horizontal, 24)

                    if photoGallery.isEmpty {
                        Text("No photos yet. Tap Add Photo to share one!")
                            .font(.callout)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 24)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(photoGallery.indices, id: \.self) { index in
                                    Image(uiImage: photoGallery[index])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .cornerRadius(10)
                                        .clipped()
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                }

                Divider().padding(.horizontal)

                // Map section
                RestaurantMapView(itemName: item.name, coordinate: item.coordinate)
                    .padding(.horizontal, 24)

                Divider().padding(.horizontal)

                // Daily quote
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
                        ProgressView().padding()
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

                Divider().padding(.horizontal)

                // Comments section
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
        .confirmationDialog("Add Photo", isPresented: $showActionSheet) {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button("Take Photo") {
                    imagePickerSource = .camera
                    showImagePicker = true
                }
            }
            Button("Choose from Library") {
                imagePickerSource = .photoLibrary
                showImagePicker = true
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: imagePickerSource, selectedImage: $selectedImage)
        }
        .onChange(of: selectedImage) { oldValue, newValue in
            if let image = newValue {
                photoGallery.append(image)
                selectedImage = nil
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
