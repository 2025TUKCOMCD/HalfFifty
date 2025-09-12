package HalfFifty.HalfFifty_BE.translation.bean;

import HalfFifty.HalfFifty_BE.translation.domain.DTO.FrameBufferResult;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;
import java.util.stream.Collectors;

@Component
public class FrameBufferBean {
    private final Map<UUID, BufferData> userFrameBuffers = new ConcurrentHashMap<>();
    private final int BUFFER_SIZE = 5;
    private final int REQUIRED_MATCHES = 3;
    private final int TIMEOUT_MINUTES = 10; // 10분 후 자동 삭제

    // 버퍼 데이터와 타임스탬프를 함께 저장하는 내부 클래스
    private static class BufferData {
        List<String> buffer;
        LocalDateTime lastAccess;

        BufferData() {
            this.buffer = new ArrayList<>();
            this.lastAccess = LocalDateTime.now();
        }

        void updateAccess() {
            this.lastAccess = LocalDateTime.now();
        }
    }

    public FrameBufferResult addFrame(UUID userId, String predictedWord) {
        if (userId == null || predictedWord == null || predictedWord.trim().isEmpty()) {
            return new FrameBufferResult(false, null, 0, BUFFER_SIZE);
        }

        BufferData bufferData = userFrameBuffers.computeIfAbsent(userId, k -> new BufferData());
        bufferData.updateAccess(); // 접근 시간 갱신

        List<String> buffer = bufferData.buffer;
        buffer.add(predictedWord.trim());

        // 버퍼 크기 제한
        if (buffer.size() > BUFFER_SIZE) {
            buffer.remove(0);
        }

        // 다수결 확인
        if (buffer.size() >= BUFFER_SIZE) {
            return checkMajority(buffer, userId);
        }

        return new FrameBufferResult(false, null, buffer.size(), BUFFER_SIZE);
    }

    private FrameBufferResult checkMajority(List<String> buffer, UUID userId) {
        try {
            Map<String, Long> wordCounts = buffer.stream()
                    .filter(Objects::nonNull)
                    .filter(word -> !word.trim().isEmpty())
                    .collect(Collectors.groupingBy(Function.identity(), Collectors.counting()));

            Optional<Map.Entry<String, Long>> mostFrequent = wordCounts.entrySet().stream()
                    .max(Map.Entry.comparingByValue());

            if (mostFrequent.isPresent() && mostFrequent.get().getValue() >= REQUIRED_MATCHES) {
                // 확정되면 해당 사용자의 버퍼 초기화
                clearBuffer(userId);
                return new FrameBufferResult(true, mostFrequent.get().getKey(), BUFFER_SIZE, BUFFER_SIZE);
            }

            return new FrameBufferResult(false, null, buffer.size(), BUFFER_SIZE);

        } catch (Exception e) {
            System.err.println("Error in checkMajority: " + e.getMessage());
            return new FrameBufferResult(false, null, buffer.size(), BUFFER_SIZE);
        }
    }

    public void clearBuffer(UUID userId) {
        if (userId != null) {
            userFrameBuffers.remove(userId);
        }
    }

    public List<String> getBuffer(UUID userId) {
        if (userId == null) {
            return new ArrayList<>();
        }
        BufferData bufferData = userFrameBuffers.get(userId);
        return bufferData != null ? new ArrayList<>(bufferData.buffer) : new ArrayList<>();
    }

    // 메모리 누수 방지: 10분마다 오래된 버퍼 자동 삭제
    @Scheduled(fixedRate = 600000) // 10분마다 실행
    public void cleanupOldBuffers() {
        LocalDateTime cutoffTime = LocalDateTime.now().minusMinutes(TIMEOUT_MINUTES);

        Iterator<Map.Entry<UUID, BufferData>> iterator = userFrameBuffers.entrySet().iterator();
        int removedCount = 0;

        while (iterator.hasNext()) {
            Map.Entry<UUID, BufferData> entry = iterator.next();
            if (entry.getValue().lastAccess.isBefore(cutoffTime)) {
                iterator.remove();
                removedCount++;
            }
        }

        if (removedCount > 0) {
            System.out.println("정리된 비활성 버퍼 개수: " + removedCount);
        }

        System.out.println("현재 활성 버퍼 개수: " + userFrameBuffers.size());
    }
}