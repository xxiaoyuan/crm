package com.xypowernode.crm.workbench.service.Impl;

import com.xypowernode.crm.utils.SqlSessionUtil;
import com.xypowernode.crm.workbench.dao.CustomerDao;
import com.xypowernode.crm.workbench.service.CustomerService;

import java.util.List;

public class CustomerServiceImpl implements CustomerService {
    private CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);

    @Override
    public List<String> getCustomerName(String name) {
        List<String> sList = customerDao.getCustomerName(name);
        return sList;
    }
}
