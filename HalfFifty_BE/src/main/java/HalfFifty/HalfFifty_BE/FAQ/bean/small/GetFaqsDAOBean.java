package HalfFifty.HalfFifty_BE.FAQ.bean.small;

import HalfFifty.HalfFifty_BE.FAQ.domain.FaqDAO;
import HalfFifty.HalfFifty_BE.FAQ.repository.FaqRepositoryJPA;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class GetFaqsDAOBean {
    FaqRepositoryJPA faqRepositoryJPA;

    @Autowired
    public GetFaqsDAOBean(FaqRepositoryJPA faqRepositoryJPA) {
        this.faqRepositoryJPA = faqRepositoryJPA;
    }

    // FAQ 객체들 가져오기
    public List<FaqDAO> exec() {
        return faqRepositoryJPA.findAll();
    }
}
