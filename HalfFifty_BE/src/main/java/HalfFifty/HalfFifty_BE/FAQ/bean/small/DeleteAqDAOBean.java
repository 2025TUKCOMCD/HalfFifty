package HalfFifty.HalfFifty_BE.FAQ.bean.small;

import HalfFifty.HalfFifty_BE.FAQ.domain.AqDAO;
import HalfFifty.HalfFifty_BE.FAQ.repository.AqRepositoryJPA;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class DeleteAqDAOBean {
    AqRepositoryJPA aqRepositoryJPA;

    @Autowired
    public DeleteAqDAOBean(AqRepositoryJPA aqRepositoryJPA) {
        this.aqRepositoryJPA = aqRepositoryJPA;
    }

    // AQ 삭제
    public void exec(AqDAO aqDAO) {
        aqRepositoryJPA.delete(aqDAO);
    }
}
