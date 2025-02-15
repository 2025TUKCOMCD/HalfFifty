package HalfFifty.HalfFifty_BE.FAQ.bean.small;

import HalfFifty.HalfFifty_BE.FAQ.domain.AqDAO;
import HalfFifty.HalfFifty_BE.FAQ.domain.DTO.RequestAqUserSaveDTO;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
public class CreateAqUserDAOBean {

    // AQ 유저 객체 생성
    public AqDAO exec(RequestAqUserSaveDTO requestAqUserSaveDTO) {
        return AqDAO.builder()
                .userId(requestAqUserSaveDTO.getUserId())
                .question(requestAqUserSaveDTO.getQuestion())
                .questionCreatedAt(LocalDateTime.now())
                .isAnswer(Boolean.FALSE)
                .build();
    }
}
