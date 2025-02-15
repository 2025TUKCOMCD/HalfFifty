package HalfFifty.HalfFifty_BE.FAQ.service;

import HalfFifty.HalfFifty_BE.FAQ.bean.AqUserSaveBean;
import HalfFifty.HalfFifty_BE.FAQ.bean.UpdateAqAdminBean;
import HalfFifty.HalfFifty_BE.FAQ.domain.DTO.RequestAqAdminUpdateDTO;
import HalfFifty.HalfFifty_BE.FAQ.domain.DTO.RequestAqUserSaveDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class AqService {
    AqUserSaveBean aqUserSaveBean;
    UpdateAqAdminBean updateAqAdminBean;

    @Autowired
    public AqService(AqUserSaveBean aqUserSaveBean, UpdateAqAdminBean updateAqAdminBean) {
        this.aqUserSaveBean = aqUserSaveBean;
        this.updateAqAdminBean = updateAqAdminBean;
    }

    // AQ 유저 등록
    public UUID saveUserAq(RequestAqUserSaveDTO requestAqUserSaveDTO) {
        return aqUserSaveBean.exec(requestAqUserSaveDTO);
    }

    // AQ 어드민 답장
    public UUID updateAdminAq(RequestAqAdminUpdateDTO requestAqAdminUpdateDTO) {
        return updateAqAdminBean.exec(requestAqAdminUpdateDTO);
    }
}
