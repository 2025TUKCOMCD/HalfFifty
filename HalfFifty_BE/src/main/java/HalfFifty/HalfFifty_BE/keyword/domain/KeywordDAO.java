package HalfFifty.HalfFifty_BE.keyword.domain;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class KeywordDAO {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    UUID keywordId;
    UUID userId;
    String keyword;
    LocalDateTime createdAt;
    LocalDateTime updatedAt;
}
