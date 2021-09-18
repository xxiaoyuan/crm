<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
Map<String,String> pMap = (Map<String, String>) application.getAttribute("pMap");
Set<String> set = pMap.keySet();
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
	<script>
		//手动转为json串
		var json = {
			<%
				for (String key:set){
					String value = pMap.get(key);
			%>

			"<%=key%>" : <%=value%>,

			<%
				}
			%>
		};
		$(function () {
            //自动补全
			$("#edit-customerId").typeahead({
				source: function (query, process) {
					$.get(
							"workbench/transaction/getCustomerName.do",
							{ "name" : query },
							function (data) {
								//alert(data);
								process(data);
							},
							"json"
					);
				},
				delay: 1500
			});
            //时间选择器
            // $(".time1").datetimepicker({
            //     minView:"month",
            //     language:'zh-CN',
            //     format:"yyyy-mm-dd",
            //     autoclose:true,
            //     todayBtn:true,
            //     pickerPosition:"bottom-left"
            // });
            //时间选择器
            // $(".time2").datetimepicker({
            //     minView:"month",
            //     language:'zh-CN',
            //     format:"yyyy-mm-dd",
            //     autoclose:true,
            //     todayBtn:true,
            //     pickerPosition:"top-left"
            // });
			//为阶段的选中下拉框事件填写可能性
			$("#edit-Stage").change(function () {
				//取得选中的阶段
				var stage = $("#edit-Stage").val();
				//填写可能性 stage可变 以json[key]形式取值
				var possibility = json[stage];
				//为可能性的文本框赋值
				$("#edit-possibility").val(possibility);
			})

            //为更新按钮绑定事件，执行交易修改操作
            $("#updateBtn").click(function () {
                //发出传统请求提交表单
                $("#tranForm").submit();
            })
			//为 市场活动模态窗口中的 搜索框 绑定事件，触发回车查询，展现列表
			$("#aname").keydown(function (event) {
				//如果是回车键,默认强制刷新当前页面数据清空，需要禁用
				if (event.keyCode == 13) {
					$.ajax({
						url: "workbench/transaction/getActivityListByName.do",
						type: "get",
						data: {
							"aname": $.trim($("#aname").val()),
						},
						dataType: "json",
						success: function (data) {
							var html = "";
							$.each(data, function (i, n) {
								html += '<tr>';
								html += '<td><input type="radio" name="xz" value="' + n.id + '"/></td>';
								html += '<td id="a'+n.id+'">'+n.name+'</td>';
								html += '<td>'+n.startDate+'</td>';
								html += '<td>'+n.endDate+'</td>';
								html += '<td>'+n.owner+'</td>';
								html += '</tr>';
							})
							$("#activitySearchBody").html(html);
						}
					})
					//禁用默认的回车行为
					return false;
				}
			})
			//为市场活动源确定按钮绑定事件，执行市场活动源的赋值操作
			$("#subBtn2").click(function () {
				var id = $("input[name=xz]:checked").val();
				//赋值
				$("#edit-activitySrc").val($("#a"+id).html());
                $("input[name=activityId]").val(id);
				//清楚搜索框的信息，复选框中的选择，清空contactSearchBody中的内容
				$("#activitySearchBody").html("");
				//关闭模态窗口
				$("#findMarketActivity").modal("hide");
			})
			//为联系人模态窗口中的 搜索框 绑定事件，触发回车查询，展现列表
			$("#cname").keydown(function (event) {
				//如果是回车键,默认强制刷新当前页面数据清空，需要禁用
				if (event.keyCode == 13) {
					$.ajax({
						url: "workbench/transaction/getContactListByName.do",
						type: "get",
						data: {
							"cname": $.trim($("#cname").val()),
						},
						dataType: "json",
						success: function (data) {
							var html = "";
							$.each(data, function (i, n) {
								html += '<tr>';
								html += '<td><input type="radio" name="xz" value="' + n.id + '"/></td>';
								html += '<td id="f'+n.id+'">'+n.fullname+'</td>';
								html += '<td>'+n.email+'</td>';
								html += '<td>'+n.mphone+'</td>';
								html += '</tr>';
							})
							$("#contactSearchBody").html(html);
						}
					})
					//禁用默认的回车行为
					return false;
				}
			})
			//为联系人确定按钮绑定事件，联系人框的赋值操作
			$("#subBtn1").click(function () {
				var id = $("input[name=xz]:checked").val();
				//赋值
				$("#edit-contactsId").val($("#f"+id).html());
                $("input[name=contactsId]").val(id);
				//清楚搜索框的信息，复选框中的选择，清空contactSearchBody中的内容
				$("#contactSearchBody").html("");
				//关闭模态窗口
				$("#findContacts").modal("hide");
			})

		});
	</script>
</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="aname" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable4" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="activitySearchBody">
<%--							<tr>--%>
<%--								<td><input type="radio" name="activity"/></td>--%>
<%--								<td>发传单</td>--%>
<%--								<td>2020-10-10</td>--%>
<%--								<td>2020-10-20</td>--%>
<%--								<td>zhangsan</td>--%>
<%--							</tr>--%>
<%--							<tr>--%>
<%--								<td><input type="radio" name="activity"/></td>--%>
<%--								<td>发传单</td>--%>
<%--								<td>2020-10-10</td>--%>
<%--								<td>2020-10-20</td>--%>
<%--								<td>zhangsan</td>--%>
<%--							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="subBtn2">确定</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="cname" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody  id="contactSearchBody">

						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="subBtn1">确定</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>更新交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form action="workbench/transaction/update.do" class="form-horizontal" id="tranForm" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="edit-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-transactionOwner" name="owner">
					<option></option>
					<c:forEach items="${uList}" var="u">
						<option value="${u.id}" ${user.id eq u.id?"selected":""}>${u.name}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-money" value="${t.money}" name="money"/>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-name" value="${t.name}" name="name">
				<input type="hidden" name="id" value="${t.id}">
			</div>
			<label for="edit-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time1" id="edit-expectedDate" value="${t.expectedDate}" name="expectedDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-customerId" value="${t.customerId}" name="customerName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="edit-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="edit-Stage" name="stage">
				  <option></option>
				  <c:forEach items="${stageList}" var="s">
					  <option value="${s.value}" ${t.stage eq s.value?"selected":""}>${s.text}</option>
				  </c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-type" name="type">
					<option></option>
					<c:forEach items="${transactionTypeList}" var="tran">
						<option value="${tran.value}" ${t.type eq tran.value?"selected":""}>${tran.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-possibility" />
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-source" name="source">
					<option></option>
					<c:forEach items="${sourceList}" var="s">
						<option value="${s.value}" ${t.source eq s.value?"selected":""}>${s.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findMarketActivity"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-activitySrc" value="${t.activityName}"/>
                <input type="hidden" name="activityId" value="${t.activityId}"/>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findContacts"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-contactsId" value="${t.contactsName}"/>
                <input type="hidden" name="contactsId" value="${t.contactsId}"/>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="edit-description" name="description">${t.description}</textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="edit-contactSummary" name="contactSummary">${t.contactSummary}</textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time2" id="edit-nextContactTime" name="nextContactTime" value="${t.nextContactTime}">
			</div>
		</div>
		
	</form>
</body>
</html>