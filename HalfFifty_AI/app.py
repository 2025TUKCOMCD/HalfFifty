from flask import Flask

# Flask 애플리케이션 생성
app = Flask(__name__)

# 기본 라우트 설정
@app.route('/')
def home():
    return "Flask is running!"

# 애플리케이션 실행
if __name__ == '__main__':
    app.run(debug=True, port=5001)
