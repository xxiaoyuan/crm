<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function () {
            $(".time").datetimepicker({
                minView:"month",
                language:'zh-CN',
                format:"yyyy-mm-dd",
                autoclose:true,
                todayBtn:true,
                pickerPosition:"top-left"
            });

            $("#remark").focus(function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function () {
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });

            $(".remarkDiv").mouseover(function () {
                $(this).children("div").children("div").show();
            });

            $(".remarkDiv").mouseout(function () {
                $(this).children("div").children("div").hide();
            });

            $(".myHref").mouseover(function () {
                $(this).children("span").css("color", "red");
            });

            $(".myHref").mouseout(function () {
                $(this).children("span").css("color", "#E6E6E6");
            });
            //页面加载完毕后，取出关联的市场活动信息列表
            showActivityList();
            //页面加载结束后，刷新关联的备注信息列表
            showRemarkList();

            //为关联市场活动模态窗口中的 搜索框 绑定事件，触发回车查询，展现列表
            $("#aname").keydown(function (event) {
                //如果是回车键,默认强制刷新当前页面数据清空，需要禁用
                if (event.keyCode == 13) {
                    $.ajax({
                        url: "workbench/clue/getActivityListByNameAndNotByClueId.do",
                        type: "get",
                        data: {
                            "aname": $.trim($("#aname").val()),
                            "clueId": "${c.id}"
                        },
                        dataType: "json",
                        success: function (data) {
                            var html = "";
                            $.each(data, function (i, n) {
                                html += '<tr>';
                                html += '<td><input type="checkbox" name="xz" value="' + n.id + '"/></td>';
                                html += '<td>' + n.name + '</td>';
                                html += '<td>' + n.startDate + '</td>';
                                html += '<td>' + n.endDate + '</td>';
                                html += '<td>' + n.owner + '</td>';
                                html += '</tr>';
                            })
                            $("#activitySearchBody").html(html);
                        }
                    })
                    //禁用默认的回车行为
                    return false;
                }
            })
            //为关联按钮绑定事件，执行关联表的添加操作
            $("#bundBtn").click(function () {
                var $xz = $("input[name=xz]:checked");
                if ($xz.length == 0) {
                    alert("请选择需要关联的市场活动");
                } else {
                    var param = "cid=${c.id}&";
                    for (var i = 0; i < $xz.length; i++) {
                        param += "aid=" + $($xz[i]).val();
                        if (i < $xz.length - 1) {
                            param += "&";
                        }
                    }
                    $.ajax({
                        url: "workbench/clue/bund.do",
                        type: "post",
                        data: param,
                        dataType: "json",
                        success: function (data) {
                            if (data.success) {
                                //刷新关联市场活动列表
                                showActivityList();
                                //清楚搜索框的信息，复选框中的选择，清空activitySearchBody中的内容
                                $("#activitySearchBody").html("");
                                //关闭模态窗口
                                $("#bundModal").modal("hide");
                            } else {
                                alert("关联市场活动失败");
                            }
                        }
                    })
                }
            })
            //为备注更新按钮绑定事件
            $("#updateRemarkBtn").click(function () {

                var id = $("#remarkId").val();
                $.ajax({
                    url:"workbench/clue/updateRemark.do",
                    type:"post",
                    data:{
                        "id":id,
                        "noteContent":$.trim($("#noteContent").val())
                    },
                    dataType:"json",
                    success:function (data) {
                        if (data.success){
                            $("#e"+id).html(data.ar.noteContent);
                            $("#s"+id).html(data.ar.editTime+" 由"+data.ar.editBy);
                            //关闭模态窗口
                            $("#editRemarkModal").modal("hide");
                        }else {
                            alert("更新备注失败");
                        }
                    }
                })
            })
            $("#saveRemarkBtn").click(function () {
                $.ajax({
                    url:"workbench/clue/saveRemark.do",
                    type:"post",
                    data:{
                        "noteContent":$.trim($("#remark").val()),
                        "clueId":"${c.id}"
                    },
                    dataType:"json",
                    success:function (data) {
                        if (data.success){
                            //文本域中的信息清空掉
                            $("#remark").val("");

                            var html = "";
                            html += '<div id="'+data.ar.id+'" class="remarkDiv" style="height: 60px;">';
                            html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                            html += '<div style="position: relative; top: -40px; left: 40px;" >';
                            html += '<h5 id="e'+data.ar.id+'">'+data.ar.noteContent+'</h5>';
                            html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${c.fullname}${c.appellation}-${c.company}</b> <small style="color: gray;"> '+data.ar.createTime+' 由'+data.ar.createBy+'</small> <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px;">';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+data.ar.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
                            html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+data.ar.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
                            html += '</div>';
                            html += '</div>';
                            html += '</div>';
                            $("#remarkDiv").before(html);

                        }else {
                            alert("添加备注失败");
                        }
                    }
                })
            })


            //为编辑按钮绑定事件
            $("#editBtn").click(function () {
                //时间选择器
                $(".time").datetimepicker({
                    minView:"month",
                    language:'zh-CN',
                    format:"yyyy-mm-dd",
                    autoclose:true,
                    todayBtn:true,
                    pickerPosition:"bottom-left"
                });

                $.ajax({
                    url:"workbench/clue/getUserListAndClue.do",
                    type:"get",
                    data:{
                        "id":"${c.id}"
                    },
                    dataType:"json",
                    success:function (data) {
                        //处理所有者下拉框
                        var html ="<option></option>";
                        $.each(data.uList,function (i,n) {
                            html += "<option value='"+n.id+"'>"+n.name+"</option>";
                        })
                        $("#edit-owner").html(html);

                        //处理单条记录
                        $("#edit-id").val(data.c.id);
                        $("#edit-fullname").val(data.c.fullname);
                        $("#edit-owner").val(data.c.owner);
                        $("#edit-appellation").val(data.c.appellation);
                        $("#edit-company").val(data.c.company);
                        $("#edit-job").val(data.c.job);
                        $("#edit-email").val(data.c.email);
                        $("#edit-phone").val(data.c.phone);
                        $("#edit-website").val(data.c.website);
                        $("#edit-mphone").val(data.c.mphone);
                        $("#edit-state").val(data.c.state);
                        $("#edit-source").val(data.c.source);
                        $("#edit-contactSummary").val(data.c.contactSummary);
                        $("#edit-nextContactTime").val(data.c.nextContactTime);
                        $("#edit-address").val(data.c.address);
                        $("#edit-description").val(data.c.description);

                        //打开修改操作模态窗口
                        $("#editClueModal").modal("show");
                    }
                })

            })
            //为更新按钮绑定事件
            $("#updateBtn").click(function () {
                $.ajax({
                    url:"workbench/clue/update.do",
                    type: "post",
                    data:{
                        "id":$.trim($("#edit-id").val()),
                        "fullname" : $.trim($("#edit-fullname").val()),
                        "appellation" : $.trim($("#edit-appellation").val()),
                        "owner" : $.trim($("#edit-owner").val()),
                        "company" : $.trim($("#edit-company").val()),
                        "job" : $.trim($("#edit-job").val()),
                        "email" : $.trim($("#edit-email").val()),
                        "phone" : $.trim($("#edit-phone").val()),
                        "website" : $.trim($("#edit-website").val()),
                        "mphone" : $.trim($("#edit-mphone").val()),
                        "state" : $.trim($("#edit-state").val()),
                        "source" : $.trim($("#edit-source").val()),
                        "description" : $.trim($("#edit-description").val()),
                        "contactSummary" : $.trim($("#edit-contactSummary").val()),
                        "nextContactTime" : $.trim($("#edit-nextContactTime").val()),
                        "address" : $.trim($("#edit-address").val())
                    },
                    dataType: "json",
                    success:function (data) {
                        if(data.success){
                            //关闭添加操作的模态窗口
                            $("#editClueModal").modal("hide");
                            //返回市场活动列表
                            window.location.href="workbench/clue/index.jsp";
                        }else{
                            alert("修改线索列表失败");
                        }
                    }
                })
            })

            //为删除按钮绑定事件
            $("#deleteBtn").click(function () {
                if (confirm("确实删除所选择的记录吗？")) {
                    $.ajax({
                        url: "workbench/clue/delete.do",
                        type: "post",
                        data: {
                            "id":"${c.id}"
                        },
                        dataType: "json",
                        success: function (data) {
                            if (data.success) {
                                //返回市场活动列表
                                window.location.href="workbench/clue/index.jsp";
                            } else {
                                alert("删除线索列表失败");
                            }
                        }
                    })
                }
            })

        });

        function showActivityList() {
            $.ajax({
                url: "workbench/clue/getActivityListByClueId.do",
                type: "get",
                data: {
                    "clueId": "${c.id}"
                },
                dataType: "json",
                success: function (data) {
                    var html = "";
                    $.each(data, function (i, n) {
                        html += '<tr>';
                        html += '<td>' + n.name + '</td>';
                        html += '<td>' + n.startDate + '</td>';
                        html += '<td>' + n.endDate + '</td>';
                        html += '<td>' + n.owner + '</td>';
                        html += '<td><a href="javascript:void(0);" onclick="unbund(\'' + n.id + '\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
                        html += '</tr>';
                    })
                    $("#activityBody").html(html);
                }
            })
        }

        function unbund(id) {
            $.ajax({
                url: "workbench/clue/unbund.do",
                type: "post",
                data: {
                    "id": id
                },
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        //刷新关联的市场活动列表
                        showActivityList();
                    } else {
                        alert("解除关联失败");
                    }
                }
            })
        }

        function showRemarkList() {
            $.ajax({
                url: "workbench/clue/getRemarkListByCid.do",
                type: "get",
                data: {
                    "clueId": "${c.id}",
                },
                dataType: "json",
                success: function (data) {
                    var html = "";
                    $.each(data, function (i, n) {
                        html += '<div id="'+n.id+'" class="remarkDiv" style="height: 60px;">';
                        html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                        html += '<div style="position: relative; top: -40px; left: 40px;" >';
                        html += '<h5 id="e'+n.id+'">'+n.noteContent+'</h5>';
                        html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${c.fullname}${c.appellation}-${c.company}</b> <small style="color: gray;" id="s'+n.id+'"> '+(n.editFlag==0?n.createTime:n.editTime)+' 由'+(n.editFlag==0?n.createBy:n.editBy)+'</small> <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px;">';
                        html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
                        html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                        html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
                        html += '</div>';
                        html += '</div>';
                        html += '</div>';
                    })
                    $("#remarkDiv").before(html);
                }
            })
        }

        function deleteRemark(id) {
            $.ajax({
                url: "workbench/clue/deleteRemark.do",
                type: "post",
                data: {
                    "id": id
                },
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        // showRemarkList();记录使用的是before方法，每次删除会保存原有的数据
                        //找到需要删除记录的div
                        $("#" + id).remove();
                    } else {
                        alert("删除备注失败");
                    }
                }
            })
        }

        function editRemark(id) {
            //将模态窗口中，隐藏域的id进行赋值
            $("#remarkId").val(id);
            //找到指定的存放备注信息的h5标签
            var noteContent = $("#e" + id).html();
            //将h5展现的信息，赋予到修改窗口的文本域中
            $("#noteContent").val(noteContent);

            $("#editRemarkModal").modal("show");
        }
    </script>

</head>
<body>
<!-- 修改市场活动备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden" id="remarkId">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
            </div>
        </div>
    </div>
</div>
<!-- 关联市场活动的模态窗口 -->
<div class="modal fade" id="bundModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">关联市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" id="aname" style="width: 300px;"
                                   placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td><input type="checkbox"/></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody id="activitySearchBody">

                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="bundBtn">关联</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改线索的模态窗口 -->
<div class="modal fade" id="editClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <%--当前记录的id --%>
                    <input type="hidden" id="edit-id"/>
                    <div class="form-group">
                        <label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">

                            </select>
                        </div>
                        <label for="edit-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-company"/>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-appellation">
                                <option></option>
                                <c:forEach items="${appellationList}" var="a">
                                    <option value="${a.value}">${a.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-fullname"/>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job" />
                        </div>
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email" />
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone"/>
                        </div>
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website"/>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone" />
                        </div>
                        <label for="edit-status" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-state">
                                <option></option>
                                <c:forEach items="${clueStateList}" var="c">
                                    <option value="${c.value}">${c.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
                                <option></option>
                                <c:forEach items="${sourceList}" var="s">
                                    <option value="${s.value}">${s.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-nextContactTime" />
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>${c.fullname}${c.appellation} <small>${c.company}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default"
                onclick="window.location.href='workbench/clue/convert.jsp?id=${c.id}&fullname=${c.fullname}&appellation=${c.appellation}&company=${c.company}&owner=${c.owner}';">
            <span class="glyphicon glyphicon-retweet"></span> 转换
        </button>
        <button type="button" class="btn btn-default" id="editBtn"><span
                class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
    </div>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.fullname}${c.appellation}</b>
        </div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${c.owner}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">公司</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.company}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${c.job}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">邮箱</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.email}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${c.phone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">公司网站</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.website}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${c.mphone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">线索状态</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.state}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${c.source}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${c.createBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${c.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${c.editBy}&nbsp;&nbsp;</b><small
                style="font-size: 10px; color: gray;">${c.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${c.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${c.contactSummary}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.nextContactTime}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 100px;">
        <div style="width: 300px; color: gray;">详细地址</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${c.address}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div id="remarkBody" style="position: relative; top: 40px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <%--		<!-- 备注1 -->--%>
    <%--		<div class="remarkDiv" style="height: 60px;">--%>
    <%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
    <%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
    <%--				<h5>哎呦！</h5>--%>
    <%--				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>--%>
    <%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
    <%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
    <%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
    <%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
    <%--				</div>--%>
    <%--			</div>--%>
    <%--		</div>--%>

    <%--		<!-- 备注2 -->--%>
    <%--		<div class="remarkDiv" style="height: 60px;">--%>
    <%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
    <%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
    <%--				<h5>呵呵！</h5>--%>
    <%--				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>--%>
    <%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
    <%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
    <%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
    <%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
    <%--				</div>--%>
    <%--			</div>--%>
    <%--		</div>--%>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" id="saveRemarkBtn" class="btn btn-primary">保存</button>
            </p>
        </form>
    </div>
</div>

<!-- 市场活动 -->
<div>
    <div style="position: relative; top: 60px; left: 40px;">
        <div class="page-header">
            <h4>市场活动</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>所有者</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="activityBody">
                <%--						<tr>--%>
                <%--							<td>发传单</td>--%>
                <%--							<td>2020-10-10</td>--%>
                <%--							<td>2020-10-20</td>--%>
                <%--							<td>zhangsan</td>--%>
                <%--							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>--%>
                <%--						</tr>--%>
                <%--						<tr>--%>
                <%--							<td>发传单</td>--%>
                <%--							<td>2020-10-10</td>--%>
                <%--							<td>2020-10-20</td>--%>
                <%--							<td>zhangsan</td>--%>
                <%--							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>--%>
                <%--						</tr>--%>
                </tbody>
            </table>
        </div>

        <div>
            <a href="javascript:void(0);" data-toggle="modal" data-target="#bundModal"
               style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
        </div>
    </div>
</div>


<div style="height: 200px;"></div>
</body>
</html>