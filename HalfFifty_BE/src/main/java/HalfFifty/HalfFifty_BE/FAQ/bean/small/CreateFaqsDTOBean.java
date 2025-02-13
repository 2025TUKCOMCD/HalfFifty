package HalfFifty.HalfFifty_BE.FAQ.bean.small;

import HalfFifty.HalfFifty_BE.FAQ.domain.DTO.ResponseFaqGetDTO;
import HalfFifty.HalfFifty_BE.FAQ.domain.FaqDAO;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class CreateFaqsDTOBean {

    // FAQ 객체 리스트를 DTO 리스트로 변환
    public List<ResponseFaqGetDTO> exec(List<FaqDAO> faqDAOS) {
        // DTO 빈 리스트 생성
        List<ResponseFaqGetDTO> responseFaqGetDTOS = new ArrayList<>();

        // 각 객체 DTO로 변환
        for(FaqDAO faqDAO : faqDAOS) {
            ResponseFaqGetDTO responseFaqGetDTO = ResponseFaqGetDTO.builder()
                    .faqId(faqDAO.getFAQId())
                    .question(faqDAO.getQuestion())
                    .answer(faqDAO.getAnswer())
                    .build();

            responseFaqGetDTOS.add(responseFaqGetDTO);
        }

        // DTO 리스트 반환
        return responseFaqGetDTOS;
    }
}
