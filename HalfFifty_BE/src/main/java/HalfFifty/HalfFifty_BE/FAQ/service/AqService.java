package HalfFifty.HalfFifty_BE.FAQ.service;

import HalfFifty.HalfFifty_BE.FAQ.bean.AqUserSaveBean;
import HalfFifty.HalfFifty_BE.FAQ.domain.DTO.RequestAqUserSaveDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class AqService {
    AqUserSaveBean aqUserSaveBean;

    @Autowired
    public AqService(AqUserSaveBean aqUserSaveBean) {
        this.aqUserSaveBean = aqUserSaveBean;
    }

    // AQ 유저 등록
    public UUID saveUserAq(RequestAqUserSaveDTO requestAqUserSaveDTO) {
        return aqUserSaveBean.exec(requestAqUserSaveDTO);
    }
}
