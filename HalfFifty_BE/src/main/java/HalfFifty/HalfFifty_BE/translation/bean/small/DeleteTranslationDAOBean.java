package HalfFifty.HalfFifty_BE.translation.bean.small;

import HalfFifty.HalfFifty_BE.translation.domain.TranslationDAO;
import HalfFifty.HalfFifty_BE.translation.repository.TranslationRepositoryJPA;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class DeleteTranslationDAOBean {
    TranslationRepositoryJPA translationRepositoryJPA;

    @Autowired
    public DeleteTranslationDAOBean(TranslationRepositoryJPA translationRepositoryJPA) {
        this.translationRepositoryJPA = translationRepositoryJPA;
    }

    // Translation 객체 삭제
    public void exec(TranslationDAO translationDAO) {
        translationRepositoryJPA.delete(translationDAO);
    }
}
