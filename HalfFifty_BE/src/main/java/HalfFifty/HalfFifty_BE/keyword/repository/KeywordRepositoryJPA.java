package HalfFifty.HalfFifty_BE.keyword.repository;

import HalfFifty.HalfFifty_BE.keyword.domain.KeywordDAO;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface KeywordRepositoryJPA extends JpaRepository<KeywordDAO, UUID> {
    KeywordDAO findByUserIdAndKeywordId(UUID userId, UUID keywordId);

    // 유저 id를 통해 전체 키워드 객체들 조회
    List<KeywordDAO> findAllByUserId(UUID userId);
}
