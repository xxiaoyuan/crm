package com.xypowernode.crm.settings.web.controller;


import com.xypowernode.crm.settings.entity.User;
import com.xypowernode.crm.settings.service.Impl.UserServiceImpl;
import com.xypowernode.crm.settings.service.UserService;
import com.xypowernode.crm.utils.MD5Util;
import com.xypowernode.crm.utils.PrintJson;
import com.xypowernode.crm.utils.ServiceFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

//import javax.servlet.ServletException;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;



public class UserController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入用户控制器");
        String path = request.getServletPath();
        if("/settings/user/login.do".equals(path)){
            login(request,response);
        }else if("/settings/user/xxx.do".equals(path)){

        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到验证登录操作");
        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");
        //将密码的明文形式转换为MD5的密文形式
        loginPwd = MD5Util.getMD5(loginPwd);
        //接受ip地址
        String ip = request.getRemoteAddr();
        System.out.println("-------------ip"+ip);

        //业务层开发，使用代理类形态的接口对象
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        try {
            //如果没有抛出异常，表示登录成功
            User user = us.login(loginAct,loginPwd,ip);
            request.getSession().setAttribute("user",user);
            PrintJson.printJsonFlag(response,true);
        }catch (Exception e){
            e.printStackTrace();
            String msg = e.getMessage();
            /*
            * controller需要为ajax请求提供多项信息
            * 1、多项信息打包为map，将map解析为json串
            * 2、创建一个vo value object
            * 如果展现的信息将来会大量使用，选择vo
            * 如果展现的信息只有在这个需求中，则用map临时处理就行
            * */
            Map<String,Object> map = new HashMap<String,Object>();
            map.put("success",false);
            map.put("msg",msg);
            PrintJson.printJsonObj(response,map);
        }
    }
}
