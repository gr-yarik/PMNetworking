import XCTest
@testable import PMNetworking

class PMNetworkingMock: Networking, Codable {
    var defaultHeadersCallCounter = 0
    var defaultHeaders: [String : String] {
        get {
            defaultHeadersCallCounter += 1
            return [:]
        }
    }
}

final class PMNetworkingTests: XCTestCase {
    
    let networking = PMNetworking()
    let url = URL(string: "https://www.google.com/")!
    var request = URLRequest(url: URL(string: "https://www.google.com/")!)
    
    override func tearDown() {
        request = URLRequest(url: URL(string: "https://www.google.com/")!)
    }
    
    
    func testResponceCodeHandling() {
        XCTAssertNil(networking.handleResponseCode(200, responseCodeHandler: nil))
    }
    
    
    func testHeadersAppendix() {
        let requestHeaders = ["bye" : "99"]
        let defaultHeaders = ["Hi":"128", "bye":"70"]
        
        request.addHeaders(defaultHeaders: defaultHeaders, requestHeaders: requestHeaders)
        
        let headers = request.allHTTPHeaderFields
        XCTAssert(headers!["bye"] == "99" && headers!["Hi"] == "128")
    }
    
    
    func testPrepareRequest() {
        let netwotkingMock = PMNetworkingMock()
        let resource = Resource(url: url, requestMethod: .GET, decodingType: PMNetworkingMock.self, customResponseCodeHandler: nil)
        let _ = resource.prepareRequest(forNetworking: netwotkingMock)
        XCTAssertEqual(netwotkingMock.defaultHeadersCallCounter, 1)
    }
}
