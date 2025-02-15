package HalfFifty.HalfFifty_BE.FAQ.domain.DTO;

import lombok.Data;

import java.util.UUID;

@Data
public class RequestAqAdminUpdateDTO {
    UUID AqId;
    String answer;
}
