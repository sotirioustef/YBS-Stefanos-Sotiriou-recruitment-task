//
//  YBSFlickrTests.swift
//  YBSFlickrTests
//
//  Created by Stefanos Sotiriou on 07/07/2024.
//

import XCTest
@testable import YBSFlickr

final class YBSFlickrTests: XCTestCase {
    
    var viewModel: PhotoListViewModel!
    var urlSession: URLSession!
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
        viewModel = PhotoListViewModel(session: urlSession)
    }
    
    override func tearDown() {
        viewModel = nil
        urlSession = nil
        super.tearDown()
    }
    
    // This test verifies the initial state of the PhotoListViewModel
    
    func testInitialState() {
        XCTAssertTrue(viewModel.photos.isEmpty)
        XCTAssertEqual(viewModel.searchQuery, "")
        XCTAssertEqual(viewModel.searchTags, [])
        XCTAssertEqual(viewModel.searchUserId, "")
        XCTAssertEqual(viewModel.matchAllTags, true)
        XCTAssertEqual(viewModel.safeSearch, "1")
    }
    
    // This test verifies that the composite search function fetches photos correctly
    
    func testCompositeSearch() {
        let expectation = self.expectation(description: "Photos fetched")
        let samplePhoto = Photo(id: "1", owner: "owner_id", secret: "secret", server: "server", farm: 1, title: "Sample Photo", tags: "Sample Tag", datetaken: "Sample Date", description: Description(_content: "Sample Description"), ownername: "Sample Name")
        let sampleResponse = FlickrResponse(photos: Photos(photo: [samplePhoto]))
        MockURLProtocol.requestHandler = { request in
            let data = try! JSONEncoder().encode(sampleResponse)
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        viewModel.searchQuery = "nature"
        viewModel.searchTags = ["mountain", "river"]
        viewModel.matchAllTags = false
        viewModel.safeSearch = "1"
        viewModel.compositeSearch()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.viewModel.photos.isEmpty)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // This test verifies that searching by text fetches photos correctly
    
    func testSearchByText() {
        let expectation = self.expectation(description: "Photos fetched")
        let samplePhoto = Photo(id: "1", owner: "owner_id", secret: "secret", server: "server", farm: 1, title: "Sample Photo", tags: "Sample Tag", datetaken: "Sample Date", description: Description(_content: "Sample Description"), ownername: "Sample Name")
        let sampleResponse = FlickrResponse(photos: Photos(photo: [samplePhoto]))
        MockURLProtocol.requestHandler = { request in
            let data = try! JSONEncoder().encode(sampleResponse)
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        viewModel.searchByText(query: "landscape")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.viewModel.photos.isEmpty)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // This test verifies that searching photos by user fetches photos correctly
    
    func testSearchPhotosByUser() {
        let expectation = self.expectation(description: "User photos fetched")
        let samplePhoto = Photo(id: "1", owner: "owner_id", secret: "secret", server: "server", farm: 1, title: "Sample Photo", tags: "Sample Tag", datetaken: "Sample Date", description: Description(_content: "Sample Description"), ownername: "Sample Name")
        let sampleResponse = FlickrResponse(photos: Photos(photo: [samplePhoto]))
        MockURLProtocol.requestHandler = { request in
            let data = try! JSONEncoder().encode(sampleResponse)
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        viewModel.searchPhotosByUsername(username: "12345")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.viewModel.photos.isEmpty)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
