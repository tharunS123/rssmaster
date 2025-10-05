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
    
    private let parser = RSSFeedParser()
    
    // Using NPR Planet Money as our default podcast feed
    // You can change this to any podcast RSS feed URL
    private let feedURL = "https://feeds.npr.org/510289/podcast.xml" // NPR Planet Money
    
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
}
