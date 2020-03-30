import UIKit

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

extension SearchResult {
    
    var titleText: NSAttributedString {
        NSAttributedString(string: text, attributes: [.font : UIFont.boldSystemFont(ofSize: 16), .foregroundColor : UIColor.black])
    }
    
    var meaningsText: NSAttributedString {
        let meaningsText = NSMutableAttributedString()
        meanings.forEach { meaning in
            let text = NSMutableAttributedString()
            text.append(NSAttributedString(string: meaning.translationText, attributes: [.font : UIFont.italicSystemFont(ofSize: 14), .foregroundColor: UIColor.black]))
            text.append(NSAttributedString(string: " [\(meaning.transcription)]", attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.black]))
            if meaning != meanings.last {
                text.append(NSAttributedString(string: ", ", attributes: [.font : UIFont.italicSystemFont(ofSize: 14), .foregroundColor: UIColor.black]))
            }
            meaningsText.append(text)
        }
        return meaningsText
    }
}

extension SearchResult: Equatable {
    
    static func ==(lhs: SearchResult, rhs: SearchResult) -> Bool {
        lhs.id == rhs.id && lhs.text == rhs.text && lhs.meanings == rhs.meanings
    }
    
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
