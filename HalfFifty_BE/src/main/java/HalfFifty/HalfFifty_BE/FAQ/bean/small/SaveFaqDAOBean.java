package HalfFifty.HalfFifty_BE.FAQ.bean.small;

import HalfFifty.HalfFifty_BE.FAQ.domain.FaqDAO;
import HalfFifty.HalfFifty_BE.FAQ.repository.FaqRepositoryJPA;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class SaveFaqDAOBean {
    FaqRepositoryJPA faqRepositoryJPA;

    @Autowired
    public SaveFaqDAOBean(FaqRepositoryJPA faqRepositoryJPA) {
        this.faqRepositoryJPA = faqRepositoryJPA;
    }

    // Faq 객체 저장
    public void exec(FaqDAO faqDAO) {
        faqRepositoryJPA.save(faqDAO);
    }
}
