//
//  User.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//

import Foundation

class User: ObservableObject {
    @Published var displayName: String?
    @Published var email: String?
    @Published var isSignedIn: Bool
    @Published var isCreator: Bool
    @Published var lastUpdated: Date?
    
    // update to load from data
    init(){
        self.isCreator = true
        let keychain = KeychainSwift()
        let (name, email, _, signedIn) = keychain.getMweAccountDetails()
        if let name = name, let email = email {
            self.displayName = name
            self.email = email
            self.isSignedIn = signedIn
            self.lastUpdated = Date()
        } else {
            self.displayName = nil
            self.email = nil
            self.isSignedIn = false
            self.lastUpdated = nil
        }
    }
    
    func signInWith(name: String, email: String){
        self.displayName = name
        self.email = email
        self.isSignedIn = true
        self.lastUpdated = Date()
    }
    
    func signOut(){
        self.displayName = nil
        self.email = nil
        self.isSignedIn = false
        self.lastUpdated = nil
        let keychain = KeychainSwift()
        keychain.setSignedOut()
    }
    
}
