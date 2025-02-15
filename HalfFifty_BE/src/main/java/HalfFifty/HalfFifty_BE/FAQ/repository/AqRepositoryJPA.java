package HalfFifty.HalfFifty_BE.FAQ.repository;

import HalfFifty.HalfFifty_BE.FAQ.domain.AqDAO;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface AqRepositoryJPA extends JpaRepository<AqDAO, UUID> {
}
