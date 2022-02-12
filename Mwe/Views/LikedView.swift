//
//  LikedView.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct CellView: View {
    var post: Post
    var body: some View {
        NavigationLink {
            PostView(post: post)
        } label: {
            HStack {
                Text(post.title)
                Spacer()
                WebImage(url: URL(string: post.paintingUrl ?? ""))
                    .placeholder(
                        Image(systemName: "photo.fill")
                    )
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 20, alignment: .center)
            }
        }
    }
}


struct LikedView: View {
    var body: some View {
        List {
                CellView(post: Post.example)
                CellView(post: Post.example)
        }.navigationBarTitle("Liked")
    }
}

struct LikedView_Previews: PreviewProvider {
    static var previews: some View {
        LikedView()
    }
}
