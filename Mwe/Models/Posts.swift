//
//  Posts.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//

import Foundation

class Posts: ObservableObject {
    @Published var posts: [Post]
    
    init(){
        self.posts = [.example]
    }
}
