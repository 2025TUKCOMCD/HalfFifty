package HalfFifty.HalfFifty_BE.FAQ.controller;

import HalfFifty.HalfFifty_BE.FAQ.domain.DTO.RequestFaqSaveDTO;
import HalfFifty.HalfFifty_BE.FAQ.service.FaqService;
import HalfFifty.HalfFifty_BE.keyword.domain.DTO.ResponseKeywordGetDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@CrossOrigin("*")
@RequestMapping("/FAQ")
public class FaqController {
    FaqService faqService;

    @Autowired
    public FaqController(FaqService faqService) {
        this.faqService = faqService;
    }

    @PostMapping
    public ResponseEntity<Map<String, Object>> saveFaq(@RequestBody RequestFaqSaveDTO requestFaqSaveDTO) {
        // Faq 저장 service
        UUID FaqId = faqService.saveFaq(requestFaqSaveDTO);

        // Faq 저장 여부
        boolean success = FaqId != null;

        // Map을 통해 메시지와 list 값 json 데이터로 변환
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("success", success);
        requestMap.put("message", success ? "FAQ 저장 성공" : "FAQ 저장 실패");
        requestMap.put("FAQId", FaqId);

        // status, body 설정해서 응답 리턴
        return ResponseEntity.status(HttpStatus.OK).body(requestMap);
    }
}
