//package HalfFifty.HalfFifty_BE.translation.bean;
//
//import com.fasterxml.jackson.databind.ObjectMapper;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.beans.factory.annotation.Value;
//import org.springframework.stereotype.Component;
//import software.amazon.awssdk.core.SdkBytes;
//import software.amazon.awssdk.services.lambda.LambdaClient;
//import software.amazon.awssdk.services.lambda.model.InvokeRequest;
//import software.amazon.awssdk.services.lambda.model.InvokeResponse;
//
//import java.nio.charset.StandardCharsets;
//
//@Component
//public class LambdaInvokerBean {
//    private final LambdaClient lambdaClient;
//    private final ObjectMapper objectMapper;
//
//    @Value("${aws.lambda.functionName}") // Lambda 함수명 가져오기
//    private String functionName;
//
//    @Autowired
//    public LambdaInvokerBean(LambdaClient lambdaClient, ObjectMapper objectMapper) {
//        this.lambdaClient = lambdaClient; // Spring에서 주입받음
//        this.objectMapper = objectMapper;
//    }
//
//    public String invokeLambda(Object payload) {
//        try {
//            // JSON 변환
//            String jsonPayload = objectMapper.writeValueAsString(payload);
//
//            // `SdkBytes`로 변환
//            SdkBytes sdkBytesPayload = SdkBytes.fromByteArray(jsonPayload.getBytes(StandardCharsets.UTF_8));
//
//            // Lambda 호출 요청 생성
//            InvokeRequest invokeRequest = InvokeRequest.builder()
//                    .functionName(functionName) // Lambda 함수명
//                    .payload(sdkBytesPayload)
//                    .build();
//
//            // Lambda 호출 실행
//            InvokeResponse response = lambdaClient.invoke(invokeRequest);
//
//            // Lambda 응답을 문자열로 변환
//            return response.payload().asUtf8String();
//        } catch (Exception e) {
//            throw new RuntimeException("Error invoking AWS Lambda: " + e.getMessage(), e);
//        }
//    }
//}