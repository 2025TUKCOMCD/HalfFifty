package HalfFifty.HalfFifty_BE.user.bean;

import HalfFifty.HalfFifty_BE.user.bean.small.CreateUserDTOBean;
import HalfFifty.HalfFifty_BE.user.bean.small.GetUserDAOBean;
import HalfFifty.HalfFifty_BE.user.domain.DTO.ResponseUserGetDTO;
import HalfFifty.HalfFifty_BE.user.domain.UserDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.UUID;

@Component
public class GetUserBean {
    CreateUserDTOBean createUserDTOBean;
    GetUserDAOBean getUserDAOBean;

    @Autowired
    public GetUserBean(CreateUserDTOBean createUserDTOBean, GetUserDAOBean getUserDAOBean) {
        this.createUserDTOBean = createUserDTOBean;
        this.getUserDAOBean = getUserDAOBean;
    }

    public ResponseUserGetDTO exec(UUID userId) {
        // 유저 id를 통해 원하는 객체 찾기
        UserDAO userDAO = getUserDAOBean.exec(userId);
        if(userDAO == null) return null;

        // 객체를 DTO로 변환해서 반환
        return createUserDTOBean.exec(userDAO);
    }
}
