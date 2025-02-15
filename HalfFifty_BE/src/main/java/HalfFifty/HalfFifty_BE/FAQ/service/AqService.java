package HalfFifty.HalfFifty_BE.FAQ.service;

import HalfFifty.HalfFifty_BE.FAQ.bean.AqUserSaveBean;
import HalfFifty.HalfFifty_BE.FAQ.bean.GetAqsBean;
import HalfFifty.HalfFifty_BE.FAQ.bean.UpdateAqAdminBean;
import HalfFifty.HalfFifty_BE.FAQ.domain.DTO.RequestAqAdminUpdateDTO;
import HalfFifty.HalfFifty_BE.FAQ.domain.DTO.RequestAqUserSaveDTO;
import HalfFifty.HalfFifty_BE.FAQ.domain.DTO.ResponseAqGetDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class AqService {
    AqUserSaveBean aqUserSaveBean;
    UpdateAqAdminBean updateAqAdminBean;
    GetAqsBean getAqsBean;


    @Autowired
    public AqService(AqUserSaveBean aqUserSaveBean, UpdateAqAdminBean updateAqAdminBean, GetAqsBean getAqsBean) {
        this.aqUserSaveBean = aqUserSaveBean;
        this.updateAqAdminBean = updateAqAdminBean;
        this.getAqsBean = getAqsBean;
    }

    // AQ 전체조회
    public List<ResponseAqGetDTO> getAqs(UUID userId) {
        return getAqsBean.exec(userId);
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
