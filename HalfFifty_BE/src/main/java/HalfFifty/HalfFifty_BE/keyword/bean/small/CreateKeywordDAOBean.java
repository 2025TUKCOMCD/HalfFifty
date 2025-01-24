package HalfFifty.HalfFifty_BE.keyword.bean.small;

import HalfFifty.HalfFifty_BE.keyword.domain.DTO.RequestKeywordSaveDTO;
import HalfFifty.HalfFifty_BE.keyword.domain.KeywordDAO;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
public class CreateKeywordDAOBean {

    // 키워드 객체 생성
    public KeywordDAO exec(RequestKeywordSaveDTO requestKeywordSaveDTO) {
        return KeywordDAO.builder()
                .userId(requestKeywordSaveDTO.getUserId())
                .keyword(requestKeywordSaveDTO.getKeyword())
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();
    }
}
