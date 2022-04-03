//
//  Posts.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//

import Foundation
import Alamofire

class Posts: ObservableObject {
    @Published var posts: [Post]
    
    init(){
        self.posts = []
        reload()
    }
    
    func reload(){
        let url = getApiUrl(endpoint: "posts")
//        AF.request(url, method: .get).responseDecodable(of: Post) { response in
//            print(response)
//        }
    }
    
}
