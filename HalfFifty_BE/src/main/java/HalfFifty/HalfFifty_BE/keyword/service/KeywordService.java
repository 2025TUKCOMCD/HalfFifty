package HalfFifty.HalfFifty_BE.keyword.service;

import HalfFifty.HalfFifty_BE.keyword.bean.SaveKeywordBean;
import HalfFifty.HalfFifty_BE.keyword.domain.DTO.RequestKeywordSaveDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class KeywordService {
    SaveKeywordBean saveKeywordBean;

    @Autowired
    public KeywordService(SaveKeywordBean saveKeywordBean) {
        this.saveKeywordBean = saveKeywordBean;
    }

    // 키워드 등록 API
    public UUID saveKeyword(RequestKeywordSaveDTO requestKeywordSaveDTO) {
        return saveKeywordBean.exec(requestKeywordSaveDTO);
    }
}
