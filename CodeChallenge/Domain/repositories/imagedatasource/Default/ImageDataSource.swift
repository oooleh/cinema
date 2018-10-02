//
//  ImageDataSource.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation
import UIKit

class ImageDataSource {
    
    let dataTransferService: DataTransferInterface
    
    init(dataTransferService: DataTransferInterface) {
        self.dataTransferService = dataTransferService
    }
}

extension ImageDataSource: ImageDataSourceInterface {
    
    func image(with endpoint: Requestable, result: @escaping (Result<UIImage, Error>) -> Void) -> CancelableTask? {
        
        return dataTransferService.request(with: endpoint) { (response: Result<UIImage, Error>) in
            switch response {
            case .success(let image):
                result(.success(image))
                return
            case .failure(let error):
                result(.failure(error))
                return
            }
        }
    }
}
