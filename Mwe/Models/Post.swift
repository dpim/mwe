//
//  Post.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//

import Foundation

struct Post: Identifiable
{
    let id: String
    let owner: User
    let title: String
    let caption: String
    let photoUrl: String?
    let paintingUrl: String?
    let latitude: Double
    let longitude: Double
    let postedDate: Date
    let lastUpdatedDate: Date
    let likedBy: [String]

    static let example = Post(id: "\(UUID())", owner: User(), title: "Cacti at dawn", caption: "my photo", photoUrl: "google.com", paintingUrl: "yahoo.com", latitude: 37.38, longitude: -122.00, postedDate: Date(), lastUpdatedDate: Date(), likedBy: [])
}
