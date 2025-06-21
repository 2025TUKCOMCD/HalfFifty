package HalfFifty.HalfFifty_BE.user.domain.DTO;

import lombok.Data;

@Data
public class RequestUserLoginDTO {
    String appleId;
    String password;
}
