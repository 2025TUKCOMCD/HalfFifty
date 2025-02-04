package HalfFifty.HalfFifty_BE.translation.service;

import HalfFifty.HalfFifty_BE.translation.bean.SaveTranslationBean;
import HalfFifty.HalfFifty_BE.translation.domain.DTO.RequestSignLanguageDTO;
import HalfFifty.HalfFifty_BE.translation.domain.DTO.ResponseTranslationGetDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class TranslationService {
    SaveTranslationBean saveTranslationBean;

    @Autowired
    public TranslationService(SaveTranslationBean saveTranslationBean) {
        this.saveTranslationBean = saveTranslationBean;
    }

    public ResponseTranslationGetDTO signLanguageTranslation(RequestSignLanguageDTO requestSignLanguageDTO) {
        // 람다를 통해 번역된 수화를 가져옴

        // 번역된 수화를 저장하고 번역 기록을 프론트에게 전달
        return saveTranslationBean.exec(requestSignLanguageDTO.getUserId(), "123");
    }

}
