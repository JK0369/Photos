//
//  PhotoSearchURLSessionMock.swift
//  UnsplashTests
//
//  Created by 김종권 on 2021/10/04.
//

import Foundation
@testable import Unsplash

class PhotoSearchURLSessionMock: URLSessionable {

    var makeRequestFail = false
    let sessionDataTask: URLSessionDataTaskMock!

    init(makeRequestFail: Bool = false, sessionDataTask: URLSessionDataTaskMock = URLSessionDataTaskMock()) {
        self.makeRequestFail = makeRequestFail
        self.sessionDataTask = sessionDataTask
    }

    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let endpoint = APIEndpoints.getSearchingPhotos(with: .init(query: "test-query", page: 1))

        // 성공 callback
        let successResponse = HTTPURLResponse(url: try! endpoint.url(),
                                              statusCode: 200,
                                              httpVersion: "2",
                                              headerFields: nil)
        // 실패 callback
        let failureResponse = HTTPURLResponse(url: try! endpoint.url(),
                                              statusCode: 301,
                                              httpVersion: "2",
                                              headerFields: nil)

        sessionDataTask.resumeDidCall = {
            if self.makeRequestFail {
                completionHandler(nil, failureResponse, nil)
            } else {
                completionHandler(endpoint.sampleData!, successResponse, nil)
            }
        }
        return sessionDataTask
    }

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let endpoint = APIEndpoints.getImages(with: "https://testurl.com/")

        // 성공 callback
        let successResponse = HTTPURLResponse(url: try! endpoint.url(),
                                              statusCode: 200,
                                              httpVersion: "2",
                                              headerFields: nil)
        // 실패 callback
        let failureResponse = HTTPURLResponse(url: try! endpoint.url(),
                                              statusCode: 301,
                                              httpVersion: "2",
                                              headerFields: nil)

        sessionDataTask.resumeDidCall = {
            if self.makeRequestFail {
                completionHandler(nil, failureResponse, nil)
            } else {
                completionHandler(endpoint.sampleData!, successResponse, nil)
            }
        }
        return sessionDataTask
    }
}
