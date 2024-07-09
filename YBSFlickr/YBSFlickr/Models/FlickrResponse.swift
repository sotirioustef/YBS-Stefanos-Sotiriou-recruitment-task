//
//  FlickrResponse.swift
//  YBSFlickr
//
//  Created by Stefanos Sotiriou on 04/07/2024.
//

import SwiftUI

struct FlickrResponse: Codable {
    let photos: Photos
}

struct Photos: Codable {
    let photo: [Photo]
}

struct Photo: Codable, Identifiable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let tags: String?
    let datetaken: String?
    let description: Description
    let ownername: String?

    var thumbnailUrl: String {
        return "https://live.staticflickr.com/\(server)/\(id)_\(secret)_q.jpg"
    }

    var mediumUrl: String {
        return "https://live.staticflickr.com/\(server)/\(id)_\(secret)_z.jpg"
    }

    var largeUrl: String {
        return "https://live.staticflickr.com/\(server)/\(id)_\(secret)_b.jpg"
    }

    var ownerIconUrl: String {
        return "https://www.flickr.com/buddyicons/\(owner).jpg"
    }
}

struct Description: Codable {
    let _content: String
}
