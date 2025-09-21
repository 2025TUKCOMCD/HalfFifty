package HalfFifty.HalfFifty_BE.translation.domain.DTO;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class TranslationStatusResponse {
    private String status;
    private String message;
    private ResponseTranslationGetDTO data;
}