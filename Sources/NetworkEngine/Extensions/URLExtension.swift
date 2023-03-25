import Foundation

public extension URL {
    
    /// Create `URL` from `TargetType`
    /// - Parameter target: The `TargetType`
    init<T: TargetType>(target: T) {
        let targetPath = target.path
        self = targetPath.isEmpty ? target.baseURL : target.baseURL.appendingPathComponent(targetPath)
    }
}
