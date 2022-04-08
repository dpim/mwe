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
    @Published var isFetching: Bool
    
    init(){
        self.postEntries = []
        self.shouldFetch = true
        self.isFetching = false
    }
    
    func shouldRefresh(){
        self.shouldFetch = true
    }
    
    func didRefresh(withResults results: [Post]){
        self.postEntries = results
        self.isFetching = false
        self.shouldFetch = false
    }
    
    func isRefreshing(){
        self.isFetching = true
    }
    
    static func == (lhs: Posts, rhs: Posts) -> Bool {
        lhs.shouldFetch == rhs.shouldFetch && lhs.postEntries.count == rhs.postEntries.count
    }
    
}
