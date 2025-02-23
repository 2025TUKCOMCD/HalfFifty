package HalfFifty.HalfFifty_BE.translation.service;

import HalfFifty.HalfFifty_BE.translation.bean.FlaskSignLanguageBean;
import HalfFifty.HalfFifty_BE.translation.bean.SaveTranslationBean;
import HalfFifty.HalfFifty_BE.translation.domain.DTO.RequestSignLanguageDTO;
import HalfFifty.HalfFifty_BE.translation.domain.DTO.ResponseTranslationGetDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;


@Service
public class TranslationService {
    SaveTranslationBean saveTranslationBean;
    FlaskSignLanguageBean flaskSignLanguageBean;

    @Autowired
    public TranslationService(SaveTranslationBean saveTranslationBean, FlaskSignLanguageBean flaskSignLanguageBean) {
        this.saveTranslationBean = saveTranslationBean;
        this.flaskSignLanguageBean = flaskSignLanguageBean;
    }

    public ResponseTranslationGetDTO signLanguageTranslation(RequestSignLanguageDTO requestSignLanguageDTO) {
        Map<String, Object> aiResponse = flaskSignLanguageBean.exec(requestSignLanguageDTO);

        if (aiResponse != null && Boolean.TRUE.equals(aiResponse.get("success"))) {
            String translatedWord = (String) aiResponse.get("predicted_label");
            Double probability = (Double) aiResponse.get("confidence");
            return saveTranslationBean.exec(requestSignLanguageDTO.getUserId(), translatedWord, probability);
        } else {
            return null;
        }
    }

}
