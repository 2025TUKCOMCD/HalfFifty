package HalfFifty.HalfFifty_BE.FAQ.service;

import HalfFifty.HalfFifty_BE.FAQ.bean.FaqSaveBean;
import HalfFifty.HalfFifty_BE.FAQ.domain.DTO.RequestFaqSaveDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class FaqService {
    FaqSaveBean faqSaveBean;

    @Autowired
    public FaqService(FaqSaveBean faqSaveBean) {
        this.faqSaveBean = faqSaveBean;
    }

    // Faq 저장 (관리자용)
    public UUID saveFaq(RequestFaqSaveDTO requestFaqSaveDTO) {
        return faqSaveBean.exec(requestFaqSaveDTO);
    }
}
