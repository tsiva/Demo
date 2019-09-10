

//   let userImages = try? newJSONDecoder().decode(UserImages.self, from: jsonData)

import Foundation

// MARK: - UserImages
struct UserImages: Codable {
    let status: Bool
    let message: JSONNull?
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let users: [User]
    let hasMore: Bool
    
    enum CodingKeys: String, CodingKey {
        case users
        case hasMore = "has_more"
    }
}

// MARK: - User
struct User: Codable {
    let name: String
    let image: String
    let items: [String]
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
