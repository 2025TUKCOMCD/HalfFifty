package HalfFifty.HalfFifty_BE.user.service;

import HalfFifty.HalfFifty_BE.user.bean.SaveUserBean;
import HalfFifty.HalfFifty_BE.user.domain.DTO.RequestUserSaveDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class UserService {
    SaveUserBean saveUserBean;

    @Autowired
    public UserService(SaveUserBean saveUserBean) {
        this.saveUserBean = saveUserBean;
    }

    // 유저 회원가입(임시)
    public UUID exec(RequestUserSaveDTO requestUserSaveDTO) {
        return saveUserBean.exec(requestUserSaveDTO);
    }
}
