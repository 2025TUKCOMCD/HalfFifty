package HalfFifty.HalfFifty_BE.FAQ.bean.small;

import HalfFifty.HalfFifty_BE.FAQ.domain.DTO.RequestFaqSaveDTO;
import HalfFifty.HalfFifty_BE.FAQ.domain.FaqDAO;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
public class CreateFaqDAOBean {

    // Faq 객체 생성
    public FaqDAO exec(RequestFaqSaveDTO requestFaqSaveDTO) {
        return FaqDAO.builder()
                .question(requestFaqSaveDTO.getQuestion())
                .answer(requestFaqSaveDTO.getAnswer())
                .createdAt(LocalDateTime.now())
                .build();
    }
}
