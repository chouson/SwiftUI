//
//  LoginView.swift
//  CombineDemo
//
//  Created by Chouson on 2024/1/22.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        ZStack {
//            Color.gray.ignoresSafeArea(.all)
            VStack {
                HeaderView()
                    .padding(.bottom, 100)
                TextFieldView(model: viewModel.phoneModel)
                    .padding(.bottom, 20)
                TextFieldView(model: viewModel.verifyModel)
                    .onTapGesture {
                        print("receive button tap")
                    }
                HStack {
                    // 空的 Text，作为 Toggle 的占位标签
                    Toggle("", isOn: $viewModel.isAgree)
                        .labelsHidden()
                    Text("同意本App的《用户协议》、《隐私政策》")
                        .font(.system(size: 12))
                    Spacer()
                }
                .padding(.top, 10)
                .padding(.bottom, 20)
                ZStack {
                    Color.blue
                        .opacity(viewModel.enableLogin ? 1 : 0.6)
                    Button("登录") {
                        viewModel.loginFunc()
                    }
                    .alert(isPresented: $viewModel.isPresent, content: {
                        Alert(title: Text("Hello"), message: Text("Login Success"), dismissButton: .default(Text("OK")))
                    })
                    .foregroundColor(.white)
                    .disabled(!viewModel.enableLogin)
                }
                .frame(width: 200, height: 50)
                .cornerRadius(25)
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    LoginView(viewModel: .init())
}

struct HeaderView: View {
    var body: some View {
        VStack {
            Image(systemName: "swift")
                .resizable()
                .foregroundColor(.blue)
                .frame(width: 50, height: 50)
                .padding(.bottom, 10)
            Text("用户登录")
                .foregroundColor(.black)
                .font(.system(size: 30, weight: .bold))
        }
    }
}

struct HeaderView_preview: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}

struct TextFieldView: View {
    
    class Model: ObservableObject {
        var placeholder: String
        @Published var inputText: String
        @Published var isEnable: Bool
        @Published var isShowButton: Bool
        @Published var buttonTitle: String
        @Published var isButtonTapped: Bool
        
        init(placeholder: String = "", inputText: String = "", isEnable: Bool = false, isShowButton: Bool = false, buttonTitle: String = "", isButtonTapped: Bool = false) {
            self.placeholder = placeholder
            self.inputText = inputText
            self.isEnable = isEnable
            self.isShowButton = isShowButton
            self.buttonTitle = buttonTitle
            self.isButtonTapped = isButtonTapped
        }
    }
    
    @StateObject var model: Model
        
    var body: some View {
        let height: CGFloat = 60
        ZStack {
            Color(red: 0, green: 0, blue: 0, opacity: 0.1)
            HStack {
                TextField(model.placeholder, text: $model.inputText)
                    .keyboardType(.numberPad)
                    .font(.system(size: 20))
                    .padding()
                Spacer()
                if model.isShowButton {
                    ZStack {
                        Color.blue
                            .opacity(model.isEnable ? 1 : 0.6)
                        Button(action: {
                            model.isButtonTapped.toggle()
                        }, label: {
                            Text(model.buttonTitle)
                        })
                        .disabled(!model.isEnable)
                        .foregroundColor(.white)
                        .padding(15)
                    }
                    .frame(height: height)
                    .frame(minWidth: 130)
                    .fixedSize()
                }
            }
        }
        .frame(height: height)
        .cornerRadius(height / 2)
    }
}

struct TextFieldView_preview: PreviewProvider {
    static var previews: some View {
        VStack {
            TextFieldView(model: .init(placeholder: "placeholder"))
            TextFieldView(model: .init(placeholder: "placeholder", isEnable: false, isShowButton: true, buttonTitle: "title"))
            TextFieldView(model: .init(placeholder: "placeholder", isEnable: true, isShowButton: true, buttonTitle: "title"))
        }
    }
}

