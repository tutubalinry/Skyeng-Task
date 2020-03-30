import XCTest

final class SearchResultTests: XCTestCase {
    
    private let invalidData1 = Data("{\"id\":1129,\"text\":\"horse\"}".utf8)
    
    private let invalidData2 = Data("{\"id\":1129,\"meanings\":[]}".utf8)
    
    private let invalidData3 = Data("{\"text\":\"horse\",\"meanings\":[]}".utf8)
    
    private let validData = Data("{\"id\":1129,\"text\":\"horse\",\"meanings\":[]}".utf8)
    
    func testInvalidData_first() throws {
        XCTAssertThrowsError(try JSONDecoder().decode(SearchResult.self, from: invalidData1)) { error in
            if case .keyNotFound(let key, _) = error as? DecodingError {
                XCTAssertEqual("meanings", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }
    
    func testInvalidData_second() throws {
        XCTAssertThrowsError(try JSONDecoder().decode(SearchResult.self, from: invalidData2)) { error in
            if case .keyNotFound(let key, _) = error as? DecodingError {
                XCTAssertEqual("text", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }
    
    func testInvalidData_third() throws {
        XCTAssertThrowsError(try JSONDecoder().decode(SearchResult.self, from: invalidData3)) { error in
            if case .keyNotFound(let key, _) = error as? DecodingError {
                XCTAssertEqual("id", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }
    
    func testValidData() throws {
        let result = SearchResult(id: 1129, text: "horse", meanings: [])
        
        let testResult = try JSONDecoder().decode(SearchResult.self, from: validData)
        
        XCTAssertEqual(result, testResult)
    }

}
