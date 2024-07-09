//
//  PhotoListViewModel.swift
//  YBSFlickr
//
//  Created by Stefanos Sotiriou on 04/07/2024.
//

import SwiftUI
import Combine

enum SearchType {
    case text
    case username
}

class PhotoListViewModel: ObservableObject {
    @Published var photos = [Photo]()
    @Published var searchQuery = ""
    @Published var searchTags = [String]()
    @Published var searchUserId = ""
    @Published var matchAllTags: Bool = true
    @Published var safeSearch: String = "1"
    @Published var searchType: SearchType = .text

    let apiKey = "1c2c27cac9d1a8c58fc833ba8d0ca1ff"
    private var session: URLSession

    // MARK: Lifecycle

    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Public Methods

    /*
     Composite Search Function
     This function constructs the query parameters for the Flickr API search request
     based on the search type (text or username), search tags, and other search settings.
     It then calls the function that performs the search using these parameters.
    */

    func compositeSearch() {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "method", value: "flickr.photos.search"))
        queryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        queryItems.append(URLQueryItem(name: "format", value: "json"))
        queryItems.append(URLQueryItem(name: "sort", value: "relevance"))
        queryItems.append(URLQueryItem(name: "nojsoncallback", value: "1"))
        queryItems.append(URLQueryItem(name: "safe_search", value: safeSearch))
        queryItems.append(URLQueryItem(name: "extras", value: "tags,date_taken,description,owner_name"))
        if !searchTags.isEmpty {
            let tagMode = matchAllTags ? "all" : "any"
            let tagsString = searchTags.joined(separator: ",")
            queryItems.append(URLQueryItem(name: "tags", value: tagsString))
            queryItems.append(URLQueryItem(name: "tag_mode", value: tagMode))
        }
        if searchType == .text, !searchQuery.isEmpty {
            queryItems.append(URLQueryItem(name: "text", value: searchQuery))
        } else if searchType == .username, !searchQuery.isEmpty {
            findUserIdByUsername(username: searchQuery) { userId in
                guard let userId = userId else {
                    print("User not found")
                    return
                }
                queryItems.append(URLQueryItem(name: "user_id", value: userId))
                self.performSearch(queryItems: queryItems)
            }
            return
        }

        performSearch(queryItems: queryItems)
    }

    func searchPhotosByUsername(username: String) {
        searchType = .username
        searchQuery = username
        compositeSearch()
    }

    func setSearchTypeAndQuery(type: SearchType, query: String) {
        self.searchType = type
        self.searchQuery = query
    }

    func searchByText(query: String?) {
        let urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(query ?? "")&sort=relevance&format=json&nojsoncallback=1&safe_search=1&extras=tags,date_taken,description,owner_name"
        guard let url = URL(string: urlString) else { return }

        session.dataTask(with: url) { data, response, error in
            self.handleSearchResponse(data: data, response: response, error: error)
        }.resume()
    }

    // MARK: - Private Methods

    /*
     This function performs a search request to the Flickr API using the provided query items.
     It constructs the URL from the query items, makes a network request, 
     and decodes the response.
    */

    private func performSearch(queryItems: [URLQueryItem]) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.flickr.com"
        urlComponents.path = "/services/rest/"
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            print("Invalid URL")
            return
        }

        session.dataTask(with: url) { data, response, error in
            self.handleSearchResponse(data: data, response: response, error: error)
        }.resume()
    }

    /*
     This function makes a network request to the Flickr API to find the user ID
     associated with the provided username.
     It uses the `flickr.people.findByUsername`method to perform this lookup.
     The result is returned asynchronously via a completion handler.
     */

    private func findUserIdByUsername(username: String, completion: @escaping (String?) -> Void) {
        let urlString = "https://api.flickr.com/services/rest/?method=flickr.people.findByUsername&api_key=\(apiKey)&username=\(username)&format=json&nojsoncallback=1"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                if let response = try? decoder.decode(FlickrFindUserResponse.self, from: data) {
                    completion(response.user.id)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }

    func handleSearchResponse(data: Data?, response: URLResponse?, error: Error?) {
        if let data = data {
            let decoder = JSONDecoder()
            if let response = try? decoder.decode(FlickrResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.photos = response.photos.photo
                }
            }
        }
    }
}

// MARK: - FlickrFindUserResponse Struct

struct FlickrFindUserResponse: Codable {
    let user: FlickrUser
}

// MARK: - FlickrUser Struct

struct FlickrUser: Codable {
    let id: String
}
