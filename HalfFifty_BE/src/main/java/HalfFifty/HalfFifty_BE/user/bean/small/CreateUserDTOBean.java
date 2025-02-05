package HalfFifty.HalfFifty_BE.user.bean.small;

import HalfFifty.HalfFifty_BE.user.domain.DTO.ResponseUserGetDTO;
import HalfFifty.HalfFifty_BE.user.domain.UserDAO;
import org.springframework.stereotype.Component;

@Component
public class CreateUserDTOBean {
    // 객체를 DTO로 변환해서 반환
    public ResponseUserGetDTO exec(UserDAO userDAO) {
        return ResponseUserGetDTO.builder()
                .userId(userDAO.getUserId())
                .nickname(userDAO.getNickName())
                .phoneNumber(userDAO.getPhoneNumber())
                .username(userDAO.getUsername())
                .createdAt(userDAO.getCreatedAt())
                .build();
    }
}
