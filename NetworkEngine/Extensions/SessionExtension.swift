
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
            formData.applyMultipartFormData(multipartBody)
            return upload(multipartFormData: formData, with: target)
        case .requestPlain,
                .requestData,
                .requestJSONEncodable,
                .requestCustomJSONEncodable,
                .requestParameterEncodable,
                .requestParameters,
                .requestCompositeData,
                .requestCompositeParameters:
            return request(target)
        case .downloadDestination, .downloadParameters:
            let error = """
                        The task should not be a download task, when building data request
                        """
            fatalError(error)
        }
    }
    
    /// Build the download request based on the `NetworkTask` contained in the `target`
    /// - Parameter target: The `TargetType`
    /// - Returns: The `DataRequest`
    internal func buildDownloadRequest(target: TargetType) -> DownloadRequest {
        switch target.task {
        case .downloadDestination(let destination, let resumeData):
            return buildDownloadRequest(target: target,
                                        destination: destination,
                                        resumeData: resumeData)
        case .downloadParameters(_, _, let destination, let resumeData):
            return buildDownloadRequest(target: target,
                                        destination: destination,
                                        resumeData: resumeData)
        case .requestPlain,
                .requestData,
                .requestJSONEncodable,
                .requestCustomJSONEncodable,
                .requestParameterEncodable,
                .requestParameters,
                .requestCompositeData,
                .uploadFile,
                .uploadMultipart,
                .uploadCompositeMultipart,
                .requestCompositeParameters:
            let error = """
                        The task should be download task when building download request
                        """
            fatalError(error)
        }
    }
    
    private func buildDownloadRequest(target: TargetType,
                                      destination: @escaping DownloadDestination,
                                      resumeData: Data?) -> DownloadRequest {
        if let resumeData {
            return download(resumingWith: resumeData,
                            to: destination)
        } else {
            return download(target, to: destination)
        }
    }
}
