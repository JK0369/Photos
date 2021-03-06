//
//  APIEndpoints.swift
//  Pagination
//
//  Created by 김종권 on 2021/09/30.
//

import Foundation

struct APIEndpoints {
    static func getPhotosInfo(with photoListRequestDTO: PhotoListRequestDTO) -> Endpoint<[PhotoListResponseDTO]> {
        return Endpoint(baseURL: "https://api.unsplash.com/",
                        path: "photos",
                        method: .get,
                        queryParameters: photoListRequestDTO,
                        headers: ["Authorization": "Client-ID \(AppConfiguration.accessKey)"],
                        sampleData: NetworkResponseMock.photoList)
    }

    static func getSearchingPhotos(with photoSearchRequestDTO: PhotoSearchRequestDTO) -> Endpoint<PhotoSearchResponseDTO> {
        return Endpoint(baseURL: "https://api.unsplash.com/",
                        path: "search/photos",
                        method: .get,
                        queryParameters: photoSearchRequestDTO,
                        headers: ["Authorization": "Client-ID \(AppConfiguration.accessKey)"],
                        sampleData: NetworkResponseMock.photoSearch)
    }

    static func getImages(with url: String) -> Endpoint<Data> {
        return Endpoint(baseURL: url, sampleData: NetworkResponseMock.image)
    }
}
