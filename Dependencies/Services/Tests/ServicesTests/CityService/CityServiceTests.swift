import XCTest
import Core
@testable import Services

final class CityServiceTests: XCTestCase {
    func test_fetchCitiesRequest_shouldReturnDefinedSpects() throws {
        let sut = Services.CityService(networkService: MockNetworkService())
        
        XCTAssertEqual(sut.fetchCitiesRequest.method, .get)
        XCTAssertEqual(sut.fetchCitiesRequest.baseURL, "https://gist.githubusercontent.com")
        XCTAssertEqual(
            sut.fetchCitiesRequest.path,
            "/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json"
        )
        XCTAssertTrue(sut.fetchCitiesRequest.headers?.isEmpty == true)
        XCTAssertTrue(sut.fetchCitiesRequest.parameters?.isEmpty == true)
    }
}

struct MockNetworkService: Core.Networking.NetworkServicing {
    func fetch<T>(request: any Core.Networking.HTTPRequestable) async throws -> T where T : Decodable {
        return try JSONDecoder().decode(T.self, from: "".data(using: .utf8)!)
    }
}
