package HalfFifty.HalfFifty_BE.keyword.bean;

import HalfFifty.HalfFifty_BE.keyword.bean.small.DeleteKeywordDAOBean;
import HalfFifty.HalfFifty_BE.keyword.bean.small.GetKeywordDAOBean;
import HalfFifty.HalfFifty_BE.keyword.domain.DTO.RequestKeywordDeleteDTO;
import HalfFifty.HalfFifty_BE.keyword.domain.KeywordDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class DeleteKeywordBean {
    GetKeywordDAOBean getKeywordDAOBean;
    DeleteKeywordDAOBean deleteKEywordDAOBean;

    @Autowired
    public DeleteKeywordBean(GetKeywordDAOBean getKeywordDAOBean, DeleteKeywordDAOBean deleteKEywordDAOBean) {
        this.getKeywordDAOBean = getKeywordDAOBean;
        this.deleteKEywordDAOBean = deleteKEywordDAOBean;
    }

    public Boolean exec(RequestKeywordDeleteDTO requestKeywordDeleteDTO) {
        // 유저 id와 키워드 id를 통해 원하는 객체 찾음
        KeywordDAO keywordDAO = getKeywordDAOBean.exec(requestKeywordDeleteDTO.getUserId(), requestKeywordDeleteDTO.getKeywordId());
        if(keywordDAO == null) return null;

        // 키워드 객체 삭제
        deleteKEywordDAOBean.exec(keywordDAO);

        // 성공여부 반환
        return true;
    }
}
