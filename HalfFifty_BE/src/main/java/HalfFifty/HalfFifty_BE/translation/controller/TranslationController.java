package HalfFifty.HalfFifty_BE.translation.controller;

import HalfFifty.HalfFifty_BE.translation.domain.DTO.RequestSignLanguageDTO;
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
    private final TranslationService translationService;

    public TranslationController(TranslationService translationService) {
        this.translationService = translationService;
    }

    // 수화 번역 API
    @PostMapping
    public ResponseEntity<Map<String, Object>> translateSignLanguage(@RequestBody RequestSignLanguageDTO requestSignLanguageDTO) {
        // Lambda를 통해 번역된 데이터 가져오기
        ResponseTranslationGetDTO responseTranslationGetDTO = translationService.signLanguageTranslation(requestSignLanguageDTO);

        // 번역 성공 여부 확인
        boolean success = responseTranslationGetDTO != null;

        // 응답 데이터 구성
        Map<String, Object> responseMap = new HashMap<>();
        responseMap.put("success", success);
        responseMap.put("message", success ? "수화 번역 성공" : "수화 번역 실패");
        responseMap.put("translationId", success ? responseTranslationGetDTO.getTranslationId() : null);

        return ResponseEntity.status(HttpStatus.OK).body(responseMap);
    }
}
