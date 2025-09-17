package HalfFifty.HalfFifty_BE.translation.service;

import HalfFifty.HalfFifty_BE.translation.bean.DeleteTranslationBean;
import HalfFifty.HalfFifty_BE.translation.bean.FlaskSignLanguageBean;
import HalfFifty.HalfFifty_BE.translation.bean.FrameBufferBean;
import HalfFifty.HalfFifty_BE.translation.bean.SaveTranslationBean;
import HalfFifty.HalfFifty_BE.translation.domain.DTO.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.UUID;


@Service
public class TranslationService {
    private final SaveTranslationBean saveTranslationBean;
    private final FlaskSignLanguageBean flaskSignLanguageBean;
    private final DeleteTranslationBean deleteTranslationBean;
    private final FrameBufferBean frameBufferBean;

    @Autowired
    public TranslationService(SaveTranslationBean saveTranslationBean,
                              FlaskSignLanguageBean flaskSignLanguageBean,
                              DeleteTranslationBean deleteTranslationBean,
                              FrameBufferBean frameBufferBean) {
        this.saveTranslationBean = saveTranslationBean;
        this.flaskSignLanguageBean = flaskSignLanguageBean;
        this.deleteTranslationBean = deleteTranslationBean;
        this.frameBufferBean = frameBufferBean;
    }

    public TranslationStatusResponse getTranslationStatus(RequestSignLanguageDTO requestSignLanguageDTO) {
        try {
            Map<String, Object> aiResponse = flaskSignLanguageBean.exec(requestSignLanguageDTO);

            if (aiResponse != null && Boolean.TRUE.equals(aiResponse.get("success"))) {
                String predictedWord = (String) aiResponse.get("predicted_label");
                Double confidence = (Double) aiResponse.get("confidence");

                FrameBufferResult bufferResult = frameBufferBean.addFrame(
                        requestSignLanguageDTO.getUserId(),
                        predictedWord
                );

                if (bufferResult.isConfirmed()) {
                    ResponseTranslationGetDTO result = saveTranslationBean.exec(
                            requestSignLanguageDTO.getUserId(),
                            bufferResult.getConfirmedWord(),
                            confidence
                    );
                    return TranslationStatusResponse.builder()
                            .status("success")
                            .message("수화 번역 성공")
                            .data(result)
                            .build();
                } else {
                    return TranslationStatusResponse.builder()
                            .status("processing")
                            .message("수화 인식 중... (" + bufferResult.getCurrentBufferSize() + "/5)")
                            .data(null)
                            .build();
                }
            } else {
                return TranslationStatusResponse.builder()
                        .status("failed")
                        .message("수화 인식 실패")
                        .data(null)
                        .build();
            }

        } catch (Exception e) {
            return TranslationStatusResponse.builder()
                    .status("failed")
                    .message("서버 오류: " + e.getMessage())
                    .data(null)
                    .build();
        }
    }

    // 번역 기록 삭제
    public boolean deleteTranslation(RequestTranslationDeleteDTO requestTranslationDeleteDTO) {
        return deleteTranslationBean.exec(requestTranslationDeleteDTO);
    }
}
