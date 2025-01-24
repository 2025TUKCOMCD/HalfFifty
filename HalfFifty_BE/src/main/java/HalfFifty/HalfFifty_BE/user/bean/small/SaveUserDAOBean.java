package HalfFifty.HalfFifty_BE.user.bean.small;

import HalfFifty.HalfFifty_BE.user.domain.UserDAO;
import HalfFifty.HalfFifty_BE.user.repository.UserRepositoryJPA;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class SaveUserDAOBean {
    UserRepositoryJPA userRepositoryJPA;

    @Autowired
    public SaveUserDAOBean(UserRepositoryJPA userRepositoryJPA) {
        this.userRepositoryJPA = userRepositoryJPA;
    }

    // 유저 정보 저장(임시)
    public void exec(UserDAO userDAO) {
        userRepositoryJPA.save(userDAO);
    }
}
