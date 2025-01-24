package HalfFifty.HalfFifty_BE.user.bean;

import HalfFifty.HalfFifty_BE.user.bean.small.CreateUserDAOBean;
import HalfFifty.HalfFifty_BE.user.bean.small.SaveUserDAOBean;
import HalfFifty.HalfFifty_BE.user.domain.DTO.RequestUserSaveDTO;
import HalfFifty.HalfFifty_BE.user.domain.UserDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.UUID;

@Component
public class SaveUserBean {
    CreateUserDAOBean createUserDAOBean;
    SaveUserDAOBean saveUserDAOBean;

    @Autowired
    public SaveUserBean(CreateUserDAOBean createUserDAOBean, SaveUserDAOBean saveUserDAOBean) {
        this.createUserDAOBean = createUserDAOBean;
        this.saveUserDAOBean = saveUserDAOBean;
    }

    // 유저 회원가입(임시)
    public UUID exec(RequestUserSaveDTO requestUserSaveDTO) {
        // 유저 객체(DAO) 생성
        UserDAO userDAO = createUserDAOBean.exec(requestUserSaveDTO);
        if(userDAO == null) return null;

        // 생성된 객체값 DB에 저장
        saveUserDAOBean.exec(userDAO);

        // pk값 반환
        return userDAO.getUserId();
    }
}
