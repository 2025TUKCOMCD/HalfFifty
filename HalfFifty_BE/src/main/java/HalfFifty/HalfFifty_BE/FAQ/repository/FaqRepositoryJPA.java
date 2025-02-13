package HalfFifty.HalfFifty_BE.FAQ.repository;

import HalfFifty.HalfFifty_BE.FAQ.domain.FaqDAO;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface FaqRepositoryJPA extends JpaRepository<FaqDAO, UUID> {
}
