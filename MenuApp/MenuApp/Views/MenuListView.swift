//
//  MenuListView.swift
//  MenuApp
//
//  Created by Stefan Tagarski on 27.3.26.
//

import SwiftUI

struct MenuListView: View {
    let title: String
    let items: [MenuItem]

    var body: some View {
        NavigationStack {
            List(items) { item in
                NavigationLink(destination: MenuDetailView(item: item)) {
                    MenuItemCell(item: item)
                }
                .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
            }
            .listStyle(.plain)
            .navigationTitle(title)
        }
    }
}

#Preview {
    MenuListView(title: "Drinks", items: MenuData.drinks)
        .environmentObject(MenuViewModel())
}
