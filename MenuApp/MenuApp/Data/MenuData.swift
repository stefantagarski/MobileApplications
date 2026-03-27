//
//  MenuData.swift
//  MenuApp
//
//  Created by Stefan Tagarski on 27.3.26.
//

import SwiftUI

struct MenuData {
    static let drinks: [MenuItem] = [
        MenuItem(name: "Espresso",      subtitle: "Strong Italian coffee",      systemIcon: "cup.and.saucer.fill", color: Color(red: 0.40, green: 0.26, blue: 0.13)),
        MenuItem(name: "Green Tea",     subtitle: "Japanese organic matcha",    systemIcon: "leaf.fill",           color: Color(red: 0.18, green: 0.55, blue: 0.34)),
        MenuItem(name: "Orange Juice",  subtitle: "Freshly squeezed fruit",     systemIcon: "drop.fill",           color: Color(red: 0.93, green: 0.55, blue: 0.14)),
        MenuItem(name: "Cappuccino",    subtitle: "Creamy milk coffee",         systemIcon: "mug.fill",            color: Color(red: 0.55, green: 0.36, blue: 0.24)),
        MenuItem(name: "Sparkling Water", subtitle: "Carbonated mountain spring", systemIcon: "waterbottle.fill",  color: Color(red: 0.20, green: 0.60, blue: 0.86)),
    ]

    static let foods: [MenuItem] = [
        MenuItem(name: "Grilled Salmon", subtitle: "Fresh Atlantic fish",       systemIcon: "fish.fill",           color: Color(red: 0.90, green: 0.30, blue: 0.35)),
        MenuItem(name: "Garden Salad",   subtitle: "Mixed greens with herbs",   systemIcon: "leaf.circle.fill",    color: Color(red: 0.30, green: 0.69, blue: 0.31)),
        MenuItem(name: "Carrot Soup",    subtitle: "Creamy vegetable soup",     systemIcon: "carrot.fill",         color: Color(red: 0.93, green: 0.55, blue: 0.14)),
        MenuItem(name: "BBQ Steak",      subtitle: "Flame-grilled beef",        systemIcon: "flame.fill",          color: Color(red: 0.85, green: 0.26, blue: 0.22)),
        MenuItem(name: "Chef's Special Meal of the Day",     subtitle: "Chef's daily special",      systemIcon: "fork.knife",          color: Color(red: 0.55, green: 0.36, blue: 0.24)),
    ]
}
