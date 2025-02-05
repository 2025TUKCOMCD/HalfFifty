//
//  SettingView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 2/6/25.
//

import SwiftUI

struct SettingView: View {
    @State private var isOn = false
    
    var body: some View {
        VStack {
            HStack {
                Toggle("푸시 알림", isOn: $isOn)
                    .toggleStyle(SwitchToggleStyle(tint: Color(red: 0.2549019607843137, green: 0.4117647058823529, blue: 0.8823529411764706)))
            }
            .padding(.vertical)
            
            NavigationLink(destination: Text("글자 크기 설정")) {
                HStack(alignment: .center) {
                    Text("글자 크기 설정")
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    Text("보통")
                        .foregroundColor(Color(red: 0.2549019607843137, green: 0.4117647058823529, blue: 0.8823529411764706))
                        .font(.system(size: 14))
                }
            }
            .padding(.vertical)
            
            NavigationLink(destination: Text("글자 크기 설정")) {
                HStack {
                    Text("FAQ")
                        .foregroundStyle(.black)
                    Spacer()
                }
            }
            .padding(.vertical)
            
            NavigationLink(destination: Text("글자 크기 설정")) {
                HStack {
                    Text("고객센터")
                        .foregroundStyle(.black)
                    Spacer()
                }
            }
            .padding(.vertical)
            
            Spacer()
        }
        .padding(.horizontal, 28)
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        SettingView()
    }
}
