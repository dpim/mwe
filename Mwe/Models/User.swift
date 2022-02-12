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
        if let name = keychain.get("name"), let email = keychain.get("email"){
            self.displayName = name
            self.email = email
            self.isSignedIn = true
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
        let keychain = KeychainSwift()
        self.displayName = nil
        self.email = nil
        self.isSignedIn = false
        self.lastUpdated = nil
        keychain.delete("name")
        keychain.delete("email")
    }
    
}
