//
//  BinBotApp.swift
//  BinBot
//
//  Created by Himani Jha on 11/4/24.
//

import SwiftUI

@main
struct BinBotApp: App {
    @State private var showOverlay: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ContentView(showOverlay: $showOverlay)
                .background(Color.white)
                .ignoresSafeArea()
        }
    }
}
