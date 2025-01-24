package HalfFifty.HalfFifty_BE.keyword.bean.small;

import HalfFifty.HalfFifty_BE.keyword.domain.DTO.RequestKeyWordUpdateDTO;
import HalfFifty.HalfFifty_BE.keyword.domain.KeywordDAO;
import HalfFifty.HalfFifty_BE.keyword.repository.KeywordRepositoryJPA;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.UUID;

@Component
public class GetKeywordDAOBean {
    KeywordRepositoryJPA keywordRepositoryJPA;

    @Autowired
    public GetKeywordDAOBean(KeywordRepositoryJPA keywordRepositoryJPA) {
        this.keywordRepositoryJPA = keywordRepositoryJPA;
    }

    // 키워드 id와 유저 id를 통해 원하는 객체 찾기
    public KeywordDAO exec(UUID userId, UUID keywordId) {
        return keywordRepositoryJPA.findByUserIdAndKeywordId(userId, keywordId);
    }
}
