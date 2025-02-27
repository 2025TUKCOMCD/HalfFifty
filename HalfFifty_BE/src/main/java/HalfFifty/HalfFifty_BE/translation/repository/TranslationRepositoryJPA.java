package HalfFifty.HalfFifty_BE.translation.repository;

import HalfFifty.HalfFifty_BE.translation.domain.TranslationDAO;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface TranslationRepositoryJPA extends JpaRepository<TranslationDAO, UUID> {

    // translationId와 userId를 통해 원하는 객체 찾음
    TranslationDAO findByTranslationIdAndUserId(UUID translationId, UUID userId);
}
