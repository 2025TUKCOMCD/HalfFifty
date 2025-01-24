package HalfFifty.HalfFifty_BE.user.repository;

import HalfFifty.HalfFifty_BE.user.domain.UserDAO;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface UserRepositoryJPA extends JpaRepository<UserDAO, UUID> {
}
