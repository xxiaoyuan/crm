package com.xypowernode.crm.workbench.dao;

import com.xypowernode.crm.workbench.entity.Customer;

import java.util.List;

public interface CustomerDao {

    Customer getCustomerByName(String company);

    int save(Customer cus);


    List<String> getCustomerName(String name);
}
