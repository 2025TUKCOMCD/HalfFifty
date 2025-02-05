package HalfFifty.HalfFifty_BE.user.domain.DTO;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
public class ResponseUserGetDTO {
    UUID userId;
    String nickname;
    String phoneNumber;
    String username;
    LocalDateTime createdAt;
}
