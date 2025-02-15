package HalfFifty.HalfFifty_BE.FAQ.bean.small;

import HalfFifty.HalfFifty_BE.FAQ.domain.AqDAO;
import HalfFifty.HalfFifty_BE.FAQ.repository.AqRepositoryJPA;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class SaveAqDAOBean {
    AqRepositoryJPA aqRepositoryJPA;

    @Autowired
    public SaveAqDAOBean(AqRepositoryJPA aqRepositoryJPA) {
        this.aqRepositoryJPA = aqRepositoryJPA;
    }

    // AQ 객체 저장
    public void exec(AqDAO aqDAO) {
        aqRepositoryJPA.save(aqDAO);
    }
}
