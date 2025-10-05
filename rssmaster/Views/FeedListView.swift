//
//  FeedListView.swift
//  rssmaster
//
//  Created by Tharun Senthilkumar on 10/3/25.
//

import SwiftUI

struct FeedListView: View {
    @StateObject private var viewModel = FeedViewModel()
    @State private var showFeedSelector = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.episodes) { episode in
                    NavigationLink(destination: EpisodeDetailView(episode: episode)) {
                        EpisodeRowView(episode: episode)
                    }
                }
            }
            .navigationTitle(viewModel.currentFeedName)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showFeedSelector = true
                    }) {
                        Image(systemName: "list.bullet")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            await viewModel.loadFeed()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .refreshable {
                await viewModel.loadFeed()
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Loading episodes...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.systemBackground).opacity(0.8))
                }
                
                if let errorMessage = viewModel.errorMessage {
                    ContentUnavailableView(
                        "Failed to Load",
                        systemImage: "wifi.exclamationmark",
                        description: Text(errorMessage)
                    )
                }
                
                if !viewModel.isLoading && viewModel.episodes.isEmpty && viewModel.errorMessage == nil {
                    ContentUnavailableView(
                        "No Episodes",
                        systemImage: "mic.slash",
                        description: Text("Pull to refresh to load episodes")
                    )
                }
            }
            .task {
                await viewModel.loadFeed()
            }
            .sheet(isPresented: $showFeedSelector) {
                FeedSelectorView(viewModel: viewModel)
            }
        }
    }
}

struct EpisodeRowView: View {
    let episode: PodcastEpisode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(episode.title)
                .font(.headline)
                .lineLimit(2)
            
            Text(episode.cleanDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3)
            
            HStack {
                Label(episode.formattedDate, systemImage: "calendar")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if let duration = episode.duration {
                    Label(duration, systemImage: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    FeedListView()
}