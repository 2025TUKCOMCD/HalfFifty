package HalfFifty.HalfFifty_BE.user.domain;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserDAO {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    UUID userId;
    String username;
    String appleId;
    String password;
    String nickName;
    String phoneNumber;
    LocalDateTime createdAt;
    LocalDateTime updatedAt;
}
