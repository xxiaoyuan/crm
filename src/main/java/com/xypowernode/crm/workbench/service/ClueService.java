package com.xypowernode.crm.workbench.service;

import com.xypowernode.crm.vo.PaginationVo;
import com.xypowernode.crm.workbench.entity.Clue;
import com.xypowernode.crm.workbench.entity.ClueRemark;
import com.xypowernode.crm.workbench.entity.Tran;

import java.util.List;
import java.util.Map;

public interface ClueService {
    boolean save(Clue c);

    Clue detail(String id);

    boolean unbund(String id);

    boolean bund(String cid, String[] aids);

    boolean convert(String clueId, Tran t, String createBy);

    PaginationVo<Clue> clueList(Map<String, Object> map);

    Map<String, Object> getUserListAndClue(String id);

    boolean update(Clue c);

    boolean delete(String[] ids);

    List<ClueRemark> getRemarkListByCid(String clueId);


    boolean deleteRemark(String id);

    boolean updateRemark(ClueRemark ar);

    boolean saveRemark(ClueRemark ar);
}
