package HalfFifty.HalfFifty_BE.FAQ.domain;

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
public class AqDAO {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    UUID aqId;
    UUID userId;
    String question;
    String answer;
    Boolean isAnswer;
    LocalDateTime questionCreatedAt;
    LocalDateTime answerCreatedAt;
}
