//
//  KeychainExtensions.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/13/22.
//

import Foundation

extension KeychainSwift {
    private static let nameKey = "name"
    private static let emailKey = "email"
    private static let idKey = "id"
    private static let signedInKey = "signedIn"
    
    func getMweAccountDetails() -> (name: String?, email: String?, id: String?, signedIn: Bool){
        let name = self.get(KeychainSwift.nameKey)
        let email = self.get(KeychainSwift.emailKey)
        let id = self.get(KeychainSwift.idKey)
        let signedIn = self.getBool(KeychainSwift.signedInKey)
        return (name, email, id, signedIn ?? false)
    }
    
    func setMweAccountDetails(name: String, email: String, id: String, signedIn: Bool){
        self.set(name, forKey: KeychainSwift.nameKey)
        self.set(email, forKey: KeychainSwift.emailKey)
        self.set(id, forKey: KeychainSwift.idKey)
        self.set(signedIn, forKey: KeychainSwift.signedInKey)
    }
    
    func setSignedOut(){
        self.set(false, forKey: KeychainSwift.signedInKey)
    }
    
}
