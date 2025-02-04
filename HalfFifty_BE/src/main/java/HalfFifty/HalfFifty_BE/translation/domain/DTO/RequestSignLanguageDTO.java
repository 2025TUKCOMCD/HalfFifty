package HalfFifty.HalfFifty_BE.translation.domain.DTO;

import lombok.Data;

import java.util.List;
import java.util.UUID;

@Data
public class RequestSignLanguageDTO {
    List<KeyPointPair> keyPointList;
    UUID userId;
    @Data
    public static class KeyPointPair {
        private int x;
        private int y;
    }
}
