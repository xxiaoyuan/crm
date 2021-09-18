package com.xypowernode.crm.workbench.service.Impl;

import com.xypowernode.crm.utils.SqlSessionUtil;
import com.xypowernode.crm.workbench.dao.ContactsDao;
import com.xypowernode.crm.workbench.entity.Contacts;
import com.xypowernode.crm.workbench.service.ContactsService;

import java.util.List;

public class ContactsServiceImpl implements ContactsService {
    private ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);


    @Override
    public List<Contacts> getContactListByName(String cname) {
        List<Contacts> cList = contactsDao.getContactListByName(cname);
        return cList;
    }
}
