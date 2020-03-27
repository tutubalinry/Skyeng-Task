import Foundation

func parser<R: Decodable>(data: Data) throws -> R {
    let decoder = JSONDecoder()
    return try decoder.decode(R.self, from: data)
}
