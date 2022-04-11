//
//  PostView.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var user: User
    @EnvironmentObject var posts: Posts
    @State private var likeCount = 0
    @State private var didLikePost = false
    @State private var showingMenuDialog = false
    @State private var showingAddScreen = false
    @State private var fetchingPost = false
    @State var post: Post
    @State var painting: UIImage?

    func dismiss(){
        self.posts.shouldRefresh()
        self.mode.wrappedValue.dismiss()
    }

    func onNewPost(data: Data){
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        do {
            post = try decoder.decode(Post.self, from: data)
        } catch {
            print("could not update post")
        }
        self.fetchingPost = false
        posts.shouldRefresh()
    }
    
    func getLikes(){
        didLikePost = post.likedBy.contains(user.id ?? "")
        likeCount = max(post.likedBy.count, likeCount)
    }
    
    var PaintingButton: some View {
        Button {
            showingAddScreen = true
        } label: {
            HStack {
                Image(systemName: "paintpalette")
                Text("Add your painting")
            }.padding()
        }
    }
    
    var LikeButton: some View {
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
    
    var ToolbarView: some View {
        return HStack {
            Button {
                self.showingMenuDialog = true
            } label: {
                Label("Report", systemImage: "ellipsis.circle")
            }
        }
    }
    
    var body: some View {
        List {
            Section(){
                if let photoUrl = post.photographUrl{
                    SquareImage(url: photoUrl)
                        .padding()
                }
                
                if let paintingUrl = post.paintingUrl {
                    SquareImage(url: paintingUrl)
                        .padding()
                } else if (user.isCreator){
                    if (self.fetchingPost){
                        ProgressView()
                    } else {
                        PaintingButton
                    }
                }
            }
            
            Section("Likes"){
                HStack {
                    LikeButton
                }.padding()
            }
            
            if let caption = post.caption, caption.count > 1 {
                Section("Caption"){
                    Text(post.caption ?? "-").padding()
                }
            }
            
            Section("Details"){
                VStack(alignment: .leading){
                    HStack {
                        Image(systemName: "clock")
                        Text("Created on \(formattedDate(post.createdDate))")
                    }.padding()
                    if let creatorDisplayName = post.createdByDisplayName {
                        HStack {
                            Image(systemName: "person.circle")
                            Text("Posted by \(creatorDisplayName)")
                        }.padding()
                    }
                }
            }
        }
        .navigationTitle(self.post.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            UITableView.appearance().contentInset.top = -35
        })
        .toolbar {
            ToolbarView
        }
        .confirmationDialog("Menu", isPresented: $showingMenuDialog) {
            if let userId = user.id {
                if userId == post.createdBy {
                    Button("Delete post", role: .destructive) {
                        // report post
                        deletePost(userId: userId, postId: post.id, success: dismiss)
                    }
                } else {
                    Button("Report & hide post", role: .destructive) {
                        // report post
                        reportPost(userId: userId, postId: post.id, success: dismiss)
                    }
                }
            }
            Button("Cancel", role: .cancel) {
                self.showingMenuDialog = false
            }
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
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PostView(post: Post.example).environmentObject(User())
        }
    }
}
