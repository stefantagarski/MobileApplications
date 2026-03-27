//
//  MenuAppApp.swift
//  MenuApp
//
//  Created by Stefan Tagarski on 27.3.26.
//

import SwiftUI

@main
struct MenuAppApp: App {
    @StateObject private var viewModel = MenuViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
