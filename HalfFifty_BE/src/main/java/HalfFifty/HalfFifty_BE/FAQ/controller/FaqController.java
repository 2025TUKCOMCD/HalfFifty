package HalfFifty.HalfFifty_BE.FAQ.controller;

import HalfFifty.HalfFifty_BE.FAQ.domain.DTO.RequestFaqSaveDTO;
import HalfFifty.HalfFifty_BE.FAQ.domain.DTO.ResponseFaqGetDTO;
import HalfFifty.HalfFifty_BE.FAQ.service.FaqService;
import HalfFifty.HalfFifty_BE.keyword.domain.DTO.ResponseKeywordGetDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
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

    @GetMapping
    public ResponseEntity<Map<String, Object>> getFaqAll() {
        // Faq 전체조회 service
        List<ResponseFaqGetDTO> responseFaqGetDTOS = faqService.getFaqAll();

        // Faq 전체조회 여부
        boolean success = responseFaqGetDTOS != null;

        // Map을 통해 메시지와 list 값 json 데이터로 변환
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("success", success);
        requestMap.put("message", success ? "FAQ 전체조회 성공" : "FAQ 전체조회 실패");
        requestMap.put("FAQList", responseFaqGetDTOS);

        // status, body 설정해서 응답 리턴
        return ResponseEntity.status(HttpStatus.OK).body(requestMap);
    }

    @PostMapping
    public ResponseEntity<Map<String, Object>> saveFaq(@RequestBody RequestFaqSaveDTO requestFaqSaveDTO) {
        // Faq 저장 service
        UUID FAQId = faqService.saveFaq(requestFaqSaveDTO);

        // Faq 저장 여부
        boolean success = FAQId != null;

        // Map을 통해 메시지와 list 값 json 데이터로 변환
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("success", success);
        requestMap.put("message", success ? "FAQ 저장 성공" : "FAQ 저장 실패");
        requestMap.put("FAQId", FAQId);

        // status, body 설정해서 응답 리턴
        return ResponseEntity.status(HttpStatus.OK).body(requestMap);
    }
}
