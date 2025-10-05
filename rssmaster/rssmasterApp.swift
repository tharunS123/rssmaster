//
//  rssmasterApp.swift
//  rssmaster
//
//  Created by Tharun Senthilkumar on 10/3/25.
//

import SwiftUI

@main
struct rssmasterApp: App {
    @StateObject private var audioManager = AudioPlayerManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(audioManager)
                .fontWidth(.condensed)
                .preferredColorScheme(.dark)
        }
    }
}
