import Foundation

class EventLogger {
    static let shared = EventLogger()
    private let fileURL: URL

    private init() {
        let dir = FileManager.default.temporaryDirectory
        fileURL = dir.appendingPathComponent("dns_events.csv")
    }

    func log(domain: String, classification: String?) {
        let line = "\(Date().timeIntervalSince1970)|\(domain)|\(classification ?? "")\n"
        guard let data = line.data(using: .utf8) else { return }
        if FileManager.default.fileExists(atPath: fileURL.path) {
            if let handle = try? FileHandle(forWritingTo: fileURL) {
                handle.seekToEndOfFile()
                handle.write(data)
                handle.closeFile()
            }
        } else {
            try? data.write(to: fileURL)
        }
    }
}
