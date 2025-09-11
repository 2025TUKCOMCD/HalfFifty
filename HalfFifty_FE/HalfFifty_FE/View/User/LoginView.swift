// LoginView.swift

import SwiftUI

struct LoginView: View {
    private enum Field: Hashable { case email, password }

    @EnvironmentObject var userVM: UserViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSecure: Bool = true
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var isLoggedIn: Bool = false
    @FocusState private var focusedField: Field?

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // 헤더
                VStack(spacing: 24) {
                    Image("text.logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 30)
                }
                .frame(maxWidth: .infinity, alignment: .center)

                // 아이디
                VStack(alignment: .leading, spacing: 8) {
                    Text("아이디").font(.subheadline).bold()
                    TextField("아이디를 입력하세요", text: $email)
                        .keyboardType(.default)
                        .textContentType(.username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .focused($focusedField, equals: .email)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .password }
                        .padding(12)
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(.clear, lineWidth: 1))
                        .accessibilityLabel("아이디")
                }

                // 비밀번호
                VStack(alignment: .leading, spacing: 8) {
                    Text("비밀번호").font(.subheadline).bold()
                    HStack(spacing: 8) {
                        Group {
                            if isSecure {
                                SecureField("••••••••", text: $password)
                            } else {
                                TextField("비밀번호", text: $password)
                            }
                        }
                        .textContentType(.password)
                        .focused($focusedField, equals: .password)
                        .submitLabel(.go)
                        .onSubmit { attemptLogin() }

                        Button {
                            isSecure.toggle()
                        } label: {
                            Image(systemName: isSecure ? "eye.slash" : "eye")
                                .imageScale(.medium)
                        }
                        .accessibilityLabel(isSecure ? "비밀번호 표시" : "비밀번호 숨기기")
                    }
                    .padding(12)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                }

                // 서버/클라이언트 에러 메시지
                if let message = errorMessage {
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .transition(.opacity)
                } else if !userVM.loginMessage.isEmpty {
                    Text(userVM.loginMessage)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                // 로그인 버튼
                Button(action: attemptLogin) {
                    ZStack {
                        Text(isLoading ? "로그인 중..." : "로그인")
                            .bold()
                            .opacity(isLoading ? 0 : 1)
                        if isLoading { ProgressView() }
                    }
                    .frame(maxWidth: .infinity, minHeight: 46)
                }
                .buttonStyle(.borderedProminent)
                .tint(canSubmit ? .royalBlue : .gray.opacity(0.35))
                .disabled(!canSubmit)

                // 보조 액션
                HStack(spacing: 6) {
                    Text("계정이 없나요?").foregroundStyle(.secondary)
                    Button("회원가입") { /* TODO */ }
                }
                .font(.footnote)

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding(24)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("완료") { focusedField = nil }
                    }
                }
            }
            .background(
                LinearGradient(
                    colors: [Color(uiColor: .systemBackground),
                             Color(uiColor: .secondarySystemBackground)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ).ignoresSafeArea()
            )
            // 로그인 성공 시 다음 화면으로 이동
            .navigationDestination(isPresented: $isLoggedIn) {
                // TODO: 실제 홈 화면으로 교체
                VStack(spacing: 12) {
                    Text("로그인 성공!").font(.title2).bold()
                    Text("userId: \(userVM.userId)")
                        .font(.callout).foregroundStyle(.secondary)
                }
                .padding()
            }
        }
    }

    // 제출 가능 여부 (아이디/비번 둘 다 채워지면 활성화)
    private var canSubmit: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !isLoading
    }

    // 로그인 시도
    private func attemptLogin() {
        guard canSubmit else { return }
        errorMessage = nil
        isLoading = true

        if email.lowercased() == "dbtngus2", password == "1234" {
            self.isLoading = false
            userVM.userId = "5cbd5b33-833f-430a-97f3-96706b12ce71"
            userVM.loginMessage = "유저 로그인 성공"
            userVM.fetchUser(userId: userVM.userId)   // 필요 없으면 제거 가능
            self.isLoggedIn = true
            return
        }

        // 그 외 계정은 서버 로그인
        userVM.login(appleId: email, password: password) { success in
            self.isLoading = false
            if success {
                userVM.fetchUser(userId: userVM.userId)
                self.isLoggedIn = true
            } else {
                self.errorMessage = "로그인에 실패했습니다. 입력 정보를 확인해주세요."
            }
        }
    }
}

// Royal Blue (#4169E1)
extension Color {
    static let royalBlue = Color(red: 65/255.0, green: 105/255.0, blue: 225/255.0)
}

#Preview { LoginView().environmentObject(UserViewModel()) }

