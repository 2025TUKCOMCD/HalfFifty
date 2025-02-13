package HalfFifty.HalfFifty_BE.FAQ.domain.DTO;

import lombok.Data;

@Data
public class RequestFaqSaveDTO {
    String question;
    String answer;
}
