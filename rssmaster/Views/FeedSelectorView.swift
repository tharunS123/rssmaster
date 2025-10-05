//
//  FeedSelectorView.swift
//  rssmaster
//
//  Created by Tharun Senthilkumar on 10/5/25.
//

import SwiftUI

struct FeedSelectorView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: FeedViewModel
    @State private var customURL = ""
    @State private var showCustomInput = false

    let popularFeeds = [
        ("Planet Money", "https://feeds.npr.org/510289/podcast.xml"),
        ("Tim Ferriss Show", "https://rss.art19.com/tim-ferriss-show"),
        ("Lex Fridman Podcast", "https://lexfridman.com/feed/podcast/"),
        ("Joe Rogan Experience", "https://feeds.megaphone.fm/JRE"),
        ("Andrew Huberman Lab", "https://feeds.megaphone.fm/hubermanlab"),
        ("The Daily (NYT)", "https://rss.art19.com/the-daily"),
        ("Serial", "https://feeds.simplecast.com/54nAGcIl"),
        ("Stuff You Should Know", "https://feeds.megaphone.fm/stuff-you-should-know"),
        ("Radiolab", "https://feeds.wnyc.org/radiolab"),
        ("How I Built This", "https://feeds.npr.org/510313/podcast.xml")
    ]

    var body: some View {
        NavigationStack {
            List {
                Section("Popular Feeds") {
                    ForEach(popularFeeds, id: \.0) { (name, url) in
                        Button(action: {
                            viewModel.changeFeed(to: url, name: name)
                            dismiss()
                        }) {
                            HStack {
                                Text(name)
                                Spacer()
                                if viewModel.currentFeedName == name {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }

                Section {
                    if showCustomInput {
                        TextField("Enter RSS feed URL", text: $customURL)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)

                        Button("Add Custom Feed") {
                            if !customURL.isEmpty {
                                viewModel.changeFeed(to: customURL, name: "Custom Feed")
                                dismiss()
                            }
                        }
                        .disabled(customURL.isEmpty)
                    } else {
                        Button("Add Custom Feed") {
                            showCustomInput = true
                        }
                    }
                }
            }
            .navigationTitle("Select Feed")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    FeedSelectorView(viewModel: FeedViewModel())
}