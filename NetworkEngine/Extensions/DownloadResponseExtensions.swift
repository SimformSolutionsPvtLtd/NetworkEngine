//
//  DownloadResponseExtensions.swift
//  NetworkEngine
//
//  Created by Nishchal Visavadiya on 24/05/24.
//

import Foundation
import Alamofire

extension DownloadResponse where Failure == AFError {

    /// Mapped result with changed failure type of `NetworkError`
    var mappedResult: Result<Success, NetworkError> {
        return result.mapError { error in
            return NetworkError.networkError(error, response, nil)
        }
    }
}
