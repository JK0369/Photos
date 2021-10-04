//
//  URLSessionDataTaskMock.swift
//  UnsplashTests
//
//  Created by 김종권 on 2021/10/04.
//

import Foundation

class URLSessionDataTaskMock: URLSessionDataTask {

    override init() {}

    var resumeDidCall: (() -> ())?

    override func resume() {
        resumeDidCall?()
    }
}
