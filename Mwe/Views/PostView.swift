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
    
    func getLikes(){
        didLikePost = post.likedBy.contains(user.id ?? "")
        likeCount = max(post.likedBy.count, likeCount)
    }
    
    var LikeButton: some View {
        let likeButtonColor = didLikePost ? Color.accentColor : Color.gray
        let likeText = likeCount == 0 ? "Like" : "Liked by \(likeCount)"
        return HStack {
            Button {
                // update count
                if let userId = user.id {
                    if (didLikePost){
                        removeLike(userId: userId, postId: post.id)
                        likeCount -= 1
                    } else {
                        addLike(userId: userId, postId: post.id)
                        likeCount += 1
                    }
                }
                didLikePost = !didLikePost
            } label: {
                Label(likeText, systemImage: "hand.thumbsup.circle")
            }.foregroundColor(likeButtonColor)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .onAppear(perform: getLikes)
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
                WebImage(url: URL(string: post.photographUrl ?? ""))
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
            
            if let caption = post.caption, caption.count > 1 {
                Section("Caption"){
                    Text(post.caption ?? "-")
                }
            }
            
            Section("Details"){
                Text("Created on \(self.formattedDate(post.createdDate))")
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
                if let userId = user.id {
                    reportPost(userId: userId, postId: post.id)
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        let epoch = date.timeIntervalSince1970/1000
        let updatedDate = Date(timeIntervalSince1970: epoch)
        return dateFormatterPrint.string(from: updatedDate)
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PostView(post: Post.example).environmentObject(User())
        }
    }
}
