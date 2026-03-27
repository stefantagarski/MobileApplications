//
//  MenuItemCell.swift
//  MenuApp
//
//  Created by Stefan Tagarski on 27.3.26.
//

import SwiftUI

struct MenuItemCell: View {
    let item: MenuItem

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(item.color.opacity(0.15))
                    .frame(width: 64, height: 64)

                Image(systemName: item.systemIcon)
                    .font(.system(size: 24))
                    .foregroundColor(item.color)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(item.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
    }
}

#Preview {
    MenuItemCell(item: MenuData.drinks[0])
}
