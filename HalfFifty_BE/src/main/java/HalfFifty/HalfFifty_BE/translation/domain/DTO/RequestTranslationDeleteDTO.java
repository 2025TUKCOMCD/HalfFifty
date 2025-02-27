package HalfFifty.HalfFifty_BE.translation.domain.DTO;

import lombok.Data;

import java.util.UUID;

@Data
public class RequestTranslationDeleteDTO {
    UUID translationId;
    UUID userId;
}
