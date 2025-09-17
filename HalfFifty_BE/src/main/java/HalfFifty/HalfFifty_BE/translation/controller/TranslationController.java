package HalfFifty.HalfFifty_BE.translation.controller;

import HalfFifty.HalfFifty_BE.translation.domain.DTO.RequestSignLanguageDTO;
import HalfFifty.HalfFifty_BE.translation.domain.DTO.RequestTranslationDeleteDTO;
import HalfFifty.HalfFifty_BE.translation.domain.DTO.ResponseTranslationGetDTO;
import HalfFifty.HalfFifty_BE.translation.domain.DTO.TranslationStatusResponse;
import HalfFifty.HalfFifty_BE.translation.service.TranslationService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/translation")
@CrossOrigin("*")
public class TranslationController {
    TranslationService translationService;

    public TranslationController(TranslationService translationService) {
        this.translationService = translationService;
    }

    // 수화 번역 API
    @PostMapping
    public ResponseEntity<Map<String, Object>> translateSignLanguage(@RequestBody RequestSignLanguageDTO requestSignLanguageDTO) {
        TranslationStatusResponse response = translationService.getTranslationStatus(requestSignLanguageDTO);

        Map<String, Object> responseMap = new HashMap<>();
        responseMap.put("success", "success".equals(response.getStatus()));
        responseMap.put("message", response.getMessage());
        responseMap.put("status", response.getStatus());
        responseMap.put("translationId", null);
        responseMap.put("translatedWord", null);
        responseMap.put("probability", null);

        if ("success".equals(response.getStatus()) && response.getData() != null) {
            ResponseTranslationGetDTO data = response.getData();
            responseMap.put("translationId", data.getTranslationId());
            responseMap.put("translatedWord", data.getTranslationWord());
            responseMap.put("probability", data.getProbability());
        }

        return ResponseEntity.status(HttpStatus.OK).body(responseMap);
    }

    @DeleteMapping
    public ResponseEntity<Map<String, Object>> deleteTranslation(@RequestBody RequestTranslationDeleteDTO requestTranslationDeleteDTO) {
        // 번역 기록 삭제 성공 여부
        boolean success = translationService.deleteTranslation(requestTranslationDeleteDTO);

        // Map을 통해 메시지 값 json 데이터로 변환
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("success", success);
        requestMap.put("message", success ? "번역 기록 삭제 성공" : "번역 기록 삭제 실패");

        // status, body 설정해서 응답 리턴
        return ResponseEntity.status(HttpStatus.OK).body(requestMap);

    }
}
