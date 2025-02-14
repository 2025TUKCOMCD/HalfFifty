package HalfFifty.HalfFifty_BE.FAQ.service;

import HalfFifty.HalfFifty_BE.FAQ.bean.FaqSaveBean;
import HalfFifty.HalfFifty_BE.FAQ.bean.GetFaqsBean;
import HalfFifty.HalfFifty_BE.FAQ.domain.DTO.RequestFaqSaveDTO;
import HalfFifty.HalfFifty_BE.FAQ.domain.DTO.ResponseFaqGetDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class FaqService {
    FaqSaveBean faqSaveBean;
    GetFaqsBean getFaqsBean;

    @Autowired
    public FaqService(FaqSaveBean faqSaveBean, GetFaqsBean getFaqsBean) {
        this.faqSaveBean = faqSaveBean;
        this.getFaqsBean = getFaqsBean;
    }

    // Faq 전체조회
    public List<ResponseFaqGetDTO> getFaqAll() {
        return getFaqsBean.exec();
    }

    // Faq 저장 (관리자용)
    public UUID saveFaq(RequestFaqSaveDTO requestFaqSaveDTO) {
        return faqSaveBean.exec(requestFaqSaveDTO);
    }
}
