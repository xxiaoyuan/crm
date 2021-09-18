package com.xypowernode.crm.settings.service;


import com.xypowernode.crm.exception.LoginException;
import com.xypowernode.crm.settings.entity.User;

import java.util.List;

public interface UserService {

    User login(String loginAct, String loginPwd, String ip) throws LoginException;

    List<User> getUserList();
}
