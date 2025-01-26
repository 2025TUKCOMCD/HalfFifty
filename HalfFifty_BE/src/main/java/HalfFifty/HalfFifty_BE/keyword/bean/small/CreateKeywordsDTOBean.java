package HalfFifty.HalfFifty_BE.keyword.bean.small;

import HalfFifty.HalfFifty_BE.keyword.domain.DTO.ResponseKeywordGetDTO;
import HalfFifty.HalfFifty_BE.keyword.domain.KeywordDAO;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class CreateKeywordsDTOBean {

    // 키워드 객체 리스트를 DTO 리스트로 변환
    public List<ResponseKeywordGetDTO> exec(List<KeywordDAO> keywordDAOS) {
        // 키워드 객체들을 담아줄 DTO 리스트 생성
        List<ResponseKeywordGetDTO> responseKeywordGetDTOS = new ArrayList<>();

        // for문을 통해 각 객체를 DTO 리스트에 저장
        for (KeywordDAO keywordDAO : keywordDAOS) {
            ResponseKeywordGetDTO responseKeywordGetDTO = ResponseKeywordGetDTO.builder()
                    .keywordId(keywordDAO.getKeywordId())
                    .keyword(keywordDAO.getKeyword())
                    .build();

            responseKeywordGetDTOS.add(responseKeywordGetDTO);
        }

        // DTO 리스트 반환
        return  responseKeywordGetDTOS;
    }
}
