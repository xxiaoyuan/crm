package com.xypowernode.crm.workbench.dao;

import com.xypowernode.crm.workbench.entity.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationDao {


    int unbund(String id);

    int bund(ClueActivityRelation car);

    List<ClueActivityRelation> getListByClueId(String clueId);

    int delete(ClueActivityRelation clueActivityRelation);

    int getCountByCids(String[] ids);

    int deleteByCids(String[] ids);
}
