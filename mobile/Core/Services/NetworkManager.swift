import Foundation

// Profesyonel hata tanımlamaları
enum NetworkError: Error {
    case invalidURL
    case serverError(String)
    case decodingError
    case unknownError(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL: return "Geçersiz sunucu adresi."
        case .serverError(let message): return message
        case .decodingError: return "Veri işlenirken bir hata oluştu."
        case .unknownError(let error): return error.localizedDescription
        }
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    private let baseURL = "http://192.168.1.120:5200/api"
    
    // Artik async/await kullanıyoruz. Daha temiz, daha okunaklı.
    func request<T: Codable>(endpoint: String, method: String, body: Data? = nil) async throws -> T {
        
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Kayıtlı JWT varsa her isteğe ekle
        if let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        request.httpBody = body
        
        print("İstek atılıyor: \(url.absoluteString)")
        
        // URLSession artik async çalışabiliyor
        let (data, response) = try await URLSession.shared.data(for: request)
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Backend'den gelen veri: \(jsonString)")
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.serverError("Sunucu yanıt vermiyor.")
        }
        
        print("Status Code: \(httpResponse.statusCode)")

        // Token geçersiz/süresi dolmuşsa: oturumu temizle, kullanıcıyı giriş ekranına at.
        if httpResponse.statusCode == 401 {
            await MainActor.run {
                UserDefaults.standard.removeObject(forKey: "authToken")
                UserDefaults.standard.removeObject(forKey: "userId")
                UserDefaults.standard.set(false, forKey: "isLoggedIn")
            }
            throw NetworkError.serverError("Oturumunuz sona erdi. Lütfen tekrar giriş yapın.")
        }

        // 200-299 dışındaki her şeyi hata kabul ediyoruz
        guard (200...299).contains(httpResponse.statusCode) else {
            // Backend'den gelen hata mesajını oku (Senin istediğin string mesajı)
            let serverMessage = String(data: data, encoding: .utf8) ?? "Bilinmeyen bir hata oluştu."
            throw NetworkError.serverError(serverMessage)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Decoding hatası: \(error)")
            throw NetworkError.decodingError
        }
    }
}
