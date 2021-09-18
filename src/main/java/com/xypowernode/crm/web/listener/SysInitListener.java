package com.xypowernode.crm.web.listener;

import com.xypowernode.crm.settings.entity.DicValue;
import com.xypowernode.crm.settings.service.DicService;
import com.xypowernode.crm.settings.service.Impl.DicServiceImpl;
import com.xypowernode.crm.utils.ServiceFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

public class SysInitListener implements ServletContextListener {
    /**
     * 该方法用来监听上下文域对象
     * @param event 取得监听的对象
     */
    @Override
    public void contextInitialized(ServletContextEvent event) {
        System.out.println("监听器启动");
        System.out.println("服务器缓存处理数据字典开始");
        ServletContext application = event.getServletContext();
        //取得数据字典
        DicService ds = (DicService)ServiceFactory.getService(new DicServiceImpl());
        Map<String, List<DicValue>> map = ds.getAll();
        //解析为上文域对象中的键值对
        Set<String> set =  map.keySet();
        for (String key:set){
            application.setAttribute(key,map.get(key));
        }
        System.out.println("服务器缓存处理数据字典结束");
        System.out.println("加载Stage2Possibility.properties文件");
        //处理Stage2Possibility.properties文件
        Map<String,String> pMap = new HashMap<String,String>();
        ResourceBundle rb = ResourceBundle.getBundle("Stage2Possibility");
        Enumeration<String> e = rb.getKeys();
        while (e.hasMoreElements()){
            //阶段
            String key = e.nextElement();
            //可能性
            String value = rb.getString(key);
            pMap.put(key,value);
        }
        //将pMap保存到服务器缓存中
        application.setAttribute("pMap",pMap);
        System.out.println("加载完毕");
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {
        System.out.println("监听器销毁");
    }
}
