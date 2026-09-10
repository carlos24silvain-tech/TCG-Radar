//
//  TCG_RadarApp.swift
//  TCG Radar
//
//  Created by carlos silvain on 9/8/26.
//

import SwiftUI

@main
struct TCG_RadarApp: App {
    
    @StateObject private var collectionStore = CollectionStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(collectionStore)
        }
    }
}
