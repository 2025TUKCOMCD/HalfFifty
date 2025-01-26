package HalfFifty.HalfFifty_BE.keyword.bean.small;

import HalfFifty.HalfFifty_BE.keyword.domain.KeywordDAO;
import HalfFifty.HalfFifty_BE.keyword.repository.KeywordRepositoryJPA;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class DeleteKeywordDAOBean {
    KeywordRepositoryJPA keywordRepositoryJPA;

    @Autowired
    public DeleteKeywordDAOBean(KeywordRepositoryJPA keywordRepositoryJPA) {
        this.keywordRepositoryJPA = keywordRepositoryJPA;
    }

    // 키워드 삭제
    public void exec(KeywordDAO keywordDAO) {
        keywordRepositoryJPA.delete(keywordDAO);
    }
}
