//
//  SettingsView.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var user: User
    var body: some View {
        Form {
            Section("Posts"){
                NavigationLink {
                    LikedView()
                } label: {
                    Text("Liked")
                }
            }
            
            Section("Account") {
                Button("Log out"){
                    self.user.isSignedIn = false
                }
            }
        }
        .navigationTitle(self.user.displayName?.split(separator: " ")[0] ?? "Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }.environmentObject(User())
    }
}
