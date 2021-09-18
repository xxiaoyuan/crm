package com.xypowernode.crm.web.filter;


import com.xypowernode.crm.settings.entity.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;


public class LoginFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("登录器过滤器初始化");
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {
        System.out.println("进入验证有没有登录过的过滤器");

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;

        String path = request.getServletPath();
        if("/login.jsp".equals(path)||"/settings/user/login.do".equals(path)){
            chain.doFilter(req,resp);
        }else {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            //如果user不为null，说明登录过
            if (user!=null){
                chain.doFilter(req,resp);
            }else {
                /**
                 * 转发的路径使用内部路径   /login.jsp
                 * 重定向的路径,使用绝对路径 /crmtest/login.jsp
                 * 为什么使用重定向?
                 * 转发之后路径会停留在老路径上
                 */

                //${pageContext.request.contextPath}//项目名
                response.sendRedirect(request.getContextPath()+"/login.jsp");
            }
        }


    }

    @Override
    public void destroy() {
        System.out.println("登录器过滤器销毁");
    }
}
