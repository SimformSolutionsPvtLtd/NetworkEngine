
import Foundation
import Alamofire

/// Represents "multipart/form-data" for an upload.
public struct MultipartFormData: Hashable {

    public init(provider: FormDataProvider,
                name: String,
                fileName: String? = nil,
                mimeType: String? = nil) {
        self.provider = provider
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
    }

    /// The method being used for providing form data.
    public let provider: FormDataProvider

    /// The name.
    public let name: String

    /// The file name.
    public let fileName: String?

    /// The MIME type
    public let mimeType: String?

    /// Method to provide the form data.
    public enum FormDataProvider: Hashable {
        case data(Foundation.Data)
        case file(URL)
        case stream(InputStream, UInt64)
    }
}

// MARK: RequestMultipartFormData appending
extension RequestMultipartFormData {
    
    /// Append the data and and form data
    /// - Parameters:
    ///   - data: The data to append
    ///   - bodyPart: The`MultipartFormData` to append
    func append(data: Data, bodyPart: MultipartFormData) {
        append(
            data,
            withName: bodyPart.name,
            fileName: bodyPart.fileName,
            mimeType: bodyPart.mimeType
        )
    }
    
    /// Append the file at`fileURL` and form data
    /// - Parameters:
    ///   - url: The file URL
    ///   - bodyPart: The `MultipartFormData`
    func append(fileURL url: URL, bodyPart: MultipartFormData) {
        if let fileName = bodyPart.fileName, let mimeType = bodyPart.mimeType {
            append(url,
                   withName: bodyPart.name,
                   fileName: fileName,
                   mimeType: mimeType)
        } else {
            append(url, withName: bodyPart.name)
        }
    }
    
    /// Append the data provided by `stream`
    /// - Parameters:
    ///   - stream: The input stream of data
    ///   - length: the length of data
    ///   - bodyPart: The `MultipartFormData`
    func append(stream: InputStream, length: UInt64, bodyPart: MultipartFormData) {
        append(
            stream,
            withLength: length,
            name: bodyPart.name,
            fileName: bodyPart.fileName ?? "",
            mimeType: bodyPart.mimeType ?? ""
        )
    }
    
    /// Create the body of the form data using provided `MultipartFormData` instances
    ///
    /// The body data will be appended based on the provider type (`MultipartFormData.provider`) of the form data
    /// 
    /// - Parameter multipartBody: Array of `MultipartFormData`
    func applyMoyaMultipartFormData(_ multipartBody: [MultipartFormData]) {
        for bodyPart in multipartBody {
            switch bodyPart.provider {
            case .data(let data):
                append(data: data, bodyPart: bodyPart)
            case .file(let url):
                append(fileURL: url, bodyPart: bodyPart)
            case .stream(let stream, let length):
                append(stream: stream, length: length, bodyPart: bodyPart)
            }
        }
    }
}
