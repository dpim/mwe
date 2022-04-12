//
//  MiniMapView.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 4/11/22.
//

import SwiftUI
import MapKit

struct MiniMapView: View {
    private let zoom = 0.1
    @State var latitude: Double
    @State var longitude: Double
    
    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
        center:
            CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude),
            span: MKCoordinateSpan(
                    latitudeDelta: zoom,
                    longitudeDelta: zoom)
        )
    }
    
    private struct MapPoint: Identifiable {
        let location: CLLocationCoordinate2D
        let id: String
    }
    
    private var locations: [MapPoint] {
        let point = MapPoint(location: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), id: "point")
        return [point]
    }
    
    var body: some View {
        Map(coordinateRegion: .constant(region), annotationItems: locations){
            point in
            MapAnnotation(coordinate: point.location) {
//                NavigationLink {
//                    //test
//                } label: {
                    Image(systemName: "mappin.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .background(.regularMaterial)
                        .clipShape(Circle())
                        .foregroundColor(.purple)
//               }
            }
        }
    }
}

struct MiniMapView_Previews: PreviewProvider {
    static var previews: some View {
        MiniMapView(latitude: 30.0, longitude: 130.0)
    }
}
