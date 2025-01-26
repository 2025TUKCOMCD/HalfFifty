package HalfFifty.HalfFifty_BE.keyword.domain.DTO;

import lombok.Data;

import java.util.UUID;

@Data
public class RequestKeywordDeleteDTO {
    UUID keywordId;
    UUID userId;
}
