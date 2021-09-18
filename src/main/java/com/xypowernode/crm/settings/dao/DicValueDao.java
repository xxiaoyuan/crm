package com.xypowernode.crm.settings.dao;

import com.xypowernode.crm.settings.entity.DicValue;

import java.util.List;

public interface DicValueDao {
    List<DicValue> getListByCode(String code);
}
