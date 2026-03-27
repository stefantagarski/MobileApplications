//
//  MenuData.swift
//  MenuApp
//
//  Created by Stefan Tagarski on 27.3.26.
//

import SwiftUI

struct MenuData {
    static let drinks: [MenuItem] = [
        MenuItem(name: "Espresso",
                 subtitle: "Strong Italian coffee",
                 description: "A concentrated coffee brewed by forcing hot water through finely-ground beans. Bold, rich, and full of aroma.",
                 systemIcon: "cup.and.saucer.fill",
                 color: Color(red: 0.40, green: 0.26, blue: 0.13)),
        MenuItem(name: "Green Tea",
                 subtitle: "Japanese organic matcha",
                 description: "Premium matcha green tea sourced from Uji, Japan. Packed with antioxidants and a smooth, earthy flavor.",
                 systemIcon: "leaf.fill",
                 color: Color(red: 0.18, green: 0.55, blue: 0.34)),
        MenuItem(name: "Orange Juice",
                 subtitle: "Freshly squeezed fruit",
                 description: "Made from hand-picked oranges, squeezed fresh every morning. Pure, natural, no added sugar.",
                 systemIcon: "drop.fill",
                 color: Color(red: 0.93, green: 0.55, blue: 0.14)),
        MenuItem(name: "Cappuccino",
                 subtitle: "Creamy milk coffee",
                 description: "A perfect balance of espresso, steamed milk, and velvety foam. Our most popular coffee drink.",
                 systemIcon: "mug.fill",
                 color: Color(red: 0.55, green: 0.36, blue: 0.24)),
        MenuItem(name: "Sparkling Water",
                 subtitle: "Carbonated mountain spring",
                 description: "Naturally sourced from mountain springs with fine bubbles. Refreshing and crisp.",
                 systemIcon: "waterbottle.fill",
                 color: Color(red: 0.20, green: 0.60, blue: 0.86)),
    ]

    static let foods: [MenuItem] = [
        MenuItem(name: "Grilled Salmon",
                 subtitle: "Fresh Atlantic fish",
                 description: "Wild-caught Atlantic salmon, grilled to perfection with lemon butter sauce and seasonal vegetables.",
                 systemIcon: "fish.fill",
                 color: Color(red: 0.90, green: 0.30, blue: 0.35)),
        MenuItem(name: "Garden Salad",
                 subtitle: "Mixed greens with herbs",
                 description: "A fresh mix of arugula, spinach, and romaine with cherry tomatoes, cucumber, and house vinaigrette.",
                 systemIcon: "leaf.circle.fill",
                 color: Color(red: 0.30, green: 0.69, blue: 0.31)),
        MenuItem(name: "Carrot Soup",
                 subtitle: "Creamy vegetable soup",
                 description: "Slow-cooked carrots blended with ginger and coconut cream. Warm, comforting, and full of flavor.",
                 systemIcon: "carrot.fill",
                 color: Color(red: 0.93, green: 0.55, blue: 0.14)),
        MenuItem(name: "BBQ Steak",
                 subtitle: "Flame-grilled beef",
                 description: "Premium cut beef steak, flame-grilled and served with roasted potatoes and garlic herb butter.",
                 systemIcon: "flame.fill",
                 color: Color(red: 0.85, green: 0.26, blue: 0.22)),
        MenuItem(name: "Dinner Set",
                 subtitle: "Chef's daily special",
                 description: "A curated three-course meal selected by our chef. Changes daily based on the freshest ingredients.",
                 systemIcon: "fork.knife",
                 color: Color(red: 0.55, green: 0.36, blue: 0.24)),
    ]
}
