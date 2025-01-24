package HalfFifty.HalfFifty_BE.keyword.bean;

import HalfFifty.HalfFifty_BE.keyword.bean.small.CreateKeywordDAOBean;
import HalfFifty.HalfFifty_BE.keyword.bean.small.SaveKeywordDAOBean;
import HalfFifty.HalfFifty_BE.keyword.domain.DTO.RequestKeywordSaveDTO;
import HalfFifty.HalfFifty_BE.keyword.domain.KeywordDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.UUID;

@Component
public class SaveKeywordBean {
    CreateKeywordDAOBean createKeywordDAOBean;
    SaveKeywordDAOBean saveKeywordDAOBean;

    @Autowired
    public SaveKeywordBean(CreateKeywordDAOBean createKeywordDAOBean, SaveKeywordDAOBean saveKeywordDAOBean) {
        this.createKeywordDAOBean = createKeywordDAOBean;
        this.saveKeywordDAOBean = saveKeywordDAOBean;
    }

    public UUID exec(RequestKeywordSaveDTO requestKeywordSaveDTO) {
        // 키워드 객체(DAO) 생성
        KeywordDAO keywordDAO = createKeywordDAOBean.exec(requestKeywordSaveDTO);
        if(keywordDAO == null) return null;

        // 키워드 객체 DB에 저장
        saveKeywordDAOBean.exec(keywordDAO);

        // PK값 반환
        return keywordDAO.getKeywordId();
    }
}
