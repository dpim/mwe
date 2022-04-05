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
    @Published var postEntries: [Post]
    
    init(){
        self.postEntries = []
    }
}
