package HalfFifty.HalfFifty_BE.FAQ.bean;

import HalfFifty.HalfFifty_BE.FAQ.bean.small.CreateAqUserDAOBean;
import HalfFifty.HalfFifty_BE.FAQ.bean.small.SaveAqDAOBean;
import HalfFifty.HalfFifty_BE.FAQ.domain.AqDAO;
import HalfFifty.HalfFifty_BE.FAQ.domain.DTO.RequestAqUserSaveDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.UUID;

@Component
public class AqUserSaveBean {
    CreateAqUserDAOBean createAqUserDAOBean;
    SaveAqDAOBean saveAqDAOBean;

    @Autowired
    public AqUserSaveBean(CreateAqUserDAOBean createAqUserDAOBean, SaveAqDAOBean saveAqDAOBean) {
        this.createAqUserDAOBean = createAqUserDAOBean;
        this.saveAqDAOBean = saveAqDAOBean;
    }

    // AQ 등록
    public UUID exec(RequestAqUserSaveDTO requestAqUserSaveDTO) {
        // AQ 객체 생성
        AqDAO aqDAO = createAqUserDAOBean.exec(requestAqUserSaveDTO);
        if(aqDAO == null) return null;

        // 생성한 객체 저장
        saveAqDAOBean.exec(aqDAO);

        // 키값 반환
        return  aqDAO.getAqId();
    }
}
