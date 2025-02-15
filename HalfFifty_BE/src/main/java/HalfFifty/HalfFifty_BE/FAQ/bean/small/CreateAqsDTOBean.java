package HalfFifty.HalfFifty_BE.FAQ.bean.small;

import HalfFifty.HalfFifty_BE.FAQ.domain.AqDAO;
import HalfFifty.HalfFifty_BE.FAQ.domain.DTO.ResponseAqGetDTO;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class CreateAqsDTOBean {

    // 객체 리스트를 DTO로 변환
    public List<ResponseAqGetDTO> exec(List<AqDAO> aqDAOS) {
        // 객체 리스트를 담을 DTO 리스트 생성
        List<ResponseAqGetDTO> responseAqGetDTOS = new ArrayList<>();

        // for문을 통해 각 객체들 DTO로 변환
        for(AqDAO aqDAO : aqDAOS) {
            ResponseAqGetDTO responseAqGetDTO = ResponseAqGetDTO.builder()
                    .aqId(aqDAO.getAqId())
                    .question(aqDAO.getQuestion())
                    .answer(aqDAO.getAnswer())
                    .questionCreatedAt(aqDAO.getQuestionCreatedAt())
                    .answerCreatedAt(aqDAO.getAnswerCreatedAt())
                    .isAnswer(aqDAO.getIsAnswer())
                    .build();

            responseAqGetDTOS.add(responseAqGetDTO);
        }

        // 변환된 DTO 리스트 반환
        return responseAqGetDTOS;
    }
}
