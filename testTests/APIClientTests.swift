//
//  APIClientTests.swift
//  testTests
//
//  Created by Vaibhav Singh on 30/04/20.
//  Copyright © 2020 Vaibhav Singh. All rights reserved.
//

import XCTest
@testable import test

class APIClientTests: XCTestCase {
    var sut: APIClient!

    var mockUrlSession: MockUrlSession!
    
    var urlComps: URLComponents?{
        guard let url = mockUrlSession.url else {
                   return nil
               }
               
        return URLComponents(url: url, resolvingAgainstBaseURL: true)
    }

    override func setUp() {
        sut = APIClient()
        mockUrlSession = MockUrlSession(data: nil, urlResponse: nil, error:  nil)
        sut.session = mockUrlSession
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_Login_usesExpectedHost() {
        
        let completion = { (token: Token?, error: Error?) in
            
        }
        sut.loginUser(withName: "vab", password: "1234", completion: completion)
        
       
        XCTAssertEqual(urlComps?.host, "awesometodos.com")
    }
    
    func test_Login_usesExpectedPath() {
        
        let completion = { (token: Token?, error: Error?) in
            
        }
        sut.loginUser(withName: "vab", password: "1234", completion: completion)
        XCTAssertEqual(urlComps?.path, "/login")
    }
    
    func test_Login_usesExpectedQuery() {
        let completion = { (token: Token?, error: Error?) in
            
        }
        sut.loginUser(withName: "vab", password: "1234", completion: completion)
        XCTAssertEqual(urlComps?.query, "username=vab&password=1234")
    }
    
    class MockUrlSession: SessionProtocol {
        var url: URL?
        private let dataTask: MockTask
        
        init(data: Data?, urlResponse: URLResponse?, error: Error?) {
            dataTask = MockTask(data: data, urlResponse: urlResponse, error: error)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
            dataTask.completionHandler = completionHandler
            return dataTask
        }
    }
    
    class MockTask: URLSessionDataTask {
        private let data: Data?
        private let urlResponse: URLResponse?
        private let responseError: Error?
        
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: CompletionHandler?
        
        init(data: Data?, urlResponse: URLResponse?, error: Error?) {
            self.data = data
            self.urlResponse = urlResponse
            self.responseError = error
        }
        
        override func resume() {
            DispatchQueue.main.async {
                self.completionHandler?(self.data, self.urlResponse, self.responseError)
            }
        }
    }
    
    func test_Login_WhenSuccessful_creates_token() {
        let jsonData =
            "{\"token\": \"1234567890\"}"
              .data(using: .utf8)

        mockUrlSession = MockUrlSession(data: jsonData, urlResponse: nil, error: nil)
        sut.session = mockUrlSession
        let tokenExpectation = expectation(description: "tokens")
        var caughtToken: Token? = nil
        
        sut.loginUser(withName: "FOO", password: "Bar") { (token, _) in
            caughtToken = token
            tokenExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { (_) in
            XCTAssertEqual(caughtToken?.id, "1234567890")
        }
    }

}
