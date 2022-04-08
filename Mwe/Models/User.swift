//
//  User.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//

import Foundation
import SwiftUI

class User: ObservableObject {
    @Published var displayName: String?
    @Published var email: String?
    @Published var id: String?
    @Published var isSignedIn: Bool
    @Published var lastUpdated: Date?
    @Published var blockedPostIds: [String]
    @Published var likedPostIds: [String]


    var isCreator: Bool {
       return true // (displayName == "Mary Pimenova")
    }
    
    // update to load from data
    init(){
        let keychain = KeychainSwift()
        let (name, email, id, signedIn) = keychain.getMweAccountDetails()
        self.blockedPostIds = []
        self.likedPostIds = []
        if let name = name, let email = email {
            self.displayName = name
            self.email = email
            self.isSignedIn = signedIn
            self.lastUpdated = Date()
            self.id = id
        } else {
            self.displayName = nil
            self.email = nil
            self.isSignedIn = false
            self.lastUpdated = nil
        }
    }
    
    func setUserPostIds(likedPosts: [String], blockedPosts: [String]){
        DispatchQueue.main.async {
            self.blockedPostIds = blockedPosts
            self.likedPostIds = likedPosts
        }
    }
    
    func signInWith(name: String, email: String, id: String? = nil){
        let keychain = KeychainSwift()
        if let id = id {
            keychain.setMweAccountDetails(name: name, email: email, id: id, signedIn: true)
        }
        self.id = id
        self.displayName = name
        self.email = email
        self.isSignedIn = true
        self.lastUpdated = Date()
    }
    
    func signOut(){
        let keychain = KeychainSwift()
        self.displayName = nil
        self.email = nil
        self.id = nil
        self.isSignedIn = false
        self.lastUpdated = nil
        keychain.setSignedOut()
    }
}
