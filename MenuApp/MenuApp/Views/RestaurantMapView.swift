//
//  RestaurantMapView.swift
//  MenuApp
//
//  Created by Stefan Tagarski on 28.3.26.
//

import SwiftUI
import Combine
import MapKit

struct RestaurantMapView: View {
    let itemName: String
    let coordinate: CLLocationCoordinate2D
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(.red)
                Text("Restaurant Location")
                    .font(.headline)
            }

            Map(initialPosition: .region(MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ))) {
                Marker(itemName, coordinate: coordinate)
                    .tint(.red)

                if let userLoc = locationManager.userLocation {
                    Marker("You", coordinate: userLoc)
                        .tint(.blue)
                }
            }
            .frame(height: 220)
            .cornerRadius(12)

            if let userLoc = locationManager.userLocation {
                let distance = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    .distance(from: CLLocation(latitude: userLoc.latitude, longitude: userLoc.longitude))
                Text(String(format: "%.1f km away from you", distance / 1000))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            locationManager.requestPermission()
        }
    }
}
