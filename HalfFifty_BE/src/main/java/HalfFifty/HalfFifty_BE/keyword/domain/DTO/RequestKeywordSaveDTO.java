package HalfFifty.HalfFifty_BE.keyword.domain.DTO;

import lombok.Data;

import java.util.UUID;

@Data
public class RequestKeywordSaveDTO {
    UUID userId;
    String keyword;
}
