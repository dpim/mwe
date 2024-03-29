//
//  MweApp.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//

import SwiftUI
import Request
import Firebase

@main

struct MweApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
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
                }
                .tabItem {
                    Image(systemName: "map")
                    Text("Discover")
                }
                .tag(1)
                .navigationViewStyle(.stack)
                
                NavigationView {
                    GalleryView()
                        .environmentObject(user)
                        .environmentObject(posts)
                }
                .tabItem {
                    Image(systemName: "photo.on.rectangle")
                    Text("Gallery")
                }
                .tag(2)
                .navigationViewStyle(.stack)
                
                NavigationView {
                    SettingsView()
                        .environmentObject(user)
                }
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(3)
                .navigationViewStyle(.stack)
            }
            .onAppear(perform: fetchPosts)
            .onAppear(perform: {
                if let name = user.displayName, let email = user.email, let id = user.id {
                    user.signInWith(name: name, email: email, id: id)
                }
            })
            .onChange(of: posts.shouldFetch){
                _ in
                // if the latest change is flagging we should fetch, get new posts
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    fetchPosts()
                }
            }
        } else {
            NavigationView {
                LandingView()
                    .environmentObject(user)
            }
            .navigationViewStyle(.stack)
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

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
