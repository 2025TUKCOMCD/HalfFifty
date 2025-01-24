package HalfFifty.HalfFifty_BE.keyword.service;

import HalfFifty.HalfFifty_BE.keyword.bean.SaveKeywordBean;
import HalfFifty.HalfFifty_BE.keyword.bean.UpdateKeywordBean;
import HalfFifty.HalfFifty_BE.keyword.domain.DTO.RequestKeyWordUpdateDTO;
import HalfFifty.HalfFifty_BE.keyword.domain.DTO.RequestKeywordSaveDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class KeywordService {
    SaveKeywordBean saveKeywordBean;
    UpdateKeywordBean updateKeywordBean;

    @Autowired
    public KeywordService(SaveKeywordBean saveKeywordBean, UpdateKeywordBean updateKeywordBean) {
        this.saveKeywordBean = saveKeywordBean;
        this.updateKeywordBean = updateKeywordBean;
    }

    // 키워드 등록 API
    public UUID saveKeyword(RequestKeywordSaveDTO requestKeywordSaveDTO) {
        return saveKeywordBean.exec(requestKeywordSaveDTO);
    }

    // 키워드 수정 API
    public UUID updateKeyword(RequestKeyWordUpdateDTO requestKeyWordUpdateDTO) {
        return updateKeywordBean.exec(requestKeyWordUpdateDTO);
    }
}
