//
//  EpisodeDetailView.swift
//  rssmaster
//
//  Created by Tharun Senthilkumar on 10/3/25.
//

import SwiftUI

struct EpisodeDetailView: View {
    @EnvironmentObject private var audioManager: AudioPlayerManager
    let episode: PodcastEpisode
    @State private var isSummarizing = false
    @State private var notesText: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Episode Image (if available)
                if let imageURL = episode.imageURL, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 300)
                            .cornerRadius(12)
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 200)
                            .overlay {
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                            }
                    }
                }
                
                // Episode Title
                Text(episode.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                // Episode Metadata
                HStack(spacing: 20) {
                    Label(episode.formattedDate, systemImage: "calendar")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if let duration = episode.duration {
                        Label(duration, systemImage: "clock")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                // Play Button (visual only - actual playback would require additional implementation)
                if episode.audioURL != nil {
                    Button(action: {
                        if let audioURL = episode.audioURL {
                            audioManager.loadAudio(from: audioURL)
                            audioManager.play()
                        }
                    }) {
                        HStack {
                            Image(systemName: audioManager.isPlaying ? "pause.fill" : "play.fill")
                                .font(.headline)
                            Text(audioManager.isPlaying ? "Pause" : "Play Episode")
                                .font(.headline)
                        }
                    }
                    .buttonStyle(DarkGradientButtonStyle())
                    .padding(.horizontal)
                    
                    Button(action: {
                        Task {
                            isSummarizing = true
                            defer { isSummarizing = false }
                            do {
                                let summary = try await SummarizationService.shared.summarize(title: episode.title, description: episode.cleanDescription)
                                notesText = summary
                            } catch {
                                notesText = "Failed to generate summary. Please try again.\n\n\(error.localizedDescription)"
                            }
                        }
                    }) {
                        HStack {
                            if isSummarizing {
                                ShurikenLoadingView()
                                    .frame(width: 22, height: 22)
                            } else {
                                Image(systemName: "sparkles")
                                    .font(.headline)
                            }
                            Text(isSummarizing ? "Generating..." : "Generate Summary")
                                .font(.headline)
                        }
                    }
                    .buttonStyle(DarkGradientButtonStyle())
                    .padding(.horizontal)
                    
                    if audioManager.duration > 0 {
                        VStack(spacing: 12) {
                            // Scrubber
                            Slider(value: Binding(
                                get: { audioManager.currentTime },
                                set: { audioManager.seek(to: $0) }
                            ), in: 0...audioManager.duration)
                            
                            HStack {
                                Text(audioManager.formatTime(audioManager.currentTime))
                                    .font(.caption)
                                    .monospacedDigit()
                                Spacer()
                                Text(audioManager.formatTime(audioManager.duration))
                                    .font(.caption)
                                    .monospacedDigit()
                            }
                            
                            HStack(spacing: 30) {
                                Button {
                                    audioManager.skipBackward()
                                } label: {
                                    Image(systemName: "gobackward.15")
                                        .font(.title2)
                                }
                                
                                Button {
                                    audioManager.togglePlayPause()
                                } label: {
                                    Image(systemName: audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                        .font(.largeTitle)
                                }
                                
                                Button {
                                    audioManager.skipForward()
                                } label: {
                                    Image(systemName: "goforward.30")
                                        .font(.title2)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Episode Description
                VStack(alignment: .leading, spacing: 10) {
                    Text("Description")
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(episode.cleanDescription)
                        .font(.body)
                        .foregroundStyle(.primary)
                        .lineSpacing(4)
                }
                .padding(.horizontal)

                // Notes Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Notes")
                        .font(.headline)
                        .foregroundStyle(.primary)

                    ZStack {
                        NotepadBackground()
                        TextEditor(text: $notesText)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                            .padding(12)
                            .font(.body)
                            .foregroundStyle(.primary)
                    }
                    .frame(minHeight: 200)
                    .clipShape(Rectangle())
                }
                .padding(.horizontal)
                
                // Audio URL (for debugging/info)
                if let audioURL = episode.audioURL {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Audio Link")
                            .font(.headline)
                        
                        Link(destination: URL(string: audioURL)!) {
                            Text("Open in Podcast App")
                                .font(.subheadline)
                                .foregroundColor(.accentColor)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(item: URL(string: episode.audioURL ?? "")!) {
                    Image(systemName: "square.and.arrow.up")
                }
                .disabled(episode.audioURL == nil)
            }
        }
    }
}

#Preview {
    NavigationStack {
        EpisodeDetailView(
            episode: PodcastEpisode(
                title: "Sample Episode Title",
                description: "This is a sample episode description that would contain the full text from the RSS feed. It can be quite long and include details about the episode content, guests, and topics discussed.",
                pubDate: Date(),
                audioURL: "https://example.com/audio.mp3",
                duration: "45:23",
                imageURL: nil
            )
        )
        .environmentObject(AudioPlayerManager())
    }
}

