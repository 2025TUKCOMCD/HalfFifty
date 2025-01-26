package HalfFifty.HalfFifty_BE.keyword.bean.small;

import HalfFifty.HalfFifty_BE.keyword.domain.KeywordDAO;
import HalfFifty.HalfFifty_BE.keyword.repository.KeywordRepositoryJPA;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.UUID;

@Component
public class GetKeywordsDAOBean {
    KeywordRepositoryJPA keywordRepositoryJPA;

    @Autowired
    public GetKeywordsDAOBean(KeywordRepositoryJPA keywordRepositoryJPA) {
        this.keywordRepositoryJPA = keywordRepositoryJPA;
    }

    // 유저 id를 통해 전체 키워드 조회
    public List<KeywordDAO> exec(UUID userId) {
        return keywordRepositoryJPA.findAllByUserId(userId);
    }
}
