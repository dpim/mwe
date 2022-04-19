//
//  MapView.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//

import SwiftUI
import MapKit
import Request

struct MapView: View {
    @EnvironmentObject var posts: Posts
    @EnvironmentObject var user: User 
    @State private var showingAddScreen = false
    @State private var region = MKCoordinateRegion(
            center:
                CLLocationCoordinate2D(
                    latitude: MapDefaults.latitude,
                    longitude: MapDefaults.longitude),
            span: MKCoordinateSpan(
                latitudeDelta: MapDefaults.zoom,
                longitudeDelta: MapDefaults.zoom
            )
    )
    
    private enum MapDefaults {
        static let latitude = 37.334_900
        static let longitude = -122.009_020
        static let zoom = 1.0
    }
        
    var ToolbarView: some View {
        return HStack {
            if (posts.isFetching){
                ProgressView()
            }
            if (user.isCreator) {
                Button {
                    showingAddScreen = true
                } label: {
                    Label("Create post", systemImage: "plus")
                }
            }
        }
    }
    
    var filteredPosts: [Post] {
        return posts.postEntries.filter { post in
            return !self.user.blockedPostIds.contains(post.id)
        }
    }
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, annotationItems: filteredPosts){ post in
                MapAnnotation(coordinate: .init(latitude: post.latitude, longitude: post.longitude)) {
                    VStack {
                        NavigationLink {
                            PostView(post: post)
                        } label: {
                            if post.paintingUrl != nil {
                                Image(systemName: "photo.circle.fill")
                                    .resizable()
                                    .shadow(radius: 1.0)
                                    .frame(width: 50, height: 50)
                                    .background(.regularMaterial)

                            } else {
                                Image(systemName: "photo.circle")
                                    .resizable()
                                    .shadow(radius: 1.0)
                                    .frame(width: 50, height: 50)
                                    .background(.regularMaterial)
                            }
                        }
                        .clipShape(Circle())
                        .foregroundColor(.purple)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showingAddScreen){
            CreatePostView(
                    latitude: region.center.latitude,
                    longitude: region.center.longitude
            )
        }
        .navigationTitle("Discover")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarView
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MapView()
                .environmentObject(User())
                .environmentObject(Posts())
        }
    }
}
