package HalfFifty.HalfFifty_BE.translation.domain.DTO;

public enum TranslationStatus {
    SUCCESS,        // 확정된 번역 결과
    PROCESSING,     // AI 성공했지만 버퍼링 중
    FAILED          // AI 실패 또는 오류
}
