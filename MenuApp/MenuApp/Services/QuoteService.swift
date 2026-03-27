import Foundation

struct ZenQuote: Codable {
    let q: String
    let a: String
}

class QuoteService {
    static func fetchRandomQuote(completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://zenquotes.io/api/random") else {
            completion(.failure(URLError(.badURL)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            do {
                let quotes = try JSONDecoder().decode([ZenQuote].self, from: data)
                if let quote = quotes.first {
                    completion(.success("\"\(quote.q)\" — \(quote.a)"))
                } else {
                    completion(.failure(URLError(.cannotParseResponse)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
