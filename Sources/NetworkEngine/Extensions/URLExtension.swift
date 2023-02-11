import Foundation

public extension URL {
    
    init<T: TargetType>(target: T) {
        let targetPath = target.path
        self = targetPath.isEmpty ? target.baseURL : target.baseURL.appendingPathComponent(targetPath)
    }
}
