package HalfFifty.HalfFifty_BE.FAQ.bean;

import HalfFifty.HalfFifty_BE.FAQ.bean.small.DeleteAqDAOBean;
import HalfFifty.HalfFifty_BE.FAQ.bean.small.GetAqDAOBean;
import HalfFifty.HalfFifty_BE.FAQ.domain.AqDAO;
import HalfFifty.HalfFifty_BE.FAQ.domain.DTO.RequestAqDeleteDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class DeleteAqBean {
    GetAqDAOBean getAqDAOBean;
    DeleteAqDAOBean deleteAqDAOBean;

    @Autowired
    public DeleteAqBean(GetAqDAOBean getAqDAOBean, DeleteAqDAOBean deleteAqDAOBean) {
        this.getAqDAOBean = getAqDAOBean;
        this.deleteAqDAOBean = deleteAqDAOBean;
    }

    // AQ 삭제
    public Boolean exec(RequestAqDeleteDTO requestAqDeleteDTO) {
        // AQ 아이디와 user 아이디를 통해 원하는 객체 찾기
        AqDAO aqDAO = getAqDAOBean.exec(requestAqDeleteDTO.getAqId(), requestAqDeleteDTO.getUserId());
        if(aqDAO == null) return false;

        // 찾은 객체 삭제
        deleteAqDAOBean.exec(aqDAO);

        // 삭제 성공 여부 반환
        return true;
    }
}
