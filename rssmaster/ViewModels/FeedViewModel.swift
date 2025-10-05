//
//  FeedViewModel.swift
//  rssmaster
//
//  Created by Tharun Senthilkumar on 10/3/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class FeedViewModel: ObservableObject {
    @Published var episodes: [PodcastEpisode] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentFeedName: String = "Planet Money"

    private let parser = RSSFeedParser()
    private var feedURL: String = "https://feeds.npr.org/510289/podcast.xml" // NPR Planet Money

    init() {
        loadSavedFeed()
    }

    private func loadSavedFeed() {
        if let savedURL = UserDefaults.standard.string(forKey: "currentFeedURL"),
           let savedName = UserDefaults.standard.string(forKey: "currentFeedName") {
            feedURL = savedURL
            currentFeedName = savedName
        }
    }

    private func saveCurrentFeed() {
        UserDefaults.standard.set(feedURL, forKey: "currentFeedURL")
        UserDefaults.standard.set(currentFeedName, forKey: "currentFeedName")
    }

    func loadFeed() async {
        isLoading = true
        errorMessage = nil

        do {
            let fetchedEpisodes = try await parser.parseFeed(from: feedURL)
            episodes = fetchedEpisodes.sorted { $0.pubDate > $1.pubDate }
        } catch {
            errorMessage = "Failed to load podcast feed: \(error.localizedDescription)"
        }

        isLoading = false
    }

    func changeFeed(to url: String, name: String) {
        feedURL = url
        currentFeedName = name
        saveCurrentFeed()
        Task {
            await loadFeed()
        }
    }
}
