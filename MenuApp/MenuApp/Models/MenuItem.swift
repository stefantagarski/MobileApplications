//
//  MenuItem.swift
//  MenuApp
//
//  Created by Stefan Tagarski on 27.3.26.
//
import SwiftUI

struct MenuItem: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
    let description: String
    let systemIcon: String
    let color: Color
}
