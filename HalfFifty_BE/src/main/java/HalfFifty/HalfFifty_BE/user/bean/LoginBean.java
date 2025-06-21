package HalfFifty.HalfFifty_BE.user.bean;

import HalfFifty.HalfFifty_BE.user.bean.small.GetUserDAOBean;
import HalfFifty.HalfFifty_BE.user.domain.DTO.RequestUserLoginDTO;
import HalfFifty.HalfFifty_BE.user.domain.UserDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.UUID;

@Component
public class LoginBean {
    GetUserDAOBean getUserDAOBean;

    @Autowired
    public LoginBean(GetUserDAOBean getUserDAOBean) {
        this.getUserDAOBean = getUserDAOBean;
    }

    public UUID exec(RequestUserLoginDTO requestUserLoginDTO) {
        // id와 password로 객체 찾기
        System.out.println("requestUserLoginDTO = " + requestUserLoginDTO.getAppleId());
        System.out.println("requestUserLoginDTO = " + requestUserLoginDTO.getPassword());
        UserDAO userDAO = getUserDAOBean.exec(requestUserLoginDTO.getAppleId(), requestUserLoginDTO.getPassword());
        if (userDAO == null) return null;

        // 찾은 객체의 키값 반환
        return userDAO.getUserId();
    }
}
