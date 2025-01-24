package HalfFifty.HalfFifty_BE.user.bean.small;

import HalfFifty.HalfFifty_BE.user.domain.DTO.RequestUserSaveDTO;
import HalfFifty.HalfFifty_BE.user.domain.UserDAO;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.UUID;

@Component
public class CreateUserDAOBean {
    // 유저 객체 생성
    public UserDAO exec(RequestUserSaveDTO requestUserSaveDTO) {
        return UserDAO.builder()
                .userId(UUID.randomUUID())
                .appleId(requestUserSaveDTO.getAppleId())
                .password(requestUserSaveDTO.getPassword())
                .username(requestUserSaveDTO.getUsername())
                .nickName(requestUserSaveDTO.getNickName())
                .phoneNumber(requestUserSaveDTO.getPhoneNumber())
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();
    }
}
