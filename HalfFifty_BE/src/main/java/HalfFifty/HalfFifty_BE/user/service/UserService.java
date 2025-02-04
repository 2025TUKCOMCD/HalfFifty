package HalfFifty.HalfFifty_BE.user.service;

import HalfFifty.HalfFifty_BE.user.bean.GetUserBean;
import HalfFifty.HalfFifty_BE.user.bean.SaveUserBean;
import HalfFifty.HalfFifty_BE.user.domain.DTO.RequestUserSaveDTO;
import HalfFifty.HalfFifty_BE.user.domain.DTO.ResponseUserGetDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class UserService {
    SaveUserBean saveUserBean;
    GetUserBean getUserBean;

    @Autowired
    public UserService(SaveUserBean saveUserBean, GetUserBean getUserBean) {
        this.saveUserBean = saveUserBean;
        this.getUserBean = getUserBean;
    }

    // 유저 프로필 조회
    public ResponseUserGetDTO getUserProfile(UUID userId) {
        return getUserBean.exec(userId);
    }

    // 유저 회원가입(임시)
    public UUID exec(RequestUserSaveDTO requestUserSaveDTO) {
        return saveUserBean.exec(requestUserSaveDTO);
    }
}
