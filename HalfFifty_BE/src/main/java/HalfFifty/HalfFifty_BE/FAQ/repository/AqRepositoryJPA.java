package HalfFifty.HalfFifty_BE.FAQ.repository;

import HalfFifty.HalfFifty_BE.FAQ.domain.AqDAO;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface AqRepositoryJPA extends JpaRepository<AqDAO, UUID> {

    // user 아이디를 통해 원하는 객체 리스트 찾기
    List<AqDAO> findAllByUserId(UUID userId);

    // AQ 아이디와 user 아이디를 통해 원하는 객체 찾기
    AqDAO findByAqIdAndUserId(UUID aqId, UUID userId);
}
