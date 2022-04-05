//
//  MweApp.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//

import SwiftUI
import Request

@main

struct MweApp: App {
    @StateObject var user: User = User()
    @StateObject var posts = Posts()
    @State var selection = 1
    
    func getPosts(){
        let url = getApiUrl(endpoint: "posts")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        Request {
            Url(url)
            Method(.get)
            Header.Accept(.json)
        }
        .onData { postData in
            do {
                posts.postEntries = try decoder.decode([Post].self, from: postData)
            } catch {
                posts.postEntries = []
            }
        }
        .call()
    }

    @ViewBuilder
    var bodyView: some View {
        if user.isSignedIn {
            TabView(selection: $selection) {
                NavigationView {
                    MapView()
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
            }.onAppear(perform: getPosts)
        } else {
            NavigationView {
                LandingView()
                    .environmentObject(user)
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            bodyView
                .accentColor(.purple)
                .environmentObject(user)
                .environmentObject(posts)
        }
    }
}


typealias RequestBody = Body
