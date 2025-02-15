package HalfFifty.HalfFifty_BE.FAQ.controller;

import HalfFifty.HalfFifty_BE.FAQ.domain.DTO.RequestAqAdminUpdateDTO;
import HalfFifty.HalfFifty_BE.FAQ.domain.DTO.RequestAqUserSaveDTO;
import HalfFifty.HalfFifty_BE.FAQ.service.AqService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@CrossOrigin("*")
@RequestMapping("/AQ")
public class AqController {
    AqService aqService;

    @Autowired
    public AqController(AqService aqService) {
        this.aqService = aqService;
    }

    @PostMapping
    public ResponseEntity<Map<String, Object>> saveUserAq(@RequestBody RequestAqUserSaveDTO requestAqUserSaveDTO) {
        // AQ 유저 등록 service
        UUID AqId = aqService.saveUserAq(requestAqUserSaveDTO);

        // AQ 유저 등록 성공 여부
        Boolean success = AqId != null;

        // Map을 통해 메시지와 list 값 json 데이터로 변환
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("success", success);
        requestMap.put("message", success ? "AQ 유저 등록 성공" : "AQ 유저 등록 실패");
        requestMap.put("AQId", AqId);

        // status, body 값 설정해서 응답 리턴
        return ResponseEntity.status(HttpStatus.OK).body(requestMap);
    }

    @PatchMapping
    public ResponseEntity<Map<String, Object>> updateAdminAq(@RequestBody RequestAqAdminUpdateDTO requestAqAdminUpdateDTO) {
        // AQ 어드민 답장 service
        UUID AqId = aqService.updateAdminAq(requestAqAdminUpdateDTO);

        // AQ 어드민 답장 성공 여부
        Boolean success = AqId != null;

        // Map을 통해 메시지와 list 값 json 데이터로 변환
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("success", success);
        requestMap.put("message", success ? "AQ 어드민 답장 성공" : "AQ 어드민 답장 실패");
        requestMap.put("AQId", AqId);

        // status, body 값 설정해서 응답 리턴
        return ResponseEntity.status(HttpStatus.OK).body(requestMap);
    }
}
