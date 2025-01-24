package HalfFifty.HalfFifty_BE.keyword.bean.small;

import HalfFifty.HalfFifty_BE.keyword.domain.KeywordDAO;
import HalfFifty.HalfFifty_BE.keyword.repository.KeywordRepositoryJPA;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class SaveKeywordDAOBean {
    KeywordRepositoryJPA keywordRepositoryJPA;

    @Autowired
    public SaveKeywordDAOBean(KeywordRepositoryJPA keywordRepositoryJPA) {
        this.keywordRepositoryJPA = keywordRepositoryJPA;
    }

    // 키워드 저장
    public void exec(KeywordDAO keywordDAO) {
        keywordRepositoryJPA.save(keywordDAO);
    }
}
