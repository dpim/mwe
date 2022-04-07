//
//  Posts.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//

import Foundation
import Request
import CloudKit

class Posts: ObservableObject, Equatable {
    @Published var postEntries: [Post]
    @Published var shouldFetch: Bool
    
    init(){
        self.postEntries = []
        self.shouldFetch = true
    }
    
    func shouldRefresh(){
        self.shouldFetch = true
    }
    
    static func == (lhs: Posts, rhs: Posts) -> Bool {
        lhs.shouldFetch == rhs.shouldFetch && lhs.postEntries.count == rhs.postEntries.count
    }
    
}
