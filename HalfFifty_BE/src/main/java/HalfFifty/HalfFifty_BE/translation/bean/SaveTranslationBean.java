package HalfFifty.HalfFifty_BE.translation.bean;

import HalfFifty.HalfFifty_BE.translation.bean.small.CreateTranslationDAOBean;
import HalfFifty.HalfFifty_BE.translation.bean.small.CreateTranslationDTOBean;
import HalfFifty.HalfFifty_BE.translation.bean.small.SaveTranslationDAOBean;
import HalfFifty.HalfFifty_BE.translation.domain.DTO.ResponseTranslationGetDTO;
import HalfFifty.HalfFifty_BE.translation.domain.TranslationDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.UUID;

@Component
public class SaveTranslationBean {
    CreateTranslationDAOBean createTranslationDAOBean;
    CreateTranslationDTOBean createTranslationDTOBean;
    SaveTranslationDAOBean saveTranslationDAOBean;

    @Autowired
    public SaveTranslationBean(CreateTranslationDAOBean createTranslationDAOBean, CreateTranslationDTOBean createTranslationDTOBean, SaveTranslationDAOBean saveTranslationDAOBean) {
        this.createTranslationDAOBean = createTranslationDAOBean;
        this.createTranslationDTOBean = createTranslationDTOBean;
        this.saveTranslationDAOBean = saveTranslationDAOBean;
    }

    // 번역 기록 저장
    public ResponseTranslationGetDTO exec(UUID userId, String translationWord) {
        // 번역 객체 생성
        TranslationDAO translationDAO = createTranslationDAOBean.exec(userId, translationWord);
        if(translationDAO == null) return null;

        // 번역 저장
        saveTranslationDAOBean.exec(translationDAO);

        // 수화 번역 객체를 DTO로 변환해서 반환
        return createTranslationDTOBean.exec(translationDAO);
    }
}
