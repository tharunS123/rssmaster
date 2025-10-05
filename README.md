# RSS Master - Podcast Feed Reader

A modern, native iOS app for browsing and listening to podcasts via RSS feeds. Built with SwiftUI, featuring audio playback, episode summarization, and a clean, dark-mode interface.

## Features

- **RSS Feed Parsing**: Parses podcast RSS feeds to display episodes with metadata
- **Audio Playback**: Full-featured audio player with play/pause, seeking, skip controls, and variable playback speed
- **Episode Summarization**: AI-powered summaries using OpenRouter API (DeepSeek model) for quick episode overviews
- **Feed Selection**: Choose from popular podcasts or add custom RSS feeds via the menu button
- **Pull to Refresh**: Refresh feed for latest episodes
- **Dark Mode**: Native dark theme interface
- **iOS Native UI**: Clean, responsive design following iOS design guidelines
- **Custom Loading Animations**: Unique blade and shuriken loading indicators
- **Persistent Feed Selection**: Remembers your selected feed across app launches

## Screenshots

*(Add screenshots here when available)*

## Installation

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0 or later
- macOS Sonoma or later

### Setup
1. Clone or download the project
2. Open `rssmaster.xcodeproj` in Xcode
3. Select an iOS Simulator (iPhone 15 or later recommended) or connect a physical device
4. Press `Command + R` to build and run

## Usage

1. **Browse Episodes**: The app loads NPR Planet Money episodes by default
2. **Select Feed**: Tap the list icon (≡) in the top left to choose from popular podcasts or add a custom RSS feed
3. **View Details**: Tap any episode to see full description and controls
4. **Play Audio**: Use the play button to start listening
5. **Summarize**: Tap the summarize button to get an AI-generated episode summary
6. **Controls**: Use playback controls for seeking, skipping, and speed adjustment

### Changing Podcast Feed

To use a different podcast, modify the `feedURL` in `ViewModels/FeedViewModel.swift`:

```swift
private let feedURL = "https://your-podcast-rss-feed.xml"
```

## Architecture

### Project Structure
```
rssmaster/
├── Assets.xcassets/          # App icons and colors
├── Models/
│   └── PodcastEpisode.swift  # Episode data model
├── Services/
│   ├── RSSFeedParser.swift   # RSS XML parsing
│   ├── AudioPlayerManager.swift # Audio playback management
│   └── SummarizationService.swift # AI summarization
├── ViewModels/
│   └── FeedViewModel.swift   # Feed data and state management
├── Views/
│   ├── FeedListView.swift    # Main episode list
│   ├── EpisodeDetailView.swift # Episode details and player
│   ├── BladeLoadingView.swift # Loading animation
│   └── ShurikenLoadingView.swift # Loading animation
├── ContentView.swift         # Root view
├── rssmasterApp.swift        # App entry point
├── UIStyles.swift            # UI styling utilities
└── README.md
```

### Key Components

- **FeedViewModel**: Manages episode data, loading states, and feed parsing
- **AudioPlayerManager**: Handles AVFoundation audio playback with Combine publishers
- **RSSFeedParser**: XML parsing for RSS feeds using Foundation's XMLParser
- **SummarizationService**: OpenRouter API integration for episode summaries

## Dependencies

- **SwiftUI**: UI framework
- **AVFoundation**: Audio playback
- **Combine**: Reactive programming
- **Foundation**: Core utilities and XML parsing

## API Usage

The app uses the OpenRouter API for episode summarization. The API key is currently hardcoded for demonstration purposes. For production:

1. Move API key to secure storage (Keychain)
2. Consider using a backend proxy for API calls
3. Implement proper error handling and rate limiting

## Troubleshooting

### Build Errors

1. **Clean Build Folder**
   - Press `Shift + Command + K` in Xcode
   - Or go to Product → Clean Build Folder

2. **Reset Package Dependencies**
   - File → Packages → Reset Package Caches

3. **Check Target Membership**
   - Select each .swift file
   - In the File Inspector (right panel), ensure "Target Membership" has "rssmaster" checked

4. **Verify Minimum iOS Version**
   - Select the project in navigator
   - Go to project settings
   - Set "Minimum Deployments" to iOS 17.0 or later

5. **File Organization Issues**
   - Ensure all Swift files are properly added to the target
   - If files appear in red in Xcode, remove and re-add them

### Runtime Issues

- **Audio Not Playing**: Check device volume and ensure audio permissions are granted
- **Feed Not Loading**: Verify internet connection and RSS feed URL validity
- **Summarization Failing**: Check API key validity and network connection

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly on multiple devices/simulators
5. Submit a pull request

## License

*(Add license information here)*

## Acknowledgments

- NPR Planet Money for providing the default podcast feed
- OpenRouter for AI summarization API
- DeepSeek for the language model used in summarization