package HalfFifty.HalfFifty_BE.FAQ.bean;

import HalfFifty.HalfFifty_BE.FAQ.bean.small.CreateFaqDAOBean;
import HalfFifty.HalfFifty_BE.FAQ.bean.small.SaveFaqDAOBean;
import HalfFifty.HalfFifty_BE.FAQ.domain.DTO.RequestFaqSaveDTO;
import HalfFifty.HalfFifty_BE.FAQ.domain.FaqDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.UUID;

@Component
public class FaqSaveBean {
    CreateFaqDAOBean createFaqDAOBean;
    SaveFaqDAOBean saveFaqDAOBean;

    @Autowired
    public FaqSaveBean(CreateFaqDAOBean createFaqDAOBean, SaveFaqDAOBean saveFaqDAOBean) {
        this.createFaqDAOBean = createFaqDAOBean;
        this.saveFaqDAOBean = saveFaqDAOBean;
    }

    // FAQ 저장
    public UUID exec(RequestFaqSaveDTO requestFaqSaveDTO) {
        // FAQ 객체 생성
        FaqDAO faqDAO = createFaqDAOBean.exec(requestFaqSaveDTO);
        if(faqDAO == null) return null;

        // 생성한 객체 저장
        saveFaqDAOBean.exec(faqDAO);

        // 키값 반환
        return faqDAO.getFAQId();
    }
}
