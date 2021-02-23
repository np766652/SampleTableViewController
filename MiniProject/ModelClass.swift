

import Foundation

struct UserData: Codable {
    let totalPassengers, totalPages: Int?
    let data: [DataModel]?
}

struct DataModel: Codable {
    let id, name: String?
    let trips: Int?
    let airline: AirlineUnion?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, trips, airline
        case v = "__v"
    }
}

enum AirlineUnion: Codable {
    case airlineElement(AirlineElement)
    case airlineElementArray([AirlineElement])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([AirlineElement].self) {
            self = .airlineElementArray(x)
            return
        }
        if let x = try? container.decode(AirlineElement.self) {
            self = .airlineElement(x)
            return
        }
        throw DecodingError.typeMismatch(AirlineUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for AirlineUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .airlineElement(let x):
            try container.encode(x)
        case .airlineElementArray(let x):
            try container.encode(x)
        }
    }
}

struct AirlineElement: Codable {
    let airlineID: Int?
    let name, country: String?
    let logo: String?
    let slogan, headQuaters: String?
    let website: String?
    let established, id: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case airlineID = "id"
        case name, country, logo, slogan
        case headQuaters = "head_quaters"
        case website, established
        case id = "_id"
        case v = "__v"
    }
}
