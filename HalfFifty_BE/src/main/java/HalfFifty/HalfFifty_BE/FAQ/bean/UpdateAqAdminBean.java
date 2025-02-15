package HalfFifty.HalfFifty_BE.FAQ.bean;

import HalfFifty.HalfFifty_BE.FAQ.bean.small.GetAqDAOBean;
import HalfFifty.HalfFifty_BE.FAQ.bean.small.SaveAqDAOBean;
import HalfFifty.HalfFifty_BE.FAQ.domain.AqDAO;
import HalfFifty.HalfFifty_BE.FAQ.domain.DTO.RequestAqAdminUpdateDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.UUID;

@Component
public class UpdateAqAdminBean {
    GetAqDAOBean getAqDAOBean;
    SaveAqDAOBean saveAqDAOBean;

    @Autowired
    public UpdateAqAdminBean(GetAqDAOBean getAqDAOBean, SaveAqDAOBean saveAqDAOBean) {
        this.getAqDAOBean = getAqDAOBean;
        this.saveAqDAOBean = saveAqDAOBean;
    }

    // AQ admin 답장
    public UUID exec(RequestAqAdminUpdateDTO requestAqAdminUpdateDTO) {
        // AQ 아이디를 통해 원하는 객체 찾기
        AqDAO aqDAO = getAqDAOBean.exec(requestAqAdminUpdateDTO.getAqId());
        if(aqDAO == null) return null;

        // 찾은 객체 수정
        aqDAO.setAnswer(requestAqAdminUpdateDTO.getAnswer());
        aqDAO.setIsAnswer(Boolean.TRUE);
        aqDAO.setAnswerCreatedAt(LocalDateTime.now());

        // 수정된 값 저장
        saveAqDAOBean.exec(aqDAO);

        // 키값 반환
        return aqDAO.getAqId();
    }
}
