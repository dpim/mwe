//
//  CreatePostView.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//

import SwiftUI

private let exampleLatitude = 37.382221
private let exampleLongitude = -122.1937

struct CreatePostView: View {
    var latitude: Double
    var longitude: Double
    @Environment(\.presentationMode) var presentationMode
    @State var caption: String = ""
    @State var title: String = ""
    @State var photo: CGImage?
    @State var painting: CGImage?

    var hasPhoto: Bool {
        print(latitude)
        print(longitude)
        return photo != nil
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section("Details") {
                    NavigationLink {
                        PhotoCaptureView()
                    } label: {
                        Text("Take a photo")
                    }.foregroundColor(hasPhoto ? .primary : .blue)
                    
                    NavigationLink {
                        PhotoCaptureView()
                    } label: {
                        Text("Add your painting (optional)")
                    }
                        .disabled(!hasPhoto)
                    
                    
                    TextField("Title", text: $title)
                        .disabled(!hasPhoto)
                    
                    
                    TextField("Caption (optional)", text: $caption)
                        .disabled(!hasPhoto)
                    
                }
                Section("") {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }){
                        HStack {
                            Text("Share")
                            Spacer()
                            Image(systemName: "paperplane")
                        }.foregroundColor(hasPhoto ? .green : .gray)
                    }.disabled(!hasPhoto)
                }
            }.navigationTitle("New post")
                .navigationBarBackButtonHidden(true)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing:
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Label("Cancel", systemImage: "x.circle")
                    }
                )
            
        }
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView(latitude: exampleLatitude , longitude: exampleLongitude)
    }
}
