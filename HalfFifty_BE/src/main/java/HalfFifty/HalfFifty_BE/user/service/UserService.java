package HalfFifty.HalfFifty_BE.user.service;

import HalfFifty.HalfFifty_BE.user.bean.GetUserBean;
import HalfFifty.HalfFifty_BE.user.bean.SaveUserBean;
import HalfFifty.HalfFifty_BE.user.bean.UpdateUserBean;
import HalfFifty.HalfFifty_BE.user.domain.DTO.RequestUserSaveDTO;
import HalfFifty.HalfFifty_BE.user.domain.DTO.RequestUserUpdateDTO;
import HalfFifty.HalfFifty_BE.user.domain.DTO.ResponseUserGetDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class UserService {
    SaveUserBean saveUserBean;
    GetUserBean getUserBean;
    UpdateUserBean updateUserBean;

    @Autowired
    public UserService(SaveUserBean saveUserBean, GetUserBean getUserBean, UpdateUserBean updateUserBean) {
        this.saveUserBean = saveUserBean;
        this.getUserBean = getUserBean;
        this.updateUserBean = updateUserBean;
    }

    // 유저 프로필 조회
    public ResponseUserGetDTO getUserProfile(UUID userId) {
        return getUserBean.exec(userId);
    }

    // 유저 닉네임 수정
    public UUID updateUser(RequestUserUpdateDTO requestUserUpdateDTO) {
        return updateUserBean.exec(requestUserUpdateDTO);
    }

    // 유저 회원가입(임시)
    public UUID exec(RequestUserSaveDTO requestUserSaveDTO) {
        return saveUserBean.exec(requestUserSaveDTO);
    }
}
