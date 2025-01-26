package HalfFifty.HalfFifty_BE.keyword.service;

import HalfFifty.HalfFifty_BE.keyword.bean.DeleteKeywordBean;
import HalfFifty.HalfFifty_BE.keyword.bean.SaveKeywordBean;
import HalfFifty.HalfFifty_BE.keyword.bean.UpdateKeywordBean;
import HalfFifty.HalfFifty_BE.keyword.domain.DTO.RequestKeyWordUpdateDTO;
import HalfFifty.HalfFifty_BE.keyword.domain.DTO.RequestKeywordDeleteDTO;
import HalfFifty.HalfFifty_BE.keyword.domain.DTO.RequestKeywordSaveDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class KeywordService {
    SaveKeywordBean saveKeywordBean;
    UpdateKeywordBean updateKeywordBean;
    DeleteKeywordBean deleteKeywordBean;

    @Autowired
    public KeywordService(SaveKeywordBean saveKeywordBean, UpdateKeywordBean updateKeywordBean, DeleteKeywordBean deleteKeywordBean) {
        this.saveKeywordBean = saveKeywordBean;
        this.updateKeywordBean = updateKeywordBean;
        this.deleteKeywordBean = deleteKeywordBean;
    }

    // 키워드 등록 API
    public UUID saveKeyword(RequestKeywordSaveDTO requestKeywordSaveDTO) {
        return saveKeywordBean.exec(requestKeywordSaveDTO);
    }

    // 키워드 수정 API
    public UUID updateKeyword(RequestKeyWordUpdateDTO requestKeyWordUpdateDTO) {
        return updateKeywordBean.exec(requestKeyWordUpdateDTO);
    }

    // 키워드 삭제 API
    public Boolean deleteKeyword(RequestKeywordDeleteDTO requestKeywordDeleteDTO) {
        return deleteKeywordBean.exec(requestKeywordDeleteDTO);
    }
}
