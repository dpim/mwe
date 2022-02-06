//
//  PostView.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//

import SwiftUI

struct PostView: View {
    let post: Post
    var body: some View {
        VStack {
            Text("Viewing post")
        }
        .navigationTitle(self.post.title ?? "Post")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: Post.example)
    }
}
