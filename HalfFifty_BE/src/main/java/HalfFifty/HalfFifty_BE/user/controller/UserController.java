package HalfFifty.HalfFifty_BE.user.controller;

import HalfFifty.HalfFifty_BE.user.domain.DTO.RequestUserSaveDTO;
import HalfFifty.HalfFifty_BE.user.domain.DTO.ResponseUserGetDTO;
import HalfFifty.HalfFifty_BE.user.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;


@RestController
@CrossOrigin("*")
@RequestMapping("/user")
public class UserController {
    UserService userService;

    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/{userId}")
    public ResponseEntity<Map<String, Object>> getUserProfile(@PathVariable("userId") UUID userId) {
        // 유저 프로필 조회 service
        ResponseUserGetDTO responseUserGetDTO = userService.getUserProfile(userId);

        // 유저 프로필 조회 성공 여부
        boolean success = responseUserGetDTO != null;

        // Map을 통해 메시지 id 값 json 데이터로 변환
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("success", success);
        requestMap.put("message", success ? "유저 프로필 조회 성공" : "유저 프로필 조회 실패");
        requestMap.put("userInfo", responseUserGetDTO);

        // status, body 설정해서 응답 리턴
        return ResponseEntity.status(HttpStatus.OK).body(requestMap);
    }

    @PostMapping
    public ResponseEntity<Map<String, Object>> saveUser(@RequestBody RequestUserSaveDTO requestUserSaveDTO) {
        // 유저 회원가입 service
        UUID userId = userService.exec(requestUserSaveDTO);

        // 유저 생성 여부
        boolean success = userId != null;

        // Map을 통해 메시지와 id 값 json 테이터로 변환
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("success", success);
        requestMap.put("message", success ? "유저 회원가입 성공" : "유저 회원가입 생성 시 DAO 저장 실패");
        requestMap.put("userId", userId);

        // status, body 설정해서 응답 리턴
        return ResponseEntity.status(HttpStatus.OK).body(requestMap);
    }
}
