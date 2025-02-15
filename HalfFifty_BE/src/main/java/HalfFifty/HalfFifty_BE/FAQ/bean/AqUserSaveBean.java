package HalfFifty.HalfFifty_BE.FAQ.bean;

import HalfFifty.HalfFifty_BE.FAQ.bean.small.CreateAqUserDAOBean;
import HalfFifty.HalfFifty_BE.FAQ.bean.small.SaveAqUserDAOBean;
import HalfFifty.HalfFifty_BE.FAQ.domain.AqDAO;
import HalfFifty.HalfFifty_BE.FAQ.domain.DTO.RequestAqUserSaveDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.UUID;

@Component
public class AqUserSaveBean {
    CreateAqUserDAOBean createAqUserDAOBean;
    SaveAqUserDAOBean saveAqUserDAOBean;

    @Autowired
    public AqUserSaveBean(CreateAqUserDAOBean createAqUserDAOBean, SaveAqUserDAOBean saveAqUserDAOBean) {
        this.createAqUserDAOBean = createAqUserDAOBean;
        this.saveAqUserDAOBean = saveAqUserDAOBean;
    }

    // AQ 등록
    public UUID exec(RequestAqUserSaveDTO requestAqUserSaveDTO) {
        // AQ 객체 생성
        AqDAO aqDAO = createAqUserDAOBean.exec(requestAqUserSaveDTO);
        if(aqDAO == null) return null;

        // 생성한 객체 저장
        saveAqUserDAOBean.exec(aqDAO);

        // 키값 반환
        return  aqDAO.getAqId();
    }
}
