package HalfFifty.HalfFifty_BE.FAQ.bean.small;

import HalfFifty.HalfFifty_BE.FAQ.domain.AqDAO;
import HalfFifty.HalfFifty_BE.FAQ.repository.AqRepositoryJPA;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.UUID;

@Component
public class GetAqsDAOBean {
    AqRepositoryJPA aqRepositoryJPA;

    @Autowired
    public GetAqsDAOBean(AqRepositoryJPA aqRepositoryJPA) {
        this.aqRepositoryJPA = aqRepositoryJPA;
    }

    // user 아이디를 통해 원하는 객체 리스트 반환
    public List<AqDAO> exec(UUID userId) {
        return aqRepositoryJPA.findAllByUserId(userId);
    }
}
