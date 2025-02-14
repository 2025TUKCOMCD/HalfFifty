package HalfFifty.HalfFifty_BE.FAQ.bean;

import HalfFifty.HalfFifty_BE.FAQ.bean.small.CreateFaqsDTOBean;
import HalfFifty.HalfFifty_BE.FAQ.bean.small.GetFaqsDAOBean;
import HalfFifty.HalfFifty_BE.FAQ.domain.DTO.ResponseFaqGetDTO;
import HalfFifty.HalfFifty_BE.FAQ.domain.FaqDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class GetFaqsBean {
    CreateFaqsDTOBean createFaqsDTOBean;
    GetFaqsDAOBean getFaqsDAOBean;

    @Autowired
    public GetFaqsBean(CreateFaqsDTOBean createFaqsDTOBean, GetFaqsDAOBean getFaqsDAOBean) {
        this.createFaqsDTOBean = createFaqsDTOBean;
        this.getFaqsDAOBean = getFaqsDAOBean;
    }

    // FAQ 리스트 조회
    public List<ResponseFaqGetDTO> exec() {
        // FAQ 객체들 전부 가져오기
        List<FaqDAO> faqDAOS = getFaqsDAOBean.exec();
        if(faqDAOS == null) return new ArrayList<>();

        // 객체들 DTO로 변환
        return createFaqsDTOBean.exec(faqDAOS);
    }
}
