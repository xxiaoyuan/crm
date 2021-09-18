package com.xypowernode.crm.workbench.dao;

import com.xypowernode.crm.workbench.entity.Contacts;

import java.util.List;

public interface ContactsDao {

    int save(Contacts con);

    List<Contacts> getContactListByName(String cname);
}
