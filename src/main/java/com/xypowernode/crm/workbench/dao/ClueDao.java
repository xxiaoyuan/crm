package com.xypowernode.crm.workbench.dao;


import com.xypowernode.crm.workbench.entity.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {


    int getTotalByCondition(Map<String, Object> map);

    int save(Clue c);

    Clue detail(String id);

    Clue getById(String clueId);

    int delete(String clueId);

    List<Clue> getClueListByCondition(Map<String, Object> map);

    int update(Clue c);


    int deleteIds(String[] ids);
}
