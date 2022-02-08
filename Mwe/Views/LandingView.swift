//
//  LandingView.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//

import SwiftUI
import UIKit
import AuthenticationServices
import Contacts

struct LandingView: View {
    @EnvironmentObject var user: User
    let authScopes: [ASAuthorization.Scope] = [.fullName, .email]
    let nameKey = "name"
    let emailKey = "email"
    let idKey = "id"
    
    private func signInUser(credential: ASAuthorizationAppleIDCredential){
        let keychain = KeychainSwift()
        if let _ = credential.email {
            //new user
            let nameParts = credential.fullName!
            let name: String =     PersonNameComponentsFormatter.localizedString(from: nameParts, style: .default)
            let email: String = credential.email!
            let id: String = credential.user
            keychain.set(email, forKey: emailKey)
            keychain.set(name, forKey: nameKey)
            keychain.set(id, forKey: idKey)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                user.signInWith(name: name, email: email)
            }
        } else {
            // existing user
            if let email = keychain.get(emailKey), let name = keychain.get(nameKey){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    user.signInWith(name: name, email: email)
                }
            }
        }
    }
    
    
    var body: some View {
        VStack {
            Spacer()
            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = authScopes
            } onCompletion: { result in
                switch result {
                case .success(let authResults):
                    signInUser(credential: authResults.credential as! ASAuthorizationAppleIDCredential)
                case .failure(let error):
                    print("Authorisation failed: \(error.localizedDescription)")
                }
            }.frame(width: 200, height: 64, alignment: .center)
        }
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView().environmentObject(User())
    }
}
