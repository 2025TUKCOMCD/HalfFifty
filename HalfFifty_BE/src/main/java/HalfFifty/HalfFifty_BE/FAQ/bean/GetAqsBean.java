package HalfFifty.HalfFifty_BE.FAQ.bean;

import HalfFifty.HalfFifty_BE.FAQ.bean.small.CreateAqsDTOBean;
import HalfFifty.HalfFifty_BE.FAQ.bean.small.GetAqsDAOBean;
import HalfFifty.HalfFifty_BE.FAQ.domain.AqDAO;
import HalfFifty.HalfFifty_BE.FAQ.domain.DTO.ResponseAqGetDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Component
public class GetAqsBean {
    GetAqsDAOBean getAqsDAOBean;
    CreateAqsDTOBean createAqsDTOBean;

    @Autowired
    public GetAqsBean(GetAqsDAOBean getAqsDAOBean, CreateAqsDTOBean createAqsDTOBean) {
        this.getAqsDAOBean = getAqsDAOBean;
        this.createAqsDTOBean = createAqsDTOBean;
    }

    // AQ 전체조회
    public List<ResponseAqGetDTO> exec(UUID userId) {
        // userId를 통해 원하는 객체 리스트 찾기
        List<AqDAO> aqDAOS = getAqsDAOBean.exec(userId);
        if(aqDAOS == null) return new ArrayList<>();

        // 객체 리스트 DTO로 변환 후 반환
        return createAqsDTOBean.exec(aqDAOS);
    }
}
