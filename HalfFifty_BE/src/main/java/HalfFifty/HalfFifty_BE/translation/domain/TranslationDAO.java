package HalfFifty.HalfFifty_BE.translation.domain;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
public class TranslationDAO {
    @Id @GeneratedValue(strategy = GenerationType.AUTO)
    UUID translationId;
    UUID userId;
    String translationWord;
    LocalDateTime createdAt;
}
