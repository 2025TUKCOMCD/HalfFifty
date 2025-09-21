package HalfFifty.HalfFifty_BE;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class HalfFiftyBeApplication {

	public static void main(String[] args) {
		SpringApplication.run(HalfFiftyBeApplication.class, args);
	}

}
