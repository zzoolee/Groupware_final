<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<style>
.text-button {
	background: none;
	border: none;
	color: inherit; /* 기본 텍스트 색상을 사용 */
	text-decoration: none;
	cursor: pointer;
	padding: 0; /* 선택적으로 내부 여백 제거 */
}
</style>

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>내업무현황</title>
<style type="text/css">
.commar {
	margin-top: 10px;
}
/* 구글 간트 차트 - 마우스 오버(?) 안 되게 처리 */
/* #chart_div { */
/* 	pointer-events: none; */
/* } */
g{
fill: '#000000'
}
</style>

<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script type="text/javascript">
// 구글 간트 차트
google.charts.load('current', { 'packages': ['gantt'] });
google.charts.setOnLoadCallback(drawChart);


function drawChart() {
  $.ajax({
    url: '/taskganttajax.do?taskCd=${taskVO.taskCd}',
    method: 'GET',
    dataType: 'json',
    success: function (taskdetList) {
    	console.log(taskdetList);
	      var data = new google.visualization.DataTable();
	      data.addColumn('string', 'Task ID');
	      data.addColumn('string', 'Task Name');
	      data.addColumn('string', 'Resource');
	      data.addColumn('date', 'Start Date');
	      data.addColumn('date', 'End Date');
	      data.addColumn('number', 'Duration');
	      data.addColumn('number', 'Percent Complete');
	      data.addColumn('string', 'Dependencies');

	      for (var i = 0; i < taskdetList.length; i++) {
	        var taskdet = taskdetList[i];
	        var percent = 0;
	        var status = '작업중';
	        if(taskdet.tdStatusse == 'y'){
	        	percent = 100;
	        	status = '완료';
	        }
	        data.addRows([
	          [taskdet.tdCd, (taskdet.tdEmpname + "/" + taskdet.tdContent), status, new Date(taskdet.tdStartdate), new Date(taskdet.tdClosedate), null, percent, null]
	        ]);
     	  }
	      
      var trackHeight = 30;
	      
      var options = {
         height: data.getNumberOfRows() * trackHeight + 50, // 높이 지정
         gantt: {
          trackHeight: trackHeight,
//           palette: [
//               {
//             	  "color": "#5c6bc0",
//             	    "dark": "#000000",
//             	    "light": "#c5cae9"
//               }
//             ]
        }
      };

      var chart = new google.visualization.Gantt(document.getElementById('chart_div'));

      chart.draw(data, options);
    },
    error: function (error) {
      console.error('Error: ' + error);
    }
  });
}

</script>

</head>

	<c:set var="ynCnt" value="0" />
	<c:set var="yCnt" value="0" />
	<c:set var="nCnt" value="0" />
	<c:forEach items="${taskdetList }" var="taskdet">
		<c:set var="ynCnt" value="${ynCnt + 1 }" />
		<c:if test="${taskdet.tdStatusse eq 'y'}">
			<c:set var="yCnt" value="${yCnt + 1 }" />
		</c:if>
		<c:if test="${taskdet.tdStatusse eq 'n'}">
			<c:set var="nCnt" value="${nCnt + 1 }" />
		</c:if>
	</c:forEach>

	<div class="container">
<%-- 		<button class="btn btn-secondary me-1 mb-1 uil-arrow-circle-left fs-1" type="button" onclick="location.href='/taskdetail.do?taskCd=${taskVO.taskCd }'"></button> --%>
		<h2 style="margin-bottom:20px;">
			<c:choose>
				<c:when test="${loginId eq 'admin'}">
					<a href="/adminTask.do">업무현황</a> >
					<a href="/taskdetail.do?taskCd=${taskVO.taskCd }">업무상세</a> > 세부업무 진행도
				</c:when>
				<c:otherwise>
					<a href="/task.do">내업무현황</a> > 
					<a href="/taskdetail.do?taskCd=${taskVO.taskCd }">업무상세</a> > 세부업무 진행도
				</c:otherwise>
			</c:choose>
		
		
<!-- 			<a href="/task.do">내업무현황</a> > -->
<%-- 			<a href="/taskdetail.do?taskCd=${taskVO.taskCd }">업무상세</a> > 세부업무 진행도 --%>
		</h2>
<!-- 		<h2 style="margin-top:20px;"> -->
<!-- 			내업무현황 > 업무상세 > 세부업무 진행도<span style="margin-right: 20px;"></span> -->
<!-- 		</h2> -->
		<br>
		<div class="container">
			<div class="row g-2">
				<div class="col-12 col-xl-12">
					<div class="card mb-3">
						<div class="card-body">
							<div class="row">
								<div class="col-6">
									<p style="font-size: 20px;">${taskVO.taskTitle }<span
											style="margin-right: 20px;"></span>
									</p>
								</div>
							</div>


							


							<%-- 		<span>ynCnt : ${ynCnt }, </span> <span>yCnt : ${yCnt }, </span> <span>nCnt --%>
							<%-- 			: ${nCnt }</span> --%>

			<div class="float">
			<div class="d-flex">
				<div class="col-4">
					<div class="progress" style="height: 15px; width: 500px;">

						<c:choose>
							<c:when test="${yCnt ne 0}">
								<c:set var="per" value="${yCnt * 100 / ynCnt}"></c:set>
								<fmt:formatNumber var="roundedPer" value="${per}" type="number"
									maxFractionDigits="0" />
								<div class="progress-bar bg-success" role="progressbar"
									style="width: ${roundedPer}%" aria-valuenow="${roundedPer}"
									aria-valuemin="0" aria-valuemax="100">${roundedPer}%</div>
							</c:when>

							<c:when test="${yCnt eq 0 }">
								<c:set var="per" value="${0}"></c:set>
								<div class="progress-bar bg-success" role="progressbar"
									style="width: 0%" aria-valuenow="0" aria-valuemin="0"
									aria-valuemax="100">${per }%</div>
							</c:when>
						</c:choose>
					</div>
				</div>
				<div style="margin: 0 auto;">
					<c:set var="startdate" value="${taskVO.taskStartdate}" />
					<c:set var="enddate" value="${taskVO.taskEnddate}" />
					<p>${fn:substring(startdate,0,10)}~
						${fn:substring(enddate,0,10)}</p>
				</div>
			</div>
		</div>

							<div class="float">
								<div class="d-flex">
									<div>
										<h4>업무 유형</h4>
									</div>
									<span style="width: 10px;"></span>
									<c:choose>
										<c:when test="${empty taskVO.taskType }">
											<p>업무 유형이 존재하지 않습니다.</p>
										</c:when>
										<c:otherwise>
											<p>${taskVO.taskType }</p>
										</c:otherwise>
									</c:choose>
								</div>
							</div>

							<div class="float">
								<div class="d-flex">
									<div>
										<h4>업무 내용</h4>
									</div>
									<span style="width: 10px;"></span>
									<c:choose>
										<c:when test="${empty taskVO.taskContent }">
											<p>업무 내용이 존재하지 않습니다.</p>
										</c:when>
										<c:otherwise>
											<p>${taskVO.taskContent }</p>
										</c:otherwise>
									</c:choose>
								</div>
							</div>

							<div class="float">
								<div class="d-flex">
									<div>
										<h4>비고</h4>
									</div>
									<span style="width: 10px;"></span>
									<c:choose>
										<c:when test="${empty taskVO.taskMemo }">
											<p>프로젝트 메모가 존재하지 않습니다.</p>
										</c:when>
										<c:otherwise>
											<p>${taskVO.taskMemo }</p>
										</c:otherwise>
									</c:choose>
								</div>
							</div>
							<p style="font-weight:bold;">
								<span class="text-danger" data-feather="check"></span>
								파란색으로 표시된 업무는 완료업무, 빨간색으로 표시된 업무는 작업중업무입니다.
							</p>
							<div id="chart_div"></div>
							
							<br>
							<br>

						</div>
					</div>
				</div>
			</div>
		</div>
		</div>
