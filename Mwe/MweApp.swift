//
//  MweApp.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//

import SwiftUI

@main
struct MweApp: App {
    @StateObject var user = User()
    @StateObject var posts = Posts()
    @State var selection = 1

    @ViewBuilder
    var bodyView: some View {
        if user.isSignedIn {
            TabView(selection: $selection) {
                NavigationView {
                    MapView()
                        .environmentObject(user)
                        .environmentObject(posts)
                }
                .tabItem {
                    Image(systemName: "map")
                    Text("Discover")
                }.tag(1)
                
                NavigationView {
                    SettingsView()
                        .environmentObject(user)
                }
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }.tag(2)
            }
        } else {
            NavigationView {
                LandingView()
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            bodyView.accentColor(.purple)
        }
    }
}
