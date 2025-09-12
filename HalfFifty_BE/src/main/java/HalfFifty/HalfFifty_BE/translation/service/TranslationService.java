package HalfFifty.HalfFifty_BE.translation.service;

import HalfFifty.HalfFifty_BE.translation.bean.DeleteTranslationBean;
import HalfFifty.HalfFifty_BE.translation.bean.FlaskSignLanguageBean;
import HalfFifty.HalfFifty_BE.translation.bean.FrameBufferBean;
import HalfFifty.HalfFifty_BE.translation.bean.SaveTranslationBean;
import HalfFifty.HalfFifty_BE.translation.domain.DTO.FrameBufferResult;
import HalfFifty.HalfFifty_BE.translation.domain.DTO.RequestSignLanguageDTO;
import HalfFifty.HalfFifty_BE.translation.domain.DTO.RequestTranslationDeleteDTO;
import HalfFifty.HalfFifty_BE.translation.domain.DTO.ResponseTranslationGetDTO;
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

    // 기존 메서드 시그니처 그대로 유지하면서 내부적으로 버퍼링 처리
    public ResponseTranslationGetDTO signLanguageTranslation(RequestSignLanguageDTO requestSignLanguageDTO) {
        // AI 서버에서 예측 결과 받기
        Map<String, Object> aiResponse = flaskSignLanguageBean.exec(requestSignLanguageDTO);

        if (aiResponse != null && Boolean.TRUE.equals(aiResponse.get("success"))) {
            String predictedWord = (String) aiResponse.get("predicted_label");
            Double confidence = (Double) aiResponse.get("confidence");

            // 프레임 버퍼에 추가하고 다수결 확인
            FrameBufferResult bufferResult = frameBufferBean.addFrame(
                    requestSignLanguageDTO.getUserId(),
                    predictedWord
            );

            // 확정된 경우에만 저장하고 반환
            if (bufferResult.isConfirmed()) {
                return saveTranslationBean.exec(
                        requestSignLanguageDTO.getUserId(),
                        bufferResult.getConfirmedWord(),
                        confidence
                );
            } else {
                // 아직 확정되지 않은 경우 null 반환
                // -> 프론트엔드에서는 기존처럼 "번역 실패"로 처리됨
                return null;
            }
        }

        return null;
    }

    // 번역 기록 삭제
    public boolean deleteTranslation(RequestTranslationDeleteDTO requestTranslationDeleteDTO) {
        return deleteTranslationBean.exec(requestTranslationDeleteDTO);
    }
}
