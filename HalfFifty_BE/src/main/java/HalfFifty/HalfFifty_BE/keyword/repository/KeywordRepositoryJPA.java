package HalfFifty.HalfFifty_BE.keyword.repository;

import HalfFifty.HalfFifty_BE.keyword.domain.KeywordDAO;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface KeywordRepositoryJPA extends JpaRepository<KeywordDAO, UUID> {
}
