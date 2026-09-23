import XCTest

final class TrackerClassifierTests: XCTestCase {
    func testKnownTrackerIsClassified() {
        XCTAssertEqual(
            TrackerClassifier.classify(domain: "graph.facebook.com"),
            "Meta/Facebook Graph — advertising ID, device info, app activity"
        )
        XCTAssertNotNil(TrackerClassifier.classify(domain: "images.taboola.com"))
    }

    func testUnknownDomainIsNotClassified() {
        XCTAssertNil(TrackerClassifier.classify(domain: "example.com"))
    }

    func testDomainExtractorStubReturnsNil() {
        XCTAssertNil(DomainExtractor.extractDomain(from: Data([0x45, 0x00])))
    }
}
