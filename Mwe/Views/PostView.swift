//
//  PostView.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostView: View {
    @EnvironmentObject var user: User
    @State private var likeCount = 0
    @State private var didLikePost = false
    @State private var showingAlert = false
    let post: Post
    
    var LikeButton: some View {
        didLikePost = post.likedBy.contains(user.email ?? "")
        likeCount = max(post.likedBy.count, likeCount)
        let likeButtonColor = didLikePost ? Color.accentColor : Color.gray
        let likeText = likeCount == 0 ? "Like" : "Liked by \(likeCount)"
        return HStack {
            Button {
                // update count
                if (didLikePost){
                    likeCount -= 1
                } else {
                    likeCount += 1
                }
                // post like
                
                didLikePost = !didLikePost
            } label: {
                Label(likeText, systemImage: "hand.thumbsup.circle")
            }.foregroundColor(likeButtonColor)
        }.frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    var toolbarView: some View {
        return HStack {
            Button {
                showingAlert = true
            } label: {
                Label("Report", systemImage: "questionmark.circle")
            }
        }
    }
    
    var body: some View {
        List {
            Section(){
                WebImage(url: URL(string: post.photoUrl ?? ""))
                    .resizable()
                    .scaledToFill()
                    .padding()
                    .shadow(color: .black, radius: 2)
                
                WebImage(url: URL(string: post.paintingUrl ?? ""))
                    .resizable()
                    .scaledToFill()
                    .padding()
                    .shadow(color: .black, radius: 2)
                LikeButton
            }
            
            Section("Caption"){
                Text(post.caption)
            }
            
            Section("Details"){
                Text("Created on \(self.formattedDate(post.postedDate))")
            }
        }
        .navigationTitle(self.post.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            UITableView.appearance().contentInset.top = -35
        })
        .toolbar {
            toolbarView
        }
        .alert("Report this post for review?", isPresented: $showingAlert) {
            Button("Report post", role: .destructive) {
                // report post
            }
            Button("Cancel", role: .cancel) { }
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        return dateFormatterPrint.string(from: date)
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PostView(post: Post.example).environmentObject(User())
        }
    }
}
