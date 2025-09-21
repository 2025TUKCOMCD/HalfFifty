package HalfFifty.HalfFifty_BE.translation.domain.DTO;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class FrameBufferResult {
    private boolean confirmed;        // 확정 여부
    private String confirmedWord;     // 확정된 단어
    private int currentBufferSize;    // 현재 버퍼 크기
    private int requiredBufferSize;   // 필요한 버퍼 크기
}
