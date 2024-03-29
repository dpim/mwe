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
import Request
import Json

struct LandingView: View {
    @State private var animationAmount = 0.5
    @EnvironmentObject var user: User
    let authScopes: [ASAuthorization.Scope] = [.fullName, .email]
    let delayForSignIn = 0.5 // in seconds
    
    private func delayedSignIn(_ name: String, _ email: String, _ id: String? = nil){
        DispatchQueue.main.asyncAfter(deadline: .now() + delayForSignIn) {
            user.signInWith(name: name, email: email, id: id)
        }
    }
    
    private func signInUser(credential: ASAuthorizationAppleIDCredential){
        let keychain = KeychainSwift()
        if let _ = credential.email {
            // new user
            let nameParts = credential.fullName!
            let name: String = PersonNameComponentsFormatter.localizedString(from: nameParts, style: .default)
            let email: String = credential.email!
            let id: String = credential.user
            
            // post user
            createUser(userId: id, displayName: name)?.call()
            delayedSignIn(name, email, id)
            
        } else {
            // existing user
            let (name, email, id, _, _) = keychain.getMweAccountDetails()
            if let email = email, let name = name, let id = id {
                delayedSignIn(name, email, id)
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .center){
                Text("mwe")
                    .font(
                        Font.system(size: 125)
                            .weight(.heavy)
                    )
                    .foregroundColor(.white)
                    .shadow(color: .white, radius: 1)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                Spacer()
                ZStack {
                    SignInWithAppleButton(.signIn) { request in
                        request.requestedScopes = authScopes
                    } onCompletion: { result in
                        switch result {
                        case .success(let authResults):
                            signInUser(credential: authResults.credential as! ASAuthorizationAppleIDCredential)
                        case .failure(let error):
                            print("Authorisation failed: \(error.localizedDescription)")
                        }
                    }.frame(height: 64, alignment: .center)
                        .padding()
                    Spacer()
                }
            }
        }.background{
            Image("watercolormap").rotationEffect(Angle(
                degrees: 25 + 10 * animationAmount)
            )
                .scaleEffect(1 + 0.5*animationAmount)
                .animation(
                    .easeInOut(duration: 5)
                        .repeatForever(autoreverses: true),
                    value: animationAmount + 1
                ).onAppear {
                    animationAmount = 0
                }
            LinearGradient(gradient: Gradient(colors: [.black.opacity(0.95), .purple.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        }.preferredColorScheme(.dark)
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView().environmentObject(User())
    }
}
