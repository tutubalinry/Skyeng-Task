import XCTest

class MeaningTest: XCTestCase {
    
    private let invalidData1 = Data("{\"partOfSpeechCode\": \"n\",\"translation\": {\"text\":\"лошадь\",\"note\":\"null\"},\"previewUrl\":\"null\",\"imageUrl\":\"null\",\"transcription\":\"hɔːs\",\"soundUrl\":\"null\"}".utf8)
    
    private let invalidData2 = Data("{\"id\": 124410,\"partOfSpeechCode\": \"n\",\"previewUrl\":\"null\",\"imageUrl\":\"null\",\"transcription\":\"hɔːs\",\"soundUrl\":\"null\"}".utf8)
    
    private let invalidData3 = Data("{\"id\": 124410,\"partOfSpeechCode\": \"n\",\"translation\": {\"note\":\"null\"},\"previewUrl\":\"null\",\"imageUrl\":\"null\",\"transcription\":\"hɔːs\",\"soundUrl\":\"null\"}".utf8)

    private let validData1 = Data("{\"id\": 124410,\"partOfSpeechCode\": \"n\",\"translation\": {\"text\":\"лошадь\",\"note\":\"null\"},\"previewUrl\":\"null\",\"imageUrl\":\"null\",\"transcription\":\"hɔːs\",\"soundUrl\":\"null\"}".utf8)
    
    func testInvalidData1() throws {
        XCTAssertThrowsError(try JSONDecoder().decode(Meaning.self, from: invalidData1)) { error in
            if case .keyNotFound(let key, _) = error as? DecodingError {
                XCTAssertEqual("id", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }
    
    func testInvalidData2() throws {
        XCTAssertThrowsError(try JSONDecoder().decode(Meaning.self, from: invalidData2)) { error in
            if case .keyNotFound(let key, _) = error as? DecodingError {
                XCTAssertEqual("translation", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }
    
    func testInvalidData3() throws {
        XCTAssertThrowsError(try JSONDecoder().decode(Meaning.self, from: invalidData3)) { error in
            if case .keyNotFound(let key, _) = error as? DecodingError {
                XCTAssertEqual("text", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }
    
    func testValidData() throws {
        let meaning = Meaning(id: 124410, partOfSpeechCode: "n", translationText: "лошадь", translationNote: nil, transcription: "hɔːs", previewURL: nil, imageURL: nil, soundURL: nil)
        
        let testMeaning = try JSONDecoder().decode(Meaning.self, from: validData1)
        
        XCTAssertEqual(meaning, testMeaning)
    }

}
