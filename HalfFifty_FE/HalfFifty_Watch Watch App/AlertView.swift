//
//  SwiftUIView.swift
//  HalfFifty_Watch Watch App
//
//  Created by 임정윤 on 1/17/25.
//

import SwiftUI

struct AlertView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 4) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 32, height: 32)
                }
                .padding(.top, 30)

                Text("키워드 알림")
                    .font(.title3)
                    .foregroundColor(.primary)

                Text("[키워드]가 감지되었습니다\n확인해주세요")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.vertical, 10)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)

                Button(action: {
                    print("확인 버튼이 눌렸습니다")
                }) {
                    Text("확인")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .padding(.bottom, 40)
            }
            .frame(width: 200, height: 400)
            .cornerRadius(20)
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView()
    }
}
