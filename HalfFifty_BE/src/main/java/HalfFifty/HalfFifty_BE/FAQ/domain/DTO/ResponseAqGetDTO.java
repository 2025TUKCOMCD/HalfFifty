package HalfFifty.HalfFifty_BE.FAQ.domain.DTO;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
public class ResponseAqGetDTO {
    UUID aqId;
    String question;
    String answer;
    Boolean isAnswer;
    LocalDateTime questionCreatedAt;
    LocalDateTime answerCreatedAt;
}
