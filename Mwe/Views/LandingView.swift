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
    @State private var animationAmount = 0.5
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
        ZStack {
            VStack(alignment: .center){
                Spacer()
                Text("Mary Watercolor Experience")
                    .font(Font.system(size: 64, design: .serif)
                    )
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .shadow(color: .white, radius: 1)
                    .padding()
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
                    .padding()
                Spacer()
            }
        }.background{
            Image("watercolormap").rotationEffect(Angle(
                degrees: -25 + 5 * animationAmount)
            )
                .scaleEffect(1.5 + animationAmount)
                .animation(
                    .easeInOut(duration: 10)
                        .repeatForever(autoreverses: true),
                    value: animationAmount + 0.5
                ).onAppear {
                    animationAmount = 0.0
                }
            LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.9), .purple.opacity(0.95)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView().environmentObject(User())
    }
}
