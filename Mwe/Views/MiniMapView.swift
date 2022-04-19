//
//  MiniMapView.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 4/11/22.
//

import SwiftUI
import MapKit

struct MiniMapView: View {
    @EnvironmentObject var user: User
    @EnvironmentObject var posts: Posts
    var post: Post?
    private let zoom = 0.1
    private let fullInteraction: MapInteractionModes = [.all]
    @State var interactionModes: MapInteractionModes = []
    @State var region: MKCoordinateRegion
    @State var isEditing: Bool = false
    
    private var pinColor: Color {
        if (isEditing){
            return .gray
        } else {
            return .purple
        }
    }
    
    private var isInteractive: Bool {
        return (post != nil && post?.createdBy == user.id)
    }
    
    init(latitude: Double, longitude: Double, post: Post? = nil) {
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            span: MKCoordinateSpan(
                latitudeDelta: zoom,
                longitudeDelta: zoom
            ))
        self._region = State(initialValue: region)
        self.post = post
    }
    
    private struct MapPoint: Identifiable {
        let location: CLLocationCoordinate2D
        let id: String
    }
    
    private func getLocations (_ region: MKCoordinateRegion) -> [MapPoint] {
        let point = MapPoint(location: CLLocationCoordinate2D(latitude: region.center.latitude, longitude: region.center.longitude), id: "point")
        return [point]
    }
    
    private func updateEditState(){
        if (self.isInteractive){
            if let post = post, let userId = user.id, self.isEditing {
                // finish editing
                interactionModes = []
                updateLocation(userId: userId, postId: post.id, latitude: region.center.latitude, longitude: region.center.longitude, success: { posts.shouldRefresh() })
                
            } else {
                interactionModes = fullInteraction
            }
            self.isEditing = !self.isEditing
        }
    }
    
    
    var body: some View {
        Map(
            coordinateRegion: $region,
            interactionModes: interactionModes,
            annotationItems: getLocations(region)){
                point in
                MapAnnotation(coordinate: point.location ) {
                    Image(systemName: "mappin.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .background(.regularMaterial)
                        .clipShape(Circle())
                        .foregroundColor(self.pinColor)
                }
            }
            .cornerRadius(3.0)
            .onTapGesture {
                updateEditState()
            }
    }
}

struct MiniMapView_Previews: PreviewProvider {
    static var previews: some View {
        MiniMapView(latitude: 30.0, longitude: 130.0)
            .environmentObject(User())
    }
}
