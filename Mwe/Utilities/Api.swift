//
//  Api.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 4/2/22.
//

import Foundation
import Alamofire

let baseUrl = "https://us-central1-snmk-340522.cloudfunctions.net/api"

func getApiUrl(endpoint: String) -> String {
    return "\(baseUrl)/\(endpoint)"
}
