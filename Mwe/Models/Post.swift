//
//  Post.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 2/5/22.
//

import Foundation

struct Post: Identifiable, Codable
{
    let id: String
    let title: String
    let caption: String?
    let photographUrl: String?
    let paintingUrl: String?
    let latitude: Double
    let longitude: Double
    let createdBy: String
    let likedBy: [String]
    var createdDate: Date
    var createdByDisplayName: String?
    var lastUpdatedDate: Date
    
    
    private static let catImage = "https://i.imgur.com/L89fxDl.jpeg"

    static let example = Post(id: "\(UUID())", title: "Cacti at dawn", caption: "my photo", photographUrl: catImage, paintingUrl: catImage, latitude: 37.38, longitude: -122.00, createdBy: "test_user", likedBy: [], createdDate: Date(), lastUpdatedDate: Date())
        
}
