//
//  AlwaysTopApp.swift
//  AlwaysTop
//
//  Created by Lunasol on 1/13/25.
//

import SwiftUI

@main
struct AlwaysTopApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .commands {
            CommandGroup(replacing: .newItem) { }
        }
    }
}
