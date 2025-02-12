package HalfFifty.HalfFifty_BE.translation.bean.small;

import HalfFifty.HalfFifty_BE.translation.domain.TranslationDAO;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.UUID;

@Component
public class CreateTranslationDAOBean {

    // 번역 기록 객체 생성
    public TranslationDAO exec(UUID userId, String translationWord) {
        return TranslationDAO.builder()
                .userId(userId)
                .translationWord(translationWord)
                .createdAt(LocalDateTime.now())
                .build();
    }
}
