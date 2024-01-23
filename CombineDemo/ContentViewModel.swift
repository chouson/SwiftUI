//
//  ContentViewModel.swift
//  CombineDemo
//
//  Created by Chouson on 2024/1/22.
//

import Foundation
import Combine
import SwiftUI

class ContentViewModel: ObservableObject {
    var validNumber: AnyPublisher<Bool, Never> {
        phoneModel.$inputText
            .print("phone number is: ")
            .map {
                let result = $0.count == 11
                self.verifyModel.isEnable = result
                return result
            }
            .eraseToAnyPublisher()
    }
    
    var validCode: AnyPublisher<Bool, Never> {
        verifyModel.$inputText
            .print("code number is: ")
            .map {
                $0.count == 4
            }
            .eraseToAnyPublisher()
    }
        
    @Published var isAgree: Bool = false
    @Published var isPresent: Bool = false
    @Published var enableLogin: Bool = false
    
    var cancellables: Set<AnyCancellable> = []
    
    var phoneModel: TextFieldView.Model = .init(placeholder: "请输入手机号")
    var verifyModel: TextFieldView.Model = .init(placeholder: "请输入验证码", isEnable: false, isShowButton: true, buttonTitle: "发送验证码", isButtonTapped: false)
    
    let timerTool: CountdownTimerTool = .init(countdownTime: 5)
    
    init() {
        setup()
    }
}

extension ContentViewModel {
    func setup() {        
        verifyModel.$isButtonTapped
            // dropFirst() 忽略初始值。在isButtonTapped的值发生变化时，才会触发sink中的代码
            .dropFirst()
            .print("tap - ")
            .sink { _ in
                self.verifyModel.buttonTitle = "\(self.timerTool.originTime)s"
                self.requestCodeAction()
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest3(validNumber, validCode, $isAgree.eraseToAnyPublisher())
            .print("state is: ")
            .receive(on: RunLoop.main)
            .sink {
                self.enableLogin = ($0 && $1 && $2)
            }
            .store(in: &cancellables)
        
        timerTool.$countdownTime
            .dropFirst()
            .print("time ")
            .sink { _ in
                self.verifyModel.buttonTitle = "\(self.timerTool.countdownTime)s"
            }
            .store(in: &cancellables)
        
        timerTool.$isEnd
            .sink { result in
                if result {
                    self.verifyModel.buttonTitle = "发送验证码"
                }
            }
            .store(in: &cancellables)
    }
    
    func loginFunc() {
        isPresent.toggle()
    }
    
    private func requestCodeAction() {
        timerTool.start()
        requestCode()
    }
    
    private func requestCode() {
        
    }
}
