package HalfFifty.HalfFifty_BE.translation.bean.small;

import HalfFifty.HalfFifty_BE.translation.domain.TranslationDAO;
import HalfFifty.HalfFifty_BE.translation.repository.TranslationRepositoryJPA;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class SaveTranslationDAOBean {
    TranslationRepositoryJPA translationRepositoryJPA;

    @Autowired
    public SaveTranslationDAOBean(TranslationRepositoryJPA translationRepositoryJPA) {
        this.translationRepositoryJPA = translationRepositoryJPA;
    }

    // 번역 기록 저장
    public void exec(TranslationDAO translationDAO) {
        translationRepositoryJPA.save(translationDAO);
    }
}
