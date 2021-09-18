package com.xypowernode.crm.workbench.service;

import com.xypowernode.crm.workbench.entity.Contacts;

import java.util.List;

public interface ContactsService {
    List<Contacts> getContactListByName(String cname);
}
