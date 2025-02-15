package HalfFifty.HalfFifty_BE.FAQ.bean.small;

import HalfFifty.HalfFifty_BE.FAQ.domain.AqDAO;
import HalfFifty.HalfFifty_BE.FAQ.repository.AqRepositoryJPA;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.UUID;

@Component
public class GetAqDAOBean {
    AqRepositoryJPA aqRepositoryJPA;

    @Autowired
    public GetAqDAOBean(AqRepositoryJPA aqRepositoryJPA) {
        this.aqRepositoryJPA = aqRepositoryJPA;
    }

    // AQ 아이디를 통해 원하는 객체 찾기
    public AqDAO exec(UUID AqId) {
        return aqRepositoryJPA.findById(AqId).orElse(null);
    }
}
