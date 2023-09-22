
import Foundation
import Alamofire
 
extension Session {
    
    /// Build the request based on the `NetworkTask` contained in the `target`
    /// - Parameter target: The `TargetType`
    /// - Returns: The `DataRequest`
    internal func buildRequest(target: TargetType) -> DataRequest {
        switch target.task {
        case .uploadFile(let file):
            return upload(file, with: target)
        case .uploadMultipart(let multipartBody),
                .uploadCompositeMultipart(let multipartBody, _):
            let formData = RequestMultipartFormData()
            formData.applyMoyaMultipartFormData(multipartBody)
            return upload(multipartFormData: formData, with: target)
        case .downloadDestination, .downloadParameters:
            let error = """
                        The task should neither be `downloadDestination` nor `downloadParameters`,
                        when building data request
                        """
            fatalError(error)
        default:
            return request(target)
        }
    }
    
    /// Build the download request based on the `NetworkTask` contained in the `target`
    /// - Parameter target: The `TargetType`
    /// - Returns: The `DataRequest`
    internal func buildDownloadRequest(target: TargetType) -> DownloadRequest {
        switch target.task {
        case .downloadDestination(let destination),
                .downloadParameters(_, _, let destination):
            return download(target, to: destination)
        default:
            let error = """
                        The task should be either `downloadDestination` or `downloadParameters`,
                        when building download request
                        """
            fatalError(error)
        }
    }
}
