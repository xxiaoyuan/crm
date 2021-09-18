package com.xypowernode.crm.workbench.service.Impl;

import com.xypowernode.crm.settings.dao.UserDao;
import com.xypowernode.crm.settings.entity.User;
import com.xypowernode.crm.utils.DateTimeUtil;
import com.xypowernode.crm.utils.SqlSessionUtil;
import com.xypowernode.crm.utils.UUIDUtil;
import com.xypowernode.crm.vo.PaginationVo;
import com.xypowernode.crm.workbench.dao.CustomerDao;
import com.xypowernode.crm.workbench.dao.TranDao;
import com.xypowernode.crm.workbench.dao.TranHistoryDao;
import com.xypowernode.crm.workbench.entity.ClueRemark;
import com.xypowernode.crm.workbench.entity.Customer;
import com.xypowernode.crm.workbench.entity.Tran;
import com.xypowernode.crm.workbench.entity.TranHistory;
import com.xypowernode.crm.workbench.service.TranService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TranServiceImpl implements TranService {
    private TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    private TranHistoryDao tranHistoryDao = SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);
    private CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
    @Override
    public boolean save(Tran t, String customerName) {
        //交易添加业务
        boolean flag = true;
        //判断customerName，将客户id封装到t对象中
        Customer cus = customerDao.getCustomerByName(customerName);
        if (cus==null){
            cus = new Customer();
            cus.setId(UUIDUtil.getUUID());
            cus.setName(customerName);
            cus.setCreateBy(t.getCreateBy());
            cus.setCreateTime(DateTimeUtil.getSysTime());
            cus.setContactSummary(t.getContactSummary());
            cus.setNextContactTime(t.getNextContactTime());
            cus.setOwner(t.getOwner());
           //添加客户
            int count1 = customerDao.save(cus);
            if (count1!=1){
                flag = false;
            }
        }
        //将客户id封装到t对象
        t.setCustomerId(cus.getId());
        //添加交易
        int count2 = tranDao.save(t);
        if (count2!=1){
            flag = false;
        }

        //添加交易历史
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setTranId(t.getId());
        th.setStage(t.getStage());
        th.setMoney(t.getMoney());
        th.setExpectedDate(t.getExpectedDate());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setCreateBy(t.getCreateBy());
        int count3 = tranHistoryDao.save(th);
        if (count3!=1){
            flag = false;
        }
        return flag;
    }

    @Override
    public Tran detail(String id) {
        Tran t = tranDao.detail(id);
        return t;
    }

    @Override
    public List<TranHistory> getHistoryListByTranId(String tranId) {
        List<TranHistory> thList = tranHistoryDao.getHistoryListByTranId(tranId);
        return thList;
    }

    @Override
    public boolean changeStage(Tran t) {
        boolean flag = true;
        //改变交易阶段
        int count1 = tranDao.changeStage(t);
        if (count1!=1){
            flag = false;
        }
        //交易阶段改变后，生成交易历史记录
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setCreateBy(t.getEditBy());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setExpectedDate(t.getExpectedDate());
        th.setMoney(t.getMoney());
        th.setTranId(t.getId());

        th.setStage(t.getStage());
        //添加交易历史
        int count2 = tranHistoryDao.save(th);
        if (count2!=1){
            flag = false;
        }
        return flag;
    }

    @Override
    public Map<String, Object> getCharts() {
        //取得total
        int total = tranDao.getTotal();
        //取得dataList
        List<Map<String,Object>> dataList = tranDao.getCharts();
        //保存到map中
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("total",total);
        map.put("dataList",dataList);
        return map;
    }

    @Override
    public PaginationVo<Tran> tranList(Map<String, Object> map) {
        //取得total
        int total = tranDao.getTotalByCondition(map);
        //取得datalist
        List<Tran> dataList =  tranDao.getTranListByCondition(map);
        //将total和dataList封装到vo中
        PaginationVo<Tran> vo = new PaginationVo<Tran>();
        vo.setTotal(total);
        vo.setDataList(dataList);
        //将vo返回
        return vo;
    }

    @Override
    public Map<String, Object> getUserListAndTran(String id) {
        //取uList
        List<User> uList = userDao.getUserList();
        //取t
        Tran t = tranDao.getTranById(id);
        //将uList和t打包到map中
        Map<String,Object> map = new HashMap<String,Object>();
        map.put("uList",uList);
        map.put("t",t);
        return map;
    }

    @Override
    public boolean update(Tran t, String customerName) {

        //交易添加业务
        boolean flag = true;
        //判断customerName，将客户id封装到t对象中
        Customer cus = customerDao.getCustomerByName(customerName);
        if (cus==null){
            cus = new Customer();
            cus.setId(UUIDUtil.getUUID());
            cus.setName(customerName);
            cus.setCreateBy(t.getCreateBy());
            cus.setCreateTime(DateTimeUtil.getSysTime());
            cus.setContactSummary(t.getContactSummary());
            cus.setNextContactTime(t.getNextContactTime());
            cus.setOwner(t.getOwner());
            //添加客户
            int count1 = customerDao.save(cus);
            if (count1!=1){
                flag = false;
            }
        }
        //将客户id封装到t对象
        t.setCustomerId(cus.getId());
        //添加交易
        int count2 = tranDao.update(t);
        if (count2!=1){
            flag = false;
        }

        //添加交易历史
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setTranId(t.getId());
        th.setStage(t.getStage());
        th.setMoney(t.getMoney());
        th.setExpectedDate(t.getExpectedDate());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setCreateBy(t.getCreateBy());
        int count3 = tranHistoryDao.save(th);
        if (count3!=1){
            flag = false;
        }
        return flag;
    }

    @Override
    public boolean delete(String[] ids) {
        boolean flag = true;

        //删除市场活动表的数据
        int count = tranDao.delete(ids);
        if (count!=ids.length){
            flag = false;
        }
        return flag;
    }




}
