//
//  Result.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation

enum Result<T, Error> {
    case success(T)
    case failure(Error)
}
