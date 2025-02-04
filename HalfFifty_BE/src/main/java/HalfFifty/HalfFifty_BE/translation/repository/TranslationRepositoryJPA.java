package HalfFifty.HalfFifty_BE.translation.repository;

import HalfFifty.HalfFifty_BE.translation.domain.TranslationDAO;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface TranslationRepositoryJPA extends JpaRepository<TranslationDAO, UUID> {
}
