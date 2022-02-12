//
//  PostView.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostView: View {
    let post: Post
    var body: some View {
        List {
            Section(){
                WebImage(url: URL(string: post.photoUrl ?? ""))
                    .resizable()
                    .scaledToFill()
                    .padding()
                    .shadow(color: .black, radius: 2)
                
                WebImage(url: URL(string: post.paintingUrl ?? ""))
                    .resizable()
                    .scaledToFill()
                    .padding()
                    .shadow(color: .black, radius: 2)
            }
            
            Section("Caption"){
                Text(post.caption)
            }
            
            Section("Details"){
                Text("Created on \(self.formattedDate(post.postedDate))")
            }
        }
        .navigationTitle(self.post.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            UITableView.appearance().contentInset.top = -35
        })
    }
    
    func formattedDate(_ date: Date) -> String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        return dateFormatterPrint.string(from: date)
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: Post.example)
    }
}
