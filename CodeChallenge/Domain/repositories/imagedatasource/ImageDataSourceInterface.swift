//
//  ImageDataSourceInterface.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation
import UIKit


protocol ImageDataSourceInterface {
    
    func image(with endpoint: Requestable, result: @escaping (Result<UIImage, Error>) -> Void) -> CancelableTask?
}
