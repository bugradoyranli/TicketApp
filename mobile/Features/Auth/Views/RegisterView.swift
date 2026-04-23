import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = AuthViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Yeni Hesap Oluştur")
                .font(.title.bold())
            
            VStack(spacing: 15) {
                TextField("İsim", text: $viewModel.name)
                    .padding().background(Color(.systemGray6)).cornerRadius(12)
                TextField("Soyisim", text: $viewModel.surname)
                    .padding().background(Color(.systemGray6)).cornerRadius(12)
                
                
                TextField("Mail", text: $viewModel.email)
                    .padding().background(Color(.systemGray6)).cornerRadius(12)
                    .textInputAutocapitalization(.never)
                
                SecureField("Şifre", text: $viewModel.password)
                    .padding().background(Color(.systemGray6)).cornerRadius(12)
            }
            .padding(.horizontal)
            if let error = viewModel.errorMessage {
                HStack {
                    Image(systemName: "exclamationmark.circle.fill") // Hata ikonu
                    Text(error)
                        .font(.subheadline)
                }
                .foregroundStyle(.red)
                .padding(.horizontal)
                .transition(.move(edge: .top).combined(with: .opacity)) // Güzel bir animasyon
            }
            
            Button(action: {
                            viewModel.register()
                        }) {
                            if viewModel.isLoading {
                                ProgressView().tint(.white)
                            } else {
                                Text("Kayıt Ol").bold()
                            }
                        }
                        .disabled(viewModel.email.isEmpty || !viewModel.isValidEmail(viewModel.email))
                        .opacity(viewModel.isValidEmail(viewModel.email) ? 1.0 : 0.5)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.purple)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                       
                        .alert("Başarılı", isPresented: $viewModel.isRegistered) {
                            Button("Giriş Yap") {
                                dismiss()
                            }
                        } message: {
                            Text(viewModel.alertMessage ?? "İşlem başarıyla tamamlandı.")                        }
                        
                        Spacer()
        }
        .padding(.top, 50)
    }
}


#Preview {
    RegisterView()
}

