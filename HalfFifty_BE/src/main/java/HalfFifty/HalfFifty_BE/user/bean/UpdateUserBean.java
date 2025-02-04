package HalfFifty.HalfFifty_BE.user.bean;

import HalfFifty.HalfFifty_BE.user.bean.small.GetUserDAOBean;
import HalfFifty.HalfFifty_BE.user.bean.small.SaveUserDAOBean;
import HalfFifty.HalfFifty_BE.user.domain.DTO.RequestUserUpdateDTO;
import HalfFifty.HalfFifty_BE.user.domain.UserDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.UUID;

@Component
public class UpdateUserBean {
    GetUserDAOBean getUserDAOBean;
    SaveUserDAOBean saveUserDAOBean;

    @Autowired
    public UpdateUserBean(GetUserDAOBean getUserDAOBean, SaveUserDAOBean saveUserDAOBean) {
        this.getUserDAOBean = getUserDAOBean;
        this.saveUserDAOBean = saveUserDAOBean;
    }

    public UUID exec(RequestUserUpdateDTO requestUserUpdateDTO) {
        // 유저 id를 통해 원하는 객체 찾기
        UserDAO userDAO = getUserDAOBean.exec(requestUserUpdateDTO.getUserId());
        if(userDAO == null) return null;

        // 객체 수정
        userDAO.setNickName(requestUserUpdateDTO.getNickname());
        userDAO.setUpdatedAt(LocalDateTime.now());

        // 수정한 객체 저장
        saveUserDAOBean.exec(userDAO);

        // 수정한 객체 키값 반환
        return userDAO.getUserId();
    }
}
