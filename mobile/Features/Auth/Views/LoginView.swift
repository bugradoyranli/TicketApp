import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        NavigationStack { // <--- BURAYI EKLE
            VStack(spacing: 25) {
                Spacer()
                
                // Logo Alanı
                VStack(spacing: 15) {
                    Image(systemName: "ticket.fill")
                        .font(.system(size: 70))
                        .foregroundStyle(.purple)
                        .padding()
                        .background(.purple.opacity(0.1))
                        .clipShape(Circle())
                    
                    Text("TicketApp")
                        .font(.largeTitle.bold())
                }
                
                // Form Alanı
                VStack(spacing: 15) {
                    TextField("E-posta", text: $viewModel.email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .textInputAutocapitalization(.none)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)        // Email klavyesini açar (@ işareti kolaylaşır)
                    
                    SecureField("Şifre", text: $viewModel.password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                if let error = viewModel.errorMessage {
                    HStack {
                        Image(systemName: "exclamationmark.circle.fill") // Hata ikonu
                        Text(error)
                            .font(.subheadline)
                    }
                    .foregroundStyle(.red) // Hata rengi
                    .padding(.horizontal)
                    .transition(.move(edge: .top).combined(with: .opacity)) // Güzel bir animasyon
                }
                // Giriş Butonu
                Button(action: { viewModel.login() }) {
                    HStack {
                        if viewModel.isLoading { ProgressView().tint(.white) }
                        Text("Giriş Yap").bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.purple)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .disabled(viewModel.isLoading)
                
                NavigationLink(destination: RegisterView()) {
                    Text("Hesabın yok mu? **Hemen Kayıt Ol**")
                        .font(.footnote)
                        .foregroundStyle(.purple)
                        .frame(maxWidth: .infinity) // Genişliği yayar
                        .padding(.vertical, 10)     // Tıklama alanını dikeyde büyütür
                        .contentShape(Rectangle())
                }
                
                Spacer()
            }
        }
    }
}


#Preview {
    LoginView()
}
