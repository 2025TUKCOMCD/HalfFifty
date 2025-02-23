package HalfFifty.HalfFifty_BE.translation.bean;

import HalfFifty.HalfFifty_BE.translation.domain.DTO.RequestSignLanguageDTO;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

@Component
public class FlaskSignLanguageBean {
    private final RestTemplate restTemplate;

    @Value("${ai.server.url}")
    private String aiServerUrl;  // 환경변수로 관리

    public FlaskSignLanguageBean() {
        this.restTemplate = new RestTemplate();
    }

    // Flask AI 서버로 요청 보내기
    public Map<String, Object> exec(RequestSignLanguageDTO requestSignLanguageDTO) {
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("keypoints", requestSignLanguageDTO.getKeypoints());

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<Map<String, Object>> request = new HttpEntity<>(requestBody, headers);

        try {
            ResponseEntity<Map<String, Object>> response = restTemplate.exchange(
                    aiServerUrl,
                    HttpMethod.POST,
                    request,
                    new ParameterizedTypeReference<Map<String, Object>>() {}
            );

            if (response.getStatusCode() == HttpStatus.OK) {
                return response.getBody();
            } else {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("error", "AI 서버에서 오류 응답 발생");
                return errorResponse;
            }
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("error", e.getMessage());
            return errorResponse;
        }
    }
}

