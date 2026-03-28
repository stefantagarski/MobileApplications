//
//  MenuItem.swift
//  MenuApp
//
//  Created by Stefan Tagarski on 27.3.26.
//
import SwiftUI
import CoreLocation

struct MenuItem: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
    let description: String
    let systemIcon: String
    let color: Color
    let coordinate: CLLocationCoordinate2D
}
