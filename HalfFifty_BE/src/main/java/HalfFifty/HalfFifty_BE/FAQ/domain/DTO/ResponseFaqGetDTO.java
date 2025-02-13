package HalfFifty.HalfFifty_BE.FAQ.domain.DTO;

import lombok.Builder;
import lombok.Data;

import java.util.UUID;

@Data
@Builder
public class ResponseFaqGetDTO {
    UUID faqId;
    String question;
    String answer;
}
