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
    let lastUpdated: Date?
    
    
    // update to load from data
    init(){
        self.displayName = "Dmitry"
        self.email = "dpim@something.com"
        self.isCreator = true
        self.isSignedIn = true
        self.lastUpdated = nil
    }
    
}
