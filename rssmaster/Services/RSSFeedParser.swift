//
//  RSSFeedParser.swift
//  rssmaster
//
//  Created by Tharun Senthilkumar on 10/3/25.
//

import Foundation

class RSSFeedParser: NSObject {
    private var episodes: [PodcastEpisode] = []
    private var currentElement = ""
    private var currentTitle = ""
    private var currentDescription = ""
    private var currentPubDate = ""
    private var currentAudioURL: String?
    private var currentDuration: String?
    private var currentImageURL: String?
    
    func parseFeed(from urlString: String) async throws -> [PodcastEpisode] {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let parser = XMLParser(data: data)
        parser.delegate = self
        
        episodes = []
        
        if parser.parse() {
            return episodes
        } else {
            throw URLError(.cannotParseResponse)
        }
    }
}

extension RSSFeedParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if elementName == "item" {
            currentTitle = ""
            currentDescription = ""
            currentPubDate = ""
            currentAudioURL = nil
            currentDuration = nil
            currentImageURL = nil
        }
        
        // Handle enclosure tag for audio URL
        if elementName == "enclosure" {
            if let url = attributeDict["url"], attributeDict["type"]?.contains("audio") == true {
                currentAudioURL = url
            }
        }
        
        // Handle iTunes image
        if elementName == "itunes:image" {
            currentImageURL = attributeDict["href"]
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !data.isEmpty {
            switch currentElement {
            case "title":
                currentTitle += data
            case "description", "content:encoded", "itunes:summary":
                currentDescription += data
            case "pubDate":
                currentPubDate += data
            case "itunes:duration":
                currentDuration = data
            default:
                break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
            
            let pubDate = dateFormatter.date(from: currentPubDate) ?? Date()
            
            let episode = PodcastEpisode(
                title: currentTitle,
                description: currentDescription,
                pubDate: pubDate,
                audioURL: currentAudioURL,
                duration: currentDuration,
                imageURL: currentImageURL
            )
            
            episodes.append(episode)
        }
    }
}