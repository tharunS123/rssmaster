//
//  PodcastEpisode.swift
//  rssmaster
//
//  Created by Tharun Senthilkumar on 10/3/25.
//

import Foundation

struct PodcastEpisode: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let pubDate: Date
    let audioURL: String?
    let duration: String?
    let imageURL: String?
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: pubDate)
    }
    
    var cleanDescription: String {
        // Remove HTML tags from description
        return description
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .replacingOccurrences(of: "&nbsp;", with: " ")
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}