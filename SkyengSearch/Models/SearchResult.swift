import Foundation

/**
- example:
    ```
    {
      "id": 1129,
      "text": "horse",
      "meanings": [
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
        },
        {
          "id": 124411,
          "partOfSpeechCode": "n",
          "translation": {
            "text": "гимнастический конь",
            "note": null
          },
          "previewUrl": "//static.skyeng.ru/image/download/project/dictionary/id/6012/width/96/height/72",
          "imageUrl": "//static.skyeng.ru/image/download/project/dictionary/id/6012/width/640/height/480",
          "transcription": "hɔːs",
          "soundUrl": "//d2fmfepycn0xw0.cloudfront.net?gender=male&accent=british&text=horse"
        },
        {
          "id": 124413,
          "partOfSpeechCode": "n",
          "translation": {
            "text": "станок",
            "note": null
          },
          "previewUrl": "//static.skyeng.ru/image/download/project/dictionary/id/6827/width/96/height/72",
          "imageUrl": "//static.skyeng.ru/image/download/project/dictionary/id/6827/width/640/height/480",
          "transcription": "hɔːs",
          "soundUrl": "//d2fmfepycn0xw0.cloudfront.net?gender=male&accent=british&text=horse"
        },
        {
          "id": 124414,
          "partOfSpeechCode": "n",
          "translation": {
            "text": "конь",
            "note": null
          },
          "previewUrl": "//static.skyeng.ru/image/download/project/dictionary/id/6143/width/96/height/72",
          "imageUrl": "//static.skyeng.ru/image/download/project/dictionary/id/6143/width/640/height/480",
          "transcription": "hɔːs",
          "soundUrl": "//d2fmfepycn0xw0.cloudfront.net?gender=male&accent=british&text=horse"
        },
        {
          "id": 124415,
          "partOfSpeechCode": "v",
          "translation": {
            "text": "поставлять лошадей",
            "note": null
          },
          "previewUrl": "//static.skyeng.ru/image/download/project/dictionary/id/19863/width/96/height/72",
          "imageUrl": "//static.skyeng.ru/image/download/project/dictionary/id/19863/width/640/height/480",
          "transcription": "hɔːs",
          "soundUrl": "//d2fmfepycn0xw0.cloudfront.net?gender=male&accent=british&text=horse"
        }
      ]
    }
    ```
 */

struct SearchResult {
    let id: Int
    let text: String
    let meanings: [Meaning]
}

extension SearchResult: Decodable {
    
    enum CodingKeys: CodingKey {
        case id, text, meanings
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        text = try container.decode(String.self, forKey: .text)
        meanings = try container.decode([Meaning].self, forKey: .meanings)
    }
}
