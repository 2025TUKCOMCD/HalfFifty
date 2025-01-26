package HalfFifty.HalfFifty_BE.keyword.controller;

import HalfFifty.HalfFifty_BE.keyword.domain.DTO.RequestKeyWordUpdateDTO;
import HalfFifty.HalfFifty_BE.keyword.domain.DTO.RequestKeywordDeleteDTO;
import HalfFifty.HalfFifty_BE.keyword.domain.DTO.RequestKeywordSaveDTO;
import HalfFifty.HalfFifty_BE.keyword.domain.DTO.ResponseKeywordGetDTO;
import HalfFifty.HalfFifty_BE.keyword.service.KeywordService;
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
@RequestMapping("/keyword")
public class KeywordController {
    KeywordService keywordService;

    @Autowired
    public KeywordController(KeywordService keywordService) {
        this.keywordService = keywordService;
    }

    // 키워드 전체조회 API
    @GetMapping("/user/{userId}")
    public ResponseEntity<Map<String, Object>> getKeywordAll(@PathVariable("userId") UUID userId) {
        // 키워드 조회 service
        List<ResponseKeywordGetDTO> responseKeywordGetDTOS = keywordService.getKeywordAll(userId);

        // 키워드 조회 여부
        boolean success = responseKeywordGetDTOS != null;

        // Map을 통해 메시지와 list 값 json 데이터로 변환
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("success", success);
        requestMap.put("message", success ? "키워드 조회 성공" : "키워드 조회 실패");
        requestMap.put("keywordList", responseKeywordGetDTOS);

        // status, body 설정해서 응답 리턴
        return ResponseEntity.status(HttpStatus.OK).body(requestMap);
    }

    // 키워드 등록 API
    @PostMapping
    public ResponseEntity<Map<String, Object>> saveKeyword(@RequestBody RequestKeywordSaveDTO requestKeywordSaveDTO) {
        // 키워드 등록 service
        UUID keywordId = keywordService.saveKeyword(requestKeywordSaveDTO);

        // 키워드 생성 여부
        boolean success = keywordId != null;

        // Map을 통해 메시지와 id 값 json 데이터로 변환
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("success", success);
        requestMap.put("message", success ? "키워드 등록 성공" : "키워드 생성 시 DAO 저장 실패");
        requestMap.put("keywordId", keywordId);

        // status, body 설정해서 응답 리턴
        return ResponseEntity.status(HttpStatus.OK).body(requestMap);
    }

    // 키워드 수정 API
    @PutMapping
    public ResponseEntity<Map<String, Object>> updateKeyword(@RequestBody RequestKeyWordUpdateDTO requestKeyWordUpdateDTO) {
        // 키워드 수정 service
        UUID keywordId = keywordService.updateKeyword(requestKeyWordUpdateDTO);

        // 키워드 수정 여부
        boolean success = keywordId != null;

        // Map을 통해 메시지와 id 값 json 데이터로 변환
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("success", success);
        requestMap.put("message", success ? "키워드 수정 성공" : "키워드 수정 시 DAO 저장 실패");
        requestMap.put("keywordId", keywordId);

        // status, body 설정해서 응답 리턴
        return ResponseEntity.status(HttpStatus.OK).body(requestMap);
    }

    // 키워드 삭제 API
    @DeleteMapping
    public ResponseEntity<Map<String, Object>> deleteKeyword(@RequestBody RequestKeywordDeleteDTO requestKeywordDeleteDTO) {
        // 키워드 삭제 service
        Boolean success = keywordService.deleteKeyword(requestKeywordDeleteDTO);

        // Map을 통해 메시지 값 json 데이터로 변환
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("success", success);
        requestMap.put("message", success ? "키워드 삭제 성공" : "키워드 삭제 실패");

        // status, body 설정해서 응답 리턴
        return ResponseEntity.status(HttpStatus.OK).body(requestMap);
    }
}
