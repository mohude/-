<%@page import="com.henu.utils.DaoFactory"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.util.*,com.henu.bean.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="teacher_index.jsp"></jsp:include>
<link href="./css/bootstrap-datetimepicker.min.css" rel="stylesheet"
	media="screen">
<script type="text/javascript" src="./css/bootstrap-datetimepicker.js"
	charset="UTF-8"></script>
<title>考前操作</title>
</head>
<body style="background-image:url(../../image/background/h6.jpg);background-size:cover;">
	<%
		request.setCharacterEncoding("utf-8");
		String exam_start=(String)session.getAttribute("exam_start");
		if(exam_start!=null)
		{
			if(exam_start.equals("true"))
			{
				%>
				<script type="text/javascript">
					alert("开启考试成功");
				</script>
				<% 
				session.setAttribute("exam_start", null);
			}else{
				%>
				<script type="text/javascript">
					alert("当前有考试正在进行，开启考试失败");
				</script>
				<% 
			}
		}
		StringBuffer sb = new StringBuffer();
		//查询所有考试信息
		List<Exam> list=DaoFactory.getExamDaoInstance().search();
		for(Exam exam:list)
		{
			sb.append("<tr><td>");
			sb.append(exam.getE_name());
			sb.append("</td><td>");
			sb.append(exam.getE_starttime());
			sb.append("</td><td>");
			sb.append(exam.getE_teacher());
			sb.append("</td><td>");
			if (exam.getE_examination().equals("null"))
				sb.append("");
			else
				sb.append("<span class='glyphicon glyphicon-ok'></span>");
			sb.append("</td><td>");//glyphicon glyphicon-ok
			if (!exam.getE_autostart())
				sb.append("");
			else
				sb.append("<span class='glyphicon glyphicon-ok'></span>");
			sb.append("</td><td>");
			if (!exam.getE_isend())
				sb.append("");
			else
				sb.append("<span class='glyphicon glyphicon-ok'></span>");
			sb.append("</td><td>");
			if (!exam.getE_file())
				sb.append("");
			else
				sb.append("<span class='glyphicon glyphicon-ok'></span>");
			sb.append("</td><td>");
			if (!exam.getE_clear())
				sb.append("");
			else
				sb.append("<span class='glyphicon glyphicon-ok'></span>");
			sb.append("</td><td>");
			if(exam.getE_isstart())
			{
				sb.append("<span>考试已开启</span>");
			}else if(exam.getE_isend())
				sb.append("<span>考试已结束</span>");
			else
			{
				sb.append("<a href='teacher_addexam.jsp?examname="+exam.getE_name()+"' title='编辑考试信息' class='glyphicon glyphicon-edit'></a>");
				sb.append("&nbsp;&nbsp;&nbsp;&nbsp;<a href='../../teacher_clearexam?examname=" + exam.getE_name()
				+ "&id=2' title='清理考试'><span class='cancel_btn glyphicon glyphicon-trash' title='取消'></span></a>");
			}
			sb.append("</td></tr>");
		}
	%>
	<div class="container">
		<div class="alert navbar-inverse"
			style="background-color:#eeeeee ; margin-top: 10px">
			<strong style="margin-left: -7px; font-size: 18px">添加考试</strong>
			<form class="form-inline" role="form" action="../../teacher_addexam"
				style="margin-left: 0px; margin-top: 5px;" >
				<div class="form-group">
					<input type="text" class="examname" id="examname" name="examname" class="form-control"
						style="margin-left: 20px;width: 250px;height:32px;" placeholder="  考试名称*">
				</div>
				<div class="form-group">
					<div class="input-group date form_date"
						data-link-field="dtp_input2">
						<input type="text" class="form-control" name="exam_starttime"
							placeholder="考试时间*"> 
						<span class="input-group-addon">
							<i class="glyphicon glyphicon-remove "></i>
						</span> 
						<span class="input-group-addon"> 
							<i class="glyphicon glyphicon-calendar"></i>
						</span>
					</div>
				</div>

				<div class="checkbox">
					<label style="font-size: 15px"> <input type="checkbox"
						name="exam_autostart">自动开始
					</label>
				</div>
				<button class="btn btn-primary" type="submit">添加</button>
			</form>
		</div>
		<strong style="margin-left: 7px; font-size: 18px">已添加</strong>
		<table class="table table-bordered" style="margin-top: 10px;background-color:#eeeeee;">
			<tr>
				<th class="col-md-2">考试名称</th>
				<th class="col-md-2">考试时间</th>
				<th class="col-md-1">创建人</th>
				<th class="col-md-1">上传试卷</th>
				<th class="col-md-1">自动开始</th>
				<th class="col-md-1">已结束</th>
				<th class="col-md-1">已归档</th>
				<th class="col-md-1">已清理</th>
				<th class="col-md-1"></th>
			</tr>
			<%=sb.toString()%>
		</table>
	</div>

	<script type="text/javascript">
		$('.form_date').datetimepicker({
			format : 'yyyy-mm-dd hh:ii',
			weekStart : 1,
			todayBtn : 1,
			autoclose : 1,
			todayHighlight : 1,
			startView : 2,
			minView : 2,
			forceParse : 0,
			minView : 0,
			minuteStep : 10
		});
		$(".cancel_btn").click(function() {
			var b = confirm("确定取消该场考试?");

			if (b == true) {
				return true;
			} else {
				return false;
			}
		});
		//判断考试名称是否为空 及该名称是否已经存在
		function check_examname()
		{
			var examname=document.getElementById("examname");
			if(examname.value=="")
			{
				//document.getElementById("examname").innerHTML=("考试名称不能为空！");
				alert("考试名称不能为空哦！");
				return false;
				
				
			}
			$(".examname").each(function(){
			    if($(this).val()==$("#examname").val()){//判断是否相等
			        alert("该考试名称已存在！");
			        return false;//终止循环
			    }
			});
		};	
	</script>
</body>
</html>