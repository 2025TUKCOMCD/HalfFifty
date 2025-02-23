package HalfFifty.HalfFifty_BE.translation.domain.DTO;

import lombok.Data;

import java.util.List;
import java.util.UUID;

@Data
public class RequestSignLanguageDTO {
    private List<List<Double>> keypoints;  // 10 x 55 형태의 키포인트 데이터
    private UUID userId;  // 사용자 식별 ID
}
