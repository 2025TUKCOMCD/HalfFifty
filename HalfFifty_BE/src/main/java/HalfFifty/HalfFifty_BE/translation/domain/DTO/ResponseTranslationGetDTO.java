package HalfFifty.HalfFifty_BE.translation.domain.DTO;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
public class ResponseTranslationGetDTO {
    UUID translationId;
    UUID userId;
    String translationWord;
    LocalDateTime createdAt;
}
