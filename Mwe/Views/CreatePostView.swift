//
//  CreatePostView.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//
import SwiftUI
import Request
import Json

private let exampleLatitude = 37.382221
private let exampleLongitude = -122.1937

struct CreatePostView: View {
    @EnvironmentObject var user: User
    @Environment(\.presentationMode) var presentationMode
    @State var caption: String = ""
    @State var title: String = ""
    @State var photo: UIImage?
    @State var painting: UIImage?
    
    var latitude: Double
    var longitude: Double
    
    // has the required field
    var hasPhoto: Bool {
        return photo != nil
    }
    
    var readyForSubmission: Bool {
        return photo != nil && title.count > 0
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Details") {
                    NavigationLink {
                        PhotoCaptureView(photo: $photo)
                    } label: {
                        if let photo = photo {
                            Image(uiImage: photo)
                                .resizable()
                                .frame(width: 25, height: 25)
                                .scaledToFill()
                        } else {
                            Image(systemName: "camera")
                        }
                        Text("Take a photo")
                    }.foregroundColor(hasPhoto ? .primary : .accentColor)
                    
                    NavigationLink {
                        PhotoCaptureView(photo: $painting)
                    } label: {
                        if let painting = painting {
                            Image(uiImage: painting)
                                .resizable()
                                .frame(width: 25, height: 25)
                                .scaledToFill()
                        } else {
                            Image(systemName: "paintpalette")
                        }
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
                        // post user
                        let url = getApiUrl(endpoint: "posts")
                        let body = PostRequestBody(title: title, caption: caption, userId: user.id ?? "", latitude: latitude, longitude: longitude)
                        Request {
                            Url(url)
                            Method(.post)
                            Header.ContentType(.json)
                            RequestBody(body)
                        }.onJson({
                            json in
                            print(json)
                        }).call()
                    }){
                        HStack {
                            Text("Share")
                            Spacer()
                            Image(systemName: "paperplane")
                        }.foregroundColor(readyForSubmission ? .green : .gray)
                    }.disabled(!readyForSubmission)
                }
                
                
            }.navigationTitle("New post")
                .navigationBarBackButtonHidden(true)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing:
                                        Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "x.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
            )
        }
        .accentColor(.purple)
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView(latitude: exampleLatitude , longitude: exampleLongitude).environmentObject(User())
    }
}
