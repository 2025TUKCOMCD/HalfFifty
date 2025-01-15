package HalfFifty.HalfFifty_BE;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthCheck {

    @GetMapping("/")
    public String health() {
        return "server on!!!";
    }
}
