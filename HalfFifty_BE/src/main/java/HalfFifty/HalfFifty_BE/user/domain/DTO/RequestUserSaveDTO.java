package HalfFifty.HalfFifty_BE.user.domain.DTO;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class RequestUserSaveDTO {
    String username;
    String appleId;
    String password;
    String nickName;
    String phoneNumber;
}
