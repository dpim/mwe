//
//  GalleryView.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 4/10/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct GalleryView: View {
    @EnvironmentObject var user: User
    @EnvironmentObject var posts: Posts
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var GridView: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(posts.postEntries){ post in
                if (post.paintingUrl != nil){
                    GeometryReader { gr in
                        ZStack {
                            NavigationLink {
                                PostView(post: post)
                            } label: {
                                ZStack {
                                    WebImage(url: URL(string: post.paintingUrl ?? ""))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: gr.size.width)
                                        .shadow(color: .black, radius: 2)
                                    LinearGradient(gradient: Gradient(colors: [.white.opacity(0.0), .black.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
                                        .edgesIgnoringSafeArea(.all)
                                }
                            }
                                .shadow(color: .black, radius: 2)
                            VStack {
                                Spacer()
                                Text(post.title)
                                    .font(
                                        .system(.caption)
                                        .bold()
                                    )
                                    .foregroundColor(.white)
                                    .padding()
                                    .multilineTextAlignment(.center)
                                }
                        }
                    }
                        .clipped()
                        .aspectRatio(1, contentMode: .fit)
                        .cornerRadius(5)

                }
            }
        }
    }
    
    var PostViews: some View  {
        VStack {
            if (self.posts.postEntries.count > 0){
                GridView
            } else if (!self.posts.isFetching){
                Text("No posts yet")
                    .padding()
            }
        }
        .navigationTitle("Gallery")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
            HStack {
                if (posts.isFetching){
                    ProgressView()
                }
                Button {
                    self.posts.shouldRefresh()
                } label: {
                    Image(systemName: "arrow.clockwise.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
            }
        )
    }
    
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            PostViews
        }
        .padding(.horizontal)
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
    }
}
