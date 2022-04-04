//
//  Posts.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//

import Foundation
import Request

class Posts: ObservableObject {
    @Published var posts: [Post]
    
    init(){
        self.posts = []
        reload()
    }
    
    func reload(){
        let url = getApiUrl(endpoint: "posts")
        Request {
            Url(url)
            Method(.get)
            Header.Accept(.json)
        }.onJson({
            json in
            print(json)
        }).call()
        
    }
    
}
