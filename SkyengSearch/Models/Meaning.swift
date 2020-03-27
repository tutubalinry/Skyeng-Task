import Foundation

/**
 - example:
    ```
    {
      "id": 124410,
      "partOfSpeechCode": "n",
      "translation": {
        "text": "лошадь",
        "note": null
      },
      "previewUrl": "//static.skyeng.ru/image/download/project/dictionary/id/217866/width/96/height/72",
      "imageUrl": "//static.skyeng.ru/image/download/project/dictionary/id/217866/width/640/height/480",
      "transcription": "hɔːs",
      "soundUrl": "//d2fmfepycn0xw0.cloudfront.net?gender=male&accent=british&text=h%C9%94%CB%90s&transcription=1"
    }
    ```
 */

struct Meaning {
    let id: Int
    let partOfSpeechCode: String
    let translationText: String
    let translationNote: String?
    let previewURL: URL?
    let imageURL: URL?
    let transcription: String
    let soundURL: URL?
}

extension Meaning: Equatable {
    
    static func ==(lhs: Meaning, rhs: Meaning) -> Bool {
        lhs.id == rhs.id
    }
    
}

extension Meaning: Decodable {
    
    enum CodingKeys: CodingKey {
        case id, partOfSpeechCode, translation, previewUrl, imageUrl, transcription, soundUrl
    }
    
    enum TranslationCodingKeys: CodingKey {
        case text, note
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let translationContainer = try container.nestedContainer(keyedBy: TranslationCodingKeys.self, forKey: .translation)
        
        id = try container.decode(Int.self, forKey: .id)
        partOfSpeechCode = try container.decode(String.self, forKey: .partOfSpeechCode)
        previewURL = try container.decode(URL?.self, forKey: .previewUrl)
        imageURL = try container.decode(URL?.self, forKey: .imageUrl)
        transcription = try container.decode(String.self, forKey: .transcription)
        soundURL = try container.decode(URL?.self, forKey: .soundUrl)
        translationText = try translationContainer.decode(String.self, forKey: .text)
        translationNote = try translationContainer.decode(String?.self, forKey: .note)
    }
}
