//
//  ContentView.swift
//  MenuApp
//
//  Created by Stefan Tagarski on 27.3.26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MenuListView(title: "Drinks", items: MenuData.drinks)
                .tabItem {
                    Label("Drinks", systemImage: "cup.and.saucer.fill")
                }

            MenuListView(title: "Food", items: MenuData.foods)
                .tabItem {
                    Label("Food", systemImage: "fork.knife")
                }
        }
        .tint(.indigo)
    }
}

#Preview {
    ContentView()
}
