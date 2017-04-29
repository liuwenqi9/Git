<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/base/tag.jsp"%>
<%@ include file="/WEB-INF/jsp/base/common_js.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css"
	href="${baseurl}/jEasyUIcustom/uimaker/easyui.css">
<link rel="stylesheet" type="text/css"
	href="${baseurl}/jEasyUIcustom/uimaker/icon.css">
<link rel="stylesheet" type="text/css"
	href="${baseurl}css/skin_/table.css" />
<title>生产订单管理</title>
</head>
<body>
	<div id="main">
		<div class="table">
			<div class="opt ue-clear">
				 <span class="optarea"> <a href="javascript:addorders();"
					class="add"> <i class="icon"></i> <span class="text">添加</span>
				</a> 
				</span>
			</div>
		</div>
		<table id="ordersrlist"></table>

		<form id="ordersdeleteform"
			action="${baseurl}orders/deleteorders.action" method="post">
			<input type="hidden" id="delete_id" name="id" />
		</form>

		<!-- 订单分解操作 -->
		<form id="ordersdecomposeform"
			action="${baseurl}orders/decomposeorders.action" method="post">
			<input type="hidden" id="decompose_id" name="id" />
		</form>
</body>
<script type="text/javascript">
	//datagrid列定义
	var columns_v = [ [ {
		field : 'ordernum',//对应json中的key
		title : '订单编号',
		width : 120
	}, {
		field : 'ordercontract',//对应json中的key
		title : '合同编号 ',
		width : 120
	}, {
		field : 'cabinetnumber',//对应json中的key
		title : '生产数量',
		width : 60
	}, {
		field : 'btime',//对应json中的key
		title : '订单发起日期',
		width : 100
	}, {
		field : 'etime',//对应json中的key
		title : '交货日期',
		width : 100
	}, {
		field : 'loadcenter',//对应json中的key
		title : '客户名称',
		width : 120
	}, {
		field : 'cname',//对应json中的key
		title : '柜体类型',
		width : 120
	}, {
		field : 'remark',//对应json中的key
		title : '是否分解',
		width : 80
	},{
		field : 'opt3',
		title : '订单分解',
		width : 80,
		formatter : function(value, row, index) {
			return "<a href=javascript:decomposeorders('" + row.id + "')>订单分解</a>";
		}
	}, {
		field : 'opt2',
		title : '修改',
		width : 60,
		formatter : function(value, row, index) {
			return "<a href=javascript:editorders('" + row.id + "')>修改</a>";
		}
	}  ,{
		field : 'opt1',
		title : '删除',
		width : 60,
		formatter : function(value, row, index) {
			return "<a href=javascript:deleteorders('" + row.id + "')>删除</a>";
		}
	}] ];

	//datagrid 加载数据
	$(function() {
		$('#ordersrlist').datagrid({
			title : '订单',//数据列表标题
			nowrap : true,//单元格中的数据不换行，如果为true表示不换行，不换行情况下数据加载性能高，如果为false就是换行，换行数据加载性能不高
			striped : true,//条纹显示效果
			url : '${baseurl}orders/queryorders_result.action',//加载数据的连接，引连接请求过来是json数据
			idField : 'id',//此字段很重要，数据结果集的唯一约束(重要)，如果写错影响 获取当前选中行的方法执行
			loadMsg : '',
			columns : columns_v,
			pagination : true,//是否显示分页
			rownumbers : true,//是否显示行号
			pageList : [ 8, 15, 30 ],
		});
	});

	//查询方法
	function queryorders() {
		//datagrid的方法load方法要求传入json数据，最终将 json转成key/value数据传入action
		//将form表单数据提取出来，组成一个json
		var formdata = $("#ordersqueryForm").serializeJson();
		$('#ordersrlist').datagrid('load', formdata);
	}

	//删除订单方法
	function deleteorders(id) {
		//第一个参数是提示信息，第二个参数，取消执行的函数指针，第三个参是，确定执行的函数指针
		_confirm('您确认删除吗？', null,
				function() {

					//将要删除的id赋值给deleteid，deleteid在ordersdeleteform中
					$("#delete_id").val(id);
					//使用ajax的from提交执行删除
					//ordersdeleteform：form的id，ordersdecompose_callback：删除回调函数，
					//第三个参数是url的参数
					//第四个参数是datatype，表示服务器返回的类型
					jquerySubByFId('ordersdeleteform', ordersdecompose_callback, null,
							"json");
				});
	}
	//删除订单的回调
	function ordersdecompose_callback(data) {
		message_alert(data);
		//刷新 页面
		//在提交成功后重新加载 datagrid
		//取出提交结果
		var type = data.resultInfo.type;
		if (type == 1) {
			//成功结果
			//重新加载 datagrid
			queryorders();
		}
	}
	
	//分解订单方法
	function decomposeorders(id) {
		//第一个参数是提示信息，第二个参数，取消执行的函数指针，第三个参是，确定执行的函数指针
		_confirm('您确认分解订单吗？', null,
				function() {

					//将要删除的id赋值给deleteid，deleteid在ordersdeleteform中
					$("#decompose_id").val(id);
					//使用ajax的from提交执行删除
					//ordersdeleteform：form的id，ordersdecompose_callback：删除回调函数，
					//第三个参数是url的参数
					//第四个参数是datatype，表示服务器返回的类型
					jquerySubByFId('ordersdecomposeform', ordersdecompose_callback, null,
							"json");
				});
	}
	//分解订单的回调
	function ordersdecompose_callback(data) {
		message_alert(data);
		//刷新 页面
		//在提交成功后重新加载 datagrid
		//取出提交结果
		var type = data.resultInfo.type;
		if (type == 1) {
			//成功结果
			//重新加载 datagrid
			queryorders();
		}
	}
	
	//修改订单
	function editorders(id) {
		//打开修改窗口
		createmodalwindow("修改订单信息", 980, 380,
				'${baseurl}orders/editorders.action?id=' + id);
	}

	//添加订单
	function addorders(id) {
		//打开修改窗口
		createmodalwindow("添加订单", 980, 380,
				'${baseurl}orders/addorders.action?id=' + id);
	}
</script>

</html>