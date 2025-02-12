package HalfFifty.HalfFifty_BE.translation.bean.small;

import HalfFifty.HalfFifty_BE.translation.domain.DTO.ResponseTranslationGetDTO;
import HalfFifty.HalfFifty_BE.translation.domain.TranslationDAO;
import org.springframework.stereotype.Component;

@Component
public class CreateTranslationDTOBean {

    // 수화 번역 객체를 DTO로 변환해서 반환
    public ResponseTranslationGetDTO exec(TranslationDAO translationDAO) {
        return ResponseTranslationGetDTO.builder()
                .translationId(translationDAO.getTranslationId())
                .userId(translationDAO.getUserId())
                .translationWord(translationDAO.getTranslationWord())
                .createdAt(translationDAO.getCreatedAt())
                .build();
    }
}
