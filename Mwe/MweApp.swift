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
    
    // handler for fetched post data
    func onNewPost(data: Data){
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        do {
            let postEntries = try decoder.decode([Post].self, from: data)
            posts.didRefresh(withResults: postEntries)
        } catch {
            posts.didRefresh(withResults: [])
        }
    }
    
    // handler for fetching blocked posts
    func onReceivedUserPosts(blockedPostIds: [String], likedPostIds: [String]){
        user.setUserPostIds(likedPosts: likedPostIds, blockedPosts: blockedPostIds)
    }
    
    func fetchPosts(){
        if let userId = self.user.id {
            posts.isRefreshing()
            getUserPosts(userId: userId, success: onReceivedUserPosts)
            getPosts(success: onNewPost)
        }
    }

    @ViewBuilder
    var bodyView: some View {
        if user.isSignedIn {
            TabView(selection: $selection) {
                NavigationView {
                    MapView()
                        .onAppear(perform: fetchPosts)
                        .onChange(of: posts.shouldFetch){
                            updatedShouldFetch in
                            // if the latest change is flagging we should fetch, get new posts
                            if updatedShouldFetch {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    fetchPosts()
                                }
                            }
                        }
                }
                .tabItem {
                    Image(systemName: "map")
                    Text("Discover")
                }
                    .tag(1)
                
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
