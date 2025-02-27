package HalfFifty.HalfFifty_BE.translation.bean;

import HalfFifty.HalfFifty_BE.translation.bean.small.DeleteTranslationDAOBean;
import HalfFifty.HalfFifty_BE.translation.bean.small.GetTranslationDAOBean;
import HalfFifty.HalfFifty_BE.translation.domain.DTO.RequestTranslationDeleteDTO;
import HalfFifty.HalfFifty_BE.translation.domain.TranslationDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class DeleteTranslationBean {
    DeleteTranslationDAOBean deleteTranslationDAOBean;
    GetTranslationDAOBean getTranslationDAOBean;

    @Autowired
    public DeleteTranslationBean(DeleteTranslationDAOBean deleteTranslationDAOBean, GetTranslationDAOBean getTranslationDAOBean) {
        this.deleteTranslationDAOBean = deleteTranslationDAOBean;
        this.getTranslationDAOBean = getTranslationDAOBean;
    }

    // 번역 기록 삭제
    public boolean exec(RequestTranslationDeleteDTO requestTranslationDeleteDTO) {
        // translationId와 userId를 통해서 원하는 객체를 찾음
        TranslationDAO translationDAO = getTranslationDAOBean.exec(requestTranslationDeleteDTO.getTranslationId(), requestTranslationDeleteDTO.getUserId());
        if(translationDAO == null) return Boolean.FALSE;

        // 찾은 객체를 삭제
        deleteTranslationDAOBean.exec(translationDAO);

        // 성공 여부 반환
        return Boolean.TRUE;
    }
}
