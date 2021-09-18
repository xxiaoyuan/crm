package com.xypowernode.crm.workbench.dao;

import com.xypowernode.crm.workbench.entity.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {

    List<ClueRemark> getListByClueId(String clueId);

    int delete(ClueRemark clueRemark);

    int getCountByCids(String[] ids);

    int deleteByCids(String[] ids);

    List<ClueRemark> getRemarkListByCid(String clueId);

    int delete(String id);

    int updateRemark(ClueRemark ar);

    int saveRemark(ClueRemark ar);
}
