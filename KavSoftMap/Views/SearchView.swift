//
//  SearchView.swift
//  KavSoftMap
//
//  Created by Rasheed on 10/2/24.
//

import SwiftUI
import MapKit

struct SearchView: View {
    @StateObject var locationManager: LocationManager = .init()
//MARK: Navigation Tag to Push View to MapView
    @State var navigationTag: String?
    
    
    var body: some View {
        VStack{
            HStack(spacing: 15) {
                Button {
                    
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                Text("Search Location")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 15) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Find Location here", text: $locationManager.searchText) {
                    
                }
            }
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background{
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(.gray)
                }
                .padding(.vertical, 10)
                
                
            if let places = locationManager.fetchedPlaces, !places.isEmpty {
                List {
                    ForEach(places, id: \.self){ place in
                        Button {
                            
                            if let coordinate = place.location?.coordinate {
                                locationManager.pickedLocation = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
                                locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                                locationManager.addDragglePin(cocordinate: coordinate)
                                locationManager.updatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                            }
                            
                            //MARK: Navigating To MapView
                            navigationTag = "MAPVIEW"
                            
                            
                            
                        } label: {
                            HStack(spacing: 15) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                
                                VStack(alignment: .leading, spacing: 6){
                                    Text(place.name ?? "")
                                        .font(.title3.bold())
                                        .foregroundColor(.primary)
                                    
                                    Text(place.locality ?? "")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }

                        }                 }
                }
                .listStyle(.plain)
            } else {
             
                //MARK: Live location button
                Button{
                    //MARK: Setting Map Region
                    if let coordinate = locationManager.userLocation?.coordinate {
                        locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                        locationManager.addDragglePin(cocordinate: coordinate)
                        locationManager.updatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                        
                        //MARK: Navigating To MapView
                        navigationTag = "MAPVIEW"
                    }
                } label: {
                    Label {
                        Text("Use Current Location")
                            .font(.callout)
                    } icon: {
                        Image(systemName: "location.north.circle.fill")
                    }
                    .foregroundColor(.green)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
        .background{
            NavigationLink(tag: "MapView", selection: $navigationTag) {
                MapViewSelection()
                .environmentObject(locationManager)
                .navigationBarHidden(true)
            } label: {
                
            }.labelsHidden()
        }
    }
}

#Preview {
    ContentView()
}




//MARK Mapview live selection
struct MapViewSelection: View {
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            MapViewHelper()
                .environmentObject(locationManager)
                .ignoresSafeArea()
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title2.bold())
                    .foregroundColor(.primary)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            
            //MARK: Displaying data
            if let place = locationManager.pickedPlaceMark {
                VStack(spacing: 15) {
                    Text("Confirm Location")
                        .font(.title2.bold())
                    
                    HStack(spacing: 15) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                        
                        VStack(alignment: .leading, spacing: 6){
                            Text(place.name ?? "")
                                .font(.title3.bold())
                            
                            Text(place.locality ?? "")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 10)
                    
                    
                    Button {
                        
                    } label: {
                        Text("Confirm Location")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background{
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.green)
                            }
                            .overlay(alignment: .trailing) {
                                Image(systemName: "arrow.right")
                                    .font(.title3.bold())
                                    .padding(.trailing)
                            }
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white)
                        .ignoresSafeArea()
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .onDisappear{
            locationManager.pickedLocation = nil
            locationManager.pickedPlaceMark = nil
            locationManager.mapView.removeAnnotations(locationManager.mapView.annotations)
        }
    }
}



//MARK: UIKIT MapView
struct MapViewHelper: UIViewRepresentable {
    @EnvironmentObject var locationManager: LocationManager
    func makeUIView(context: Context) -> MKMapView {
       return locationManager.mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
}
