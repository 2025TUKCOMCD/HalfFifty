# Java 17 JDK 이미지를 사용
FROM openjdk:17-jdk-slim

# 애플리케이션 JAR 파일 복사
ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} app.jar

# 컨테이너 실행 명령
ENTRYPOINT ["java", "-jar", "/app.jar"]

# 컨테이너가 사용할 포트
EXPOSE 8081
