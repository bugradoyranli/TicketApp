import SwiftUI
import Combine
class AuthViewModel: ObservableObject {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("authToken") var authToken: String = ""
    
    @Published var email = ""
    @Published var password = ""
    @Published var name = ""
    @Published var surname = ""
    @Published var isLoading = false
    @Published var isRegistered = false
    @Published var alertMessage: String?
    
    @Published var errorMessage: String?
    
    
    @MainActor // UI güncellemelerinin ana thread'de olmasını garanti eder
    func login() {
        isLoading = true
        errorMessage = nil
        
        let bodyData = ["email": email, "password": password]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: bodyData) else { return }
        
        // Task ile asenkron süreci başlatıyoruz
        Task {
            do {
                // Try await ile tek satırda sonucu alıyoruz
                let response: LoginResponse = try await NetworkManager.shared.request(endpoint: "/User/login", method: "POST", body: jsonData)
                self.authToken = response.token   // @AppStorage("authToken") otomatik UserDefaults'a yazar
                print("Güvenlik Anahtarı: \(response.token)")
                
                // Bilgileri kaydetme (Profil sayfasında göstermek için)
                UserDefaults.standard.set(response.user.id, forKey: "userId")
                UserDefaults.standard.set(response.user.name, forKey: "userName")
                UserDefaults.standard.set(response.user.email, forKey: "userEmail")
                self.isLoggedIn = true
                self.isLoading = false
                
            } catch let error as NetworkError {
                // Backend'den gelen özel hata mesajını (ProcessException) burada yakalıyoruz
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            } catch {
                self.errorMessage = "Beklenmedik bir hata oluştu."
                self.isLoading = false
            }
        }
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func register() {
        isLoading = true
        errorMessage = nil
        isRegistered = false // Resetle
        if !isValidEmail(email) {
            self.errorMessage = "Lütfen geçerli bir e-posta adresi giriniz."
        }
            
            let bodyData = [
                "email": email,
                "passwordHash": password,
                "name": name,
                "surname": surname
            ]
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: bodyData) else { return }
            
            Task {
                do {
                    // Not: Register genelde loginResponse dönmeyebilir,
                    // backend'in ne döndüğüne bağlı olarak modelini ayarla.
                    // Eğer sadece mesaj dönüyorsa generic bir model kullanabilirsin.
                    let _ : [String: String] = try await NetworkManager.shared.request(endpoint: "/User/register", method: "POST", body: jsonData)
                    
                    self.isLoading = false
                    self.alertMessage = "Hesabınız başarıyla oluşturuldu! Şimdi giriş yapabilirsiniz."
                    self.isRegistered = true // Bu true olduğunda View'da yönlendirme yapacağız
                    
                } catch let error as NetworkError {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                } catch {
                    self.errorMessage = "Kayıt sırasında bir hata oluştu."
                    self.isLoading = false
                }
            }
        
    }
}
