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
    private static let catImage = "https://i.imgur.com/L89fxDl.jpeg"

    static let example = Post(id: "\(UUID())", owner: User(), title: "Cacti at dawn", caption: "my photo", photoUrl: catImage, paintingUrl: catImage, latitude: 37.38, longitude: -122.00, postedDate: Date(), lastUpdatedDate: Date(), likedBy: [])
}
