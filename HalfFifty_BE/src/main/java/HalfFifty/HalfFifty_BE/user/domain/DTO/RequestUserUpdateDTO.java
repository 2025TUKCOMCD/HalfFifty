package HalfFifty.HalfFifty_BE.user.domain.DTO;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
public class RequestUserUpdateDTO {
    UUID userId;
    String nickname;
    LocalDateTime updatedAt;
}
