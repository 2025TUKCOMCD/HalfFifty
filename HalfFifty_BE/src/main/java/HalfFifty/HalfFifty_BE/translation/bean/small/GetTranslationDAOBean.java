package HalfFifty.HalfFifty_BE.translation.bean.small;

import HalfFifty.HalfFifty_BE.translation.domain.TranslationDAO;
import HalfFifty.HalfFifty_BE.translation.repository.TranslationRepositoryJPA;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.UUID;

@Component
public class GetTranslationDAOBean {
    TranslationRepositoryJPA translationRepositoryJPA;

    @Autowired
    public GetTranslationDAOBean(TranslationRepositoryJPA translationRepositoryJPA) {
        this.translationRepositoryJPA = translationRepositoryJPA;
    }

    // translationId와 userId를 통해 원하는 객체 찾음
    public TranslationDAO exec(UUID translationId, UUID userId) {
        return translationRepositoryJPA.findByTranslationIdAndUserId(translationId, userId);
    }
}
