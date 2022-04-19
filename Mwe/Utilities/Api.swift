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

func getToken() -> String? {
    let keychain = KeychainSwift()
    let (_, _, _, token, _) = keychain.getMweAccountDetails()
    return token
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

struct LocationBody: Codable {
    let latitude: Double
    let longitude: Double
}

enum ImageType: String {
    case photograph = "photo"
    case painting = "picture"
}

func createApiToken(userId: String) -> Request? {
    let url = getApiUrl(endpoint: "token")
    let body = UserIdBody(userId: userId)
    return Request {
        Url(url)
        Method(.post)
        Header.ContentType(.json)
        RequestBody(body)
    }
}

func createUser(userId: String, displayName: String) -> Request? {
    let url = getApiUrl(endpoint: "users/\(userId)")
    let body = AccountRequestBody(displayName: displayName)
    return Request {
        Url(url)
        Method(.post)
        Header.ContentType(.json)
        RequestBody(body)
    }
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
    if let token = getToken(){
        let url = getApiUrl(endpoint: "posts")
        let body = PostRequestBody(title: title, caption: caption, userId: userId, latitude: latitude, longitude: longitude)
        Request {
            Url(url)
            Method(.post)
            Header.Authorization(.bearer(token))
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
}

func addPainting(postId: String, userId: String, image: UIImage?, success: @escaping (() -> ())){
    let pictureUrl = getApiUrl(endpoint: "posts/\(postId)/upload/picture")
    if let request = getImageRequest(url: pictureUrl, userId: userId, image: image, type: .painting){
        request
            .onData {
                _ in
                success()
            }
            .call()
            
    }
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

func getPost(postId: String, success: @escaping (_ data: Data) -> Void){
    let url = getApiUrl(endpoint: "posts/\(postId)")
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
    if let token = getToken(){
        let url = getApiUrl(endpoint: "posts/\(postId)/like")
        Request {
            Url(url)
            Method(.post)
            Header.Authorization(.bearer(token))
            Header.ContentType(.json)
            RequestBody(UserIdBody(userId: userId))
        }
        .call()
    }
}

func removeLike(userId: String, postId: String){
    if let token = getToken(){
        let url = getApiUrl(endpoint: "posts/\(postId)/unlike")
        Request {
            Url(url)
            Method(.post)
            Header.Authorization(.bearer(token))
            Header.ContentType(.json)
            RequestBody(UserIdBody(userId: userId))
        }
        .call()
    }
}

func reportPost(userId: String, postId: String, success: @escaping (() -> ())){
    let url = getApiUrl(endpoint: "posts/\(postId)/report")
    Request {
        Url(url)
        Method(.post)
        Header.ContentType(.json)
        RequestBody(UserIdBody(userId: userId))
    }
    .onData { _ in
        DispatchQueue.main.async {
           success()
        }
    }
    .call()
}

func updateLocation(userId: String, postId: String, latitude: Double, longitude: Double, success: @escaping (() -> ())){
    if let token = getToken(){
        let url = getApiUrl(endpoint: "posts/\(postId)/location")
        Request {
            Url(url)
            Method(.post)
            Header.Authorization(.bearer(token))
            Header.ContentType(.json)
            RequestBody(LocationBody(latitude: latitude, longitude: longitude))
        }
        .onData { _ in
            DispatchQueue.main.async {
               success()
            }
        }
        .call()
    }
}

func deletePost(userId: String, postId: String, success: @escaping (() -> ())){
    if let token = getToken(){
        let url = getApiUrl(endpoint: "posts/\(postId)/delete")
        Request {
            Url(url)
            Method(.post)
            Header.Authorization(.bearer(token))
            Header.ContentType(.json)
            RequestBody(UserIdBody(userId: userId))
        }
        .onData { _ in
            DispatchQueue.main.async {
               success()
            }
        }
        .call()
    }
}

func getUserPosts(userId: String, success: @escaping ((blockedPostIds: [String], likedPostIds: [String])) -> Void) {
    let url = getApiUrl(endpoint: "users/\(userId)")
    Request {
        Url(url)
        Method(.get)
        Header.Accept(.json)
    }.onJson({
        json in
        if let blockedPostsIds = json["blockedPosts"].arrayOptional, let likedPostIds = json["likedPosts"].arrayOptional {
            let blockedIds: [String] = blockedPostsIds.map({ String(describing: $0)})
            let likedIds: [String] = likedPostIds.map({ String(describing: $0)})
            success((blockedPostIds: blockedIds, likedPostIds: likedIds))
        }
    })
    .call()
}
