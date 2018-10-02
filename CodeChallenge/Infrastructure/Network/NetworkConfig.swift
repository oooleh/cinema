//
//  ServiceConfig.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation

protocol NetworkConfigurable {
    var baseURL: String { get }
    var headers: [String: String] { get set }
    var queryParameters: [String: String] { get }
}

struct ApiDataNetworkConfig: NetworkConfigurable {
    private(set) var baseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as! String
    
    var headers: [String: String] = [:]
    var queryParameters: [String: String] = ["api_key": Bundle.main.object(forInfoDictionaryKey: "ApiKey") as! String]
}

struct ImageDataNetworkConfig: NetworkConfigurable {
    private(set) var baseURL = Bundle.main.object(forInfoDictionaryKey: "ImageBaseURL") as! String

    var headers: [String: String] = [:]
    var queryParameters: [String: String] = [:]
}
