package HalfFifty.HalfFifty_BE.keyword.bean;

import HalfFifty.HalfFifty_BE.keyword.bean.small.GetKeywordDAOBean;
import HalfFifty.HalfFifty_BE.keyword.bean.small.SaveKeywordDAOBean;
import HalfFifty.HalfFifty_BE.keyword.domain.DTO.RequestKeyWordUpdateDTO;
import HalfFifty.HalfFifty_BE.keyword.domain.KeywordDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.UUID;

@Component
public class UpdateKeywordBean {
    GetKeywordDAOBean getKeywordDAOBean;
    SaveKeywordDAOBean saveKeywordDAOBean;

    @Autowired
    public UpdateKeywordBean(GetKeywordDAOBean getKeywordDAOBean, SaveKeywordDAOBean saveKeywordDAOBean) {
        this.getKeywordDAOBean = getKeywordDAOBean;
        this.saveKeywordDAOBean = saveKeywordDAOBean;
    }

    public UUID exec(RequestKeyWordUpdateDTO requestKeyWordUpdateDTO) {
        // 키워드 id와 유저 id를 통해 원하는 객체 찾기
        KeywordDAO keywordDAO = getKeywordDAOBean.exec(requestKeyWordUpdateDTO.getUserId(), requestKeyWordUpdateDTO.getKeywordId());
        if(keywordDAO == null) return null;

        // 찾은 객체 수정
        keywordDAO.setKeyword(requestKeyWordUpdateDTO.getKeyword());
        keywordDAO.setUpdatedAt(LocalDateTime.now());

        // 수정한 객체 저장
        saveKeywordDAOBean.exec(keywordDAO);

        // 키값 반환
        return keywordDAO.getKeywordId();
    }
}
