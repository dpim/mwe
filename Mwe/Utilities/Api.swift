//
//  Api.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 4/2/22.
//

import Foundation

let baseUrl = "https://us-central1-snmk-340522.cloudfunctions.net/api"

func getApiUrl(endpoint: String) -> String {
    return "\(baseUrl)/\(endpoint)"
}

struct PostRequestBody: Codable {
    let title: String
    let caption: String?
    let userId: String
    let latitude: Double
    let longitude: Double
}

struct AccountRequestBody: Codable {
    let displayName: String
}

