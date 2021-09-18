package com.xypowernode.crm.workbench.dao;

import com.xypowernode.crm.workbench.entity.TranHistory;

import java.util.List;

public interface TranHistoryDao {

    int save(TranHistory th);

    List<TranHistory> getHistoryListByTranId(String tranId);
}
