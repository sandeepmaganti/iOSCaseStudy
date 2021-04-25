import Foundation

struct Products: Codable {

    let products: [Product]?

    enum CodingKeys: String, CodingKey {

        case products = "products"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        products = try values.decodeIfPresent([Product].self, forKey: .products)
    }
}

struct Product: Codable {

    let id: Int?
    let title: String?
    let aisle: String?
    let description: String?
    let imageUrl: String?
    let regularPrice: RegularPrice?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case title = "title"
        case aisle = "aisle"
        case description = "description"
        case imageUrl = "image_url"
        case regularPrice = "regular_price"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        aisle = try values.decodeIfPresent(String.self, forKey: .aisle)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
        regularPrice = try values.decodeIfPresent(RegularPrice.self, forKey: .regularPrice)
    }
}

struct RegularPrice: Codable {
    let amountInCents: Int?
    let currencySymbol: String?
    let displayString: String?

    enum CodingKeys: String, CodingKey {

        case amountInCents = "amount_in_cents"
        case currencySymbol = "currency_symbol"
        case displayString = "display_string"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        amountInCents = try values.decodeIfPresent(Int.self, forKey: .amountInCents)
        currencySymbol = try values.decodeIfPresent(String.self, forKey: .currencySymbol)
        displayString = try values.decodeIfPresent(String.self, forKey: .displayString)
    }
}
