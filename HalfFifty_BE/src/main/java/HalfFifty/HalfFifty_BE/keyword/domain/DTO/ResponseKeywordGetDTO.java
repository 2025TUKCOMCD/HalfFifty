package HalfFifty.HalfFifty_BE.keyword.domain.DTO;

import lombok.Builder;
import lombok.Data;

import java.util.UUID;

@Data
@Builder
public class ResponseKeywordGetDTO {
    UUID keywordId;
    String keyword;
}
