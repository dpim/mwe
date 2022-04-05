//
//  Posts.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//

import Foundation
import Request
import CloudKit

class Posts: ObservableObject {
    @Published var posts: [Post]
    
    init(){
        self.posts = []
        reload()
    }
    
    func reload(){
        let url = getApiUrl(endpoint: "posts")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        Request {
            Url(url)
            Method(.get)
            Header.Accept(.json)
        }
        .onData { posts in
            do {
                self.posts = try decoder.decode([Post].self, from: posts)
            } catch {
                
            }
        }
        .call()
    }
}
