package HalfFifty.HalfFifty_BE.translation.controller;

import HalfFifty.HalfFifty_BE.translation.domain.DTO.RequestSignLanguageDTO;
import HalfFifty.HalfFifty_BE.translation.domain.DTO.RequestTranslationDeleteDTO;
import HalfFifty.HalfFifty_BE.translation.domain.DTO.ResponseTranslationGetDTO;
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
        // 번역된 데이터 가져오기
        ResponseTranslationGetDTO responseTranslationGetDTO = translationService.signLanguageTranslation(requestSignLanguageDTO);

        // 번역 성공 여부 확인
        boolean success = responseTranslationGetDTO != null;

        // 응답 데이터 구성
        Map<String, Object> responseMap = new HashMap<>();
        responseMap.put("success", success);
        responseMap.put("message", success ? "수화 번역 성공" : "수화 번역 실패");
        responseMap.put("translationId", success ? responseTranslationGetDTO.getTranslationId() : null);
        responseMap.put("translatedWord", success ? responseTranslationGetDTO.getTranslationWord() : null);
        responseMap.put("probability", success ? responseTranslationGetDTO.getProbability() : null);

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
