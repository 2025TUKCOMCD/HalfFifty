package HalfFifty.HalfFifty_BE.keyword.bean;

import HalfFifty.HalfFifty_BE.keyword.bean.small.CreateKeywordsDTOBean;
import HalfFifty.HalfFifty_BE.keyword.bean.small.GetKeywordsDAOBean;
import HalfFifty.HalfFifty_BE.keyword.domain.DTO.ResponseKeywordGetDTO;
import HalfFifty.HalfFifty_BE.keyword.domain.KeywordDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Component
public class GetKeywordsBean {
    GetKeywordsDAOBean getKeywordsDAOBean;
    CreateKeywordsDTOBean createKeywordsDTOBean;

    @Autowired
    public GetKeywordsBean(GetKeywordsDAOBean getKeywordsDAOBean, CreateKeywordsDTOBean createKeywordsDTOBean) {
        this.getKeywordsDAOBean = getKeywordsDAOBean;
        this.createKeywordsDTOBean = createKeywordsDTOBean;
    }

    public List<ResponseKeywordGetDTO> exec(UUID userId) {
        // 유저 id를 통해 유저가 작성한 keyword 객체들 조회
        List<KeywordDAO> keywordDAOS = getKeywordsDAOBean.exec(userId);
        if(keywordDAOS.isEmpty()) return  new ArrayList<>();

        // 찾은 keyword 객체들 DTO로 변환해서 반환
        return createKeywordsDTOBean.exec(keywordDAOS);
    }
}
