//
//  CoverBotApp.swift
//  CoverBot
//
//  Created by Emmanuel Theodore on 5/10/23.
//

import SwiftUI

 @main
struct CoverBotApp: App {
    @StateObject var settings = Settings()
    @StateObject var threadStore = ThreadStore()
    var body: some Scene {
        WindowGroup {
            ContentView(presentSheet: false)
                .environmentObject(settings)
                .environmentObject(threadStore)
        }
    }
}
