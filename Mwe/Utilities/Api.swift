//
//  Api.swift
//  Mwe
//
//  Created by Dmitry Pimenov on 4/2/22.
//

import Foundation
import Request
import UIKit

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

struct UserIdBody: Codable {
    let userId: String
}

struct Base64Body: Codable {
    let image: String
}

enum ImageType: String {
    case photograph = "photo"
    case painting = "picture"
}

func getImageRequest(url: String, userId: String, image: UIImage?, type: ImageType) -> Request? {
    if let image = image {
        let resized = image.scalePreservingAspectRatio(targetSize: CGSize(width: 800, height: 800))
        if let imageData = resized.jpegData(compressionQuality: 0.5){
            let body = Base64Body(image: imageData.base64EncodedString())
            return Request {
                Url(url)
                Header.ContentType(.json)
                Method(.post)
                RequestBody(body)
            }
        }
    }
    return nil
}

func createPost(title: String, caption: String?, userId: String, latitude: Double, longitude: Double, photograph: UIImage?, painting: UIImage?) {
    let url = getApiUrl(endpoint: "posts")
    let body = PostRequestBody(title: title, caption: caption, userId: userId, latitude: latitude, longitude: longitude)
    Request {
        Url(url)
        Method(.post)
        Header.ContentType(.json)
        RequestBody(body)
    }.onJson({
        json in
        if let postId = json["postId"].stringOptional {
            // upload images
            let photoUrl = getApiUrl(endpoint: "posts/\(postId)/upload/photo")
            let pictureUrl = getApiUrl(endpoint: "posts/\(postId)/upload/picture")
                        
            let pictureRequest = getImageRequest(url: pictureUrl, userId: userId, image: painting, type: .painting)
            let photoRequest = getImageRequest(url: photoUrl, userId: userId, image: photograph, type: .painting)
            
            if pictureRequest == nil, let photoRequest = photoRequest {
                RequestGroup {
                    photoRequest
                }.call()
            } else if let photoRequest = photoRequest, let pictureRequest = pictureRequest {
                RequestGroup {
                    photoRequest
                    pictureRequest
                }.call()
            }
        }
    }).call()
}

func getPosts(success: @escaping (_ data: Data) -> Void){
    let url = getApiUrl(endpoint: "posts")
    Request {
        Url(url)
        Method(.get)
        Header.Accept(.json)
    }
    .onData { postData in
        DispatchQueue.main.async {
           success(postData)
        }
    }
    .call()
}

func addLike(userId: String, postId: String){
    let url = getApiUrl(endpoint: "posts/\(postId)/like")
    Request {
        Url(url)
        Method(.post)
        Header.ContentType(.json)
        RequestBody(UserIdBody(userId: userId))
    }
    .call()
}

func removeLike(userId: String, postId: String){
    let url = getApiUrl(endpoint: "posts/\(postId)/unlike")
    Request {
        Url(url)
        Method(.post)
        Header.ContentType(.json)
        RequestBody(UserIdBody(userId: userId))
    }
    .call()
}

