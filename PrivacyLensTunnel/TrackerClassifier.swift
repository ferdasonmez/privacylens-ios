import Foundation

struct TrackerClassifier {
    static let knownTrackers: [String: String] = [
        "graph.facebook.com": "Meta/Facebook Graph — advertising ID, device info, app activity",
        "z-m-gateway.facebook.com": "Meta/Facebook Graph — advertising ID, device info, app activity",
        "images.taboola.com": "Taboola — advertising ID, browsing behaviour"
    ]

    static func classify(domain: String) -> String? {
        return knownTrackers[domain]
    }
}
