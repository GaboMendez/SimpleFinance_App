//
//  LocationPickerView.swift
//  SimpleFinance
//
//  Created by Gabriel Mendez Reyes on 9/1/26.
//

import SwiftUI
import MapKit

struct LocationPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var locationManager = CLLocationManager()
    @State private var cameraPosition: MapCameraPosition
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var locationName: String = ""
    
    let onLocationSelected: (LocationInfo) -> Void
    let currentLocation: LocationInfo?
    
    init(currentLocation: LocationInfo?, onLocationSelected: @escaping (LocationInfo) -> Void) {
        self.currentLocation = currentLocation
        self.onLocationSelected = onLocationSelected
        
        if let location = currentLocation, location.latitude != 0 || location.longitude != 0 {
            let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            _selectedCoordinate = State(initialValue: coordinate)
            _locationName = State(initialValue: location.name ?? "")
            _cameraPosition = State(initialValue: .region(MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )))
        } else {
            // Default to San Francisco if no location
            let defaultCoordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
            _cameraPosition = State(initialValue: .region(MKCoordinateRegion(
                center: defaultCoordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )))
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                MapReader { proxy in
                    Map(position: $cameraPosition) {
                        if let coordinate = selectedCoordinate {
                            Marker(locationName.isEmpty ? "Location" : locationName, coordinate: coordinate)
                                .tint(.red)
                        }
                    }
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            selectedCoordinate = coordinate
                            Task {
                                await fetchLocationName(for: coordinate)
                            }
                        }
                    }
                }
                
                VStack(spacing: 16) {
                    TextField("Location name (optional)", text: $locationName)
                        .textFieldStyle(.roundedBorder)
                    
                    HStack(spacing: 12) {
                        Button {
                            locationManager.requestWhenInUseAuthorization()
                            if let userLocation = locationManager.location?.coordinate {
                                selectedCoordinate = userLocation
                                cameraPosition = .region(MKCoordinateRegion(
                                    center: userLocation,
                                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                ))
                                Task {
                                    await fetchLocationName(for: userLocation)
                                }
                            }
                        } label: {
                            Label("Use Current", systemImage: "location.fill")
                        }
                        .buttonStyle(.bordered)
                        
                        Button {
                            guard let coordinate = selectedCoordinate else { return }
                            let locationInfo = LocationInfo(
                                latitude: coordinate.latitude,
                                longitude: coordinate.longitude,
                                name: locationName.isEmpty ? nil : locationName
                            )
                            onLocationSelected(locationInfo)
                            dismiss()
                        } label: {
                            Text("Confirm")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(selectedCoordinate == nil)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
            }
            .navigationTitle("Pick Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                if currentLocation != nil {
                    ToolbarItem(placement: .destructiveAction) {
                        Button("Remove", role: .destructive) {
                            onLocationSelected(LocationInfo(latitude: 0, longitude: 0, name: nil))
                            dismiss()
                        }
                    }
                }
            }
        }
    }
    
    private func fetchLocationName(for coordinate: CLLocationCoordinate2D) async {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            guard let placemark = placemarks.first else { return }
            
            var components: [String] = []
            if let name = placemark.name { components.append(name) }
            if let locality = placemark.locality { components.append(locality) }
            
            if !components.isEmpty {
                locationName = components.joined(separator: ", ")
            }
        } catch {
            // Ignore geocoding errors
        }
    }
}
