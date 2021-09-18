package com.xypowernode.crm.workbench.service;

import com.xypowernode.crm.vo.PaginationVo;
import com.xypowernode.crm.workbench.entity.Tran;
import com.xypowernode.crm.workbench.entity.TranHistory;

import java.util.List;
import java.util.Map;

public interface TranService {
    boolean save(Tran t, String customerName);

    Tran detail(String id);

    List<TranHistory> getHistoryListByTranId(String tranId);

    boolean changeStage(Tran t);

    Map<String, Object> getCharts();

    PaginationVo<Tran> tranList(Map<String, Object> map);

    Map<String, Object> getUserListAndTran(String id);

    boolean update(Tran t, String customerName);

    boolean delete(String[] ids);

}
