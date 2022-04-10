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
    @State var painting: UIImage?
    @State private var showingAddScreen = false
    @State private var fetchingPost = false
    @State var post: Post

    func onNewPost(data: Data){
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        do {
            post = try decoder.decode(Post.self, from: data)
        } catch {
            print("could not update post")
        }
        self.fetchingPost = false
    }
    
    func getLikes(){
        didLikePost = post.likedBy.contains(user.id ?? "")
        likeCount = max(post.likedBy.count, likeCount)
    }
    
    var addPaintingButton: some View {
        Button {
            showingAddScreen = true
        } label: {
            HStack {
                Image(systemName: "paintpalette")
                Text("Add your painting")
            }.padding()
        }
    }
    
    var likeButton: some View {
        let likeButtonColor = didLikePost ? Color.accentColor : Color.gray
        let likeText = likeCount == 0 ? "Like" : "Liked by \(likeCount)"
        return HStack {
            Button {
                // update count
                if let userId = user.id {
                    let postId = post.id
                    if (didLikePost){
                        removeLike(userId: userId, postId: postId)
                        if let index = user.likedPostIds.firstIndex(of: postId){
                            user.likedPostIds.remove(at: index)
                        }
                        likeCount -= 1
                    } else {
                        addLike(userId: userId, postId: postId)
                        user.likedPostIds.append(postId)
                        likeCount += 1
                    }
                }
                didLikePost = !didLikePost
            } label: {
                Label(likeText, systemImage: "hand.thumbsup.circle")
            }.foregroundColor(likeButtonColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
                
                if (post.paintingUrl != nil){
                    WebImage(url: URL(string: post.paintingUrl ?? ""))
                        .resizable()
                        .scaledToFill()
                        .padding()
                        .shadow(color: .black, radius: 2)
                } else if (user.isCreator){
                    if (self.fetchingPost){
                        ProgressView()
                    } else {
                        addPaintingButton
                    }
                }
            }
            
            Section("Likes"){
                HStack {
                    likeButton
                }.padding()
            }
            
            if let caption = post.caption, caption.count > 1 {
                Section("Caption"){
                    Text(post.caption ?? "-").padding()
                }
            }
            
            Section("Details"){
                HStack {
                    Image(systemName: "clock")
                    Text("Created on \(self.formattedDate(post.createdDate))")
                }.padding()
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
        .fullScreenCover(isPresented: $showingAddScreen){
            PhotoCaptureView(photo: $painting)
                .accentColor(.purple)
        }
        .onChange(of: painting, perform: {
            _ in
            if let userId = user.id {
                fetchingPost = true
                addPainting(postId: post.id, userId: userId, image: painting){
                    getPost(postId: post.id, success: onNewPost)
                }
            }
        })
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
