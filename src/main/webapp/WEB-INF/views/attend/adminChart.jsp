
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.4.0/Chart.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<h2>직원관리 > 근태차트</h2>
<p>
	<span class="text-danger" data-feather="check"></span>
	근태현황을 차트로 확인 가능합니다.
</p>

<div class="card mt-7" style="border-radius:20px; padding:20px;">
	
	<div class="row pb-9">
		<div class="col-6 h-auto">
			<div class="card px-3 bg-light" style="height:400px;">
				<div class="row">
					<div class="col-12 pt-2">
						<span class="fw-bold fs-1">금일 업무현황/근무유형</span>
					</div>
					<div class="col-6" id="chartDiv11">
						<canvas id="chart11" style="width:100%; height:400px;">
						</canvas>
					</div>
					<div class="col-6" id="chartDiv12">
						<canvas id="chart12" style="width:100%; height:400px;">
						</canvas>
					</div>
				</div>
			</div>
		</div>
		
		<div class="col-6 h-auto">
			<div class="card px-3 bg-light" style="height:400px;">
				<div class="row">
					<div class="col-6 pt-2">
						<span class="fw-bold fs-1">당해 프로젝트 현황</span>
					</div>
					<div class="col-3 pt-2">
					</div>
					<div class="col-3 pt-2">
					</div>
					<div class="col-12" id="chart21">
						<canvas id="chart2" style="width:100%; height:340px;">
						</canvas>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<div class="row">
		<div class="col-6 h-auto">
			<div class="card px-3 bg-light" style="height:400px;">
				<div class="row">
					<div class="col-6 pt-2">
						<span class="fw-bold fs-1">전사/부서별 연장근무 현황</span>
					</div>
					<div class="col-3 pt-2">
						<select class="form-select form-select-sm mb-3"
							data-list-filter="data-list-filter" id="chart3select1">
							<c:forEach items="${chartMap.yearList}" var="year">
								<fmt:formatDate value="${year.atDate }" pattern="YYYY" var="date"/>
								<option value="${date }">${date }</option>
							</c:forEach>
						</select>
					</div>
					<div class="col-3 pt-2">
						<select class="form-select form-select-sm mb-3"
							data-list-filter="data-list-filter" id="chart3select2">
							<option selected="" value="전체">부서전체조회</option>
							<option value="경영지원팀">경영지원팀</option>
							<option value="인사총무팀">인사총무팀</option>
							<option value="구매조달팀">구매조달팀</option>
							<option value="콜센터">콜센터</option>
							<option value="시스템영업팀">시스템영업팀</option>
							<option value="공공영업팀">공공영업팀</option>
							<option value="기술지원팀">기술지원팀</option>
							<option value="교육운영팀">교육운영팀</option>
							<option value="보안개발팀">보안개발팀</option>
							<option value="개발팀">SW개발팀</option>
							<option value="사업기획팀">사업기획팀</option>
							<option value="SM영업1팀">SM영업1팀</option>
							<option value="SM영업2팀">SM영업2팀</option>
							<option value="서비스센터">서비스센터</option>
							<option value="수도권">수도권</option>
							<option value="중부권">중부권</option>
							<option value="서부권">서부권</option>
							<option value="동부권">동부권</option>
							<option value="연구개발본부">연구개발본부</option>
						</select>
					</div>
					<div class="col-12" id="chartDiv3">
						
					</div>
				</div>
			</div>
		</div>
		
		<div class="col-6 h-auto">
			<div class="card px-3 bg-light" style="height:400px;">
				<div class="row">
					<div class="col-6 pt-2">
						<span class="fw-bold fs-1">전사/부서별 사용연차 현황</span>
					</div>
					<div class="col-3 pt-2">
						<select class="form-select form-select-sm mb-3"
							data-list-filter="data-list-filter" id="chart4select1">
							<c:forEach items="${chartMap.yearList}" var="year">
								<fmt:formatDate value="${year.atDate }" pattern="YYYY" var="date"/>
								<option value="${date }">${date }</option>
							</c:forEach>
						</select>
					</div>
					<div class="col-3 pt-2">
						<select class="form-select form-select-sm mb-3"
							data-list-filter="data-list-filter" id="chart4select2">
							<option selected="" value="전체">부서전체조회</option>
							<option value="경영지원팀">경영지원팀</option>
							<option value="인사총무팀">인사총무팀</option>
							<option value="구매조달팀">구매조달팀</option>
							<option value="콜센터">콜센터</option>
							<option value="시스템영업팀">시스템영업팀</option>
							<option value="공공영업팀">공공영업팀</option>
							<option value="기술지원팀">기술지원팀</option>
							<option value="교육운영팀">교육운영팀</option>
							<option value="보안개발팀">보안개발팀</option>
							<option value="개발팀">SW개발팀</option>
							<option value="사업기획팀">사업기획팀</option>
							<option value="SM영업1팀">SM영업1팀</option>
							<option value="SM영업2팀">SM영업2팀</option>
							<option value="서비스센터">서비스센터</option>
							<option value="수도권">수도권</option>
							<option value="중부권">중부권</option>
							<option value="서부권">서부권</option>
							<option value="동부권">동부권</option>
							<option value="연구개발본부">연구개발본부</option>
						</select>
					</div>
					<div class="col-12" id="chartDiv4">
					
					</div>
				</div>
			</div>
		</div>
	</div>

</div>

<br>

<!-- 미리보기를 띄워줄 모달 -->
<div class="modal fade" id="attendModal" tabindex="-1"
	aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="verticallyCenteredModalLabel">사원 근태 상세보기</h5>
				<button class="btn p-1" type="button" data-bs-dismiss="modal"
					aria-label="Close">
					<span class="fas fa-times fs--1"></span>
				</button>
			</div>
			<div
				class="modal-body d-flex justify-content-center align-items-center">
				<form action="/ayannUpdate.do" method="POST" id="ayannForm">
					<div class="row" >
						<form action="" method="" id="">
							<table class="table table-striped">
								<thead>
									<tr>
										<th scope="col" class="text-center">날짜</th>
										<th scope="col" class="text-center">사번</th>
										<th scope="col" class="text-center">이름</th>
										<th scope="col" class="text-center">출근</th>
										<th scope="col" class="text-center">퇴근</th>
										<th scope="col" class="text-center">연장</th>
										<th scope="col" class="text-center">유형</th>
										<th scope="col" class="text-center">결과</th>
										<th scope="col" class="text-center">주차</th>
									</tr>
								</thead>
								<tbody id="dataDiv">
									<!-- 데이터 들어갈곳. -->
								</tbody>
							</table>
						</form>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button class="btn btn-info downloadFileBtn" type="button"
					id="excelDownBtn">엑셀다운로드</button>
				<button class="btn btn-danger" type="button" data-bs-dismiss="modal"
					id="modalFileCancleBtn">취소</button>
			</div>
		</div>
	</div>
</div>


<input type="hidden" id="empCount" value="${chartMap.empCount}">
<input type="hidden" id="workCount" value="${chartMap.workCount}">
<input type="hidden" id="basic" value="${chartMap.basic}">
<input type="hidden" id="yuyeonA" value="${chartMap.yuyeonA}">
<input type="hidden" id="yuyeonB" value="${chartMap.yuyeonB}">
<input type="hidden" id="atHome" value="${chartMap.atHome}">

<input type="hidden" value = "${ajaxMap.start.jan }" id="startJan"/>
<input type="hidden" value = "${ajaxMap.start.fab }" id="startFab"/>
<input type="hidden" value = "${ajaxMap.start.mar }" id="startMar"/>
<input type="hidden" value = "${ajaxMap.start.apr }" id="startApr"/>
<input type="hidden" value = "${ajaxMap.start.may }" id="startMay"/>
<input type="hidden" value = "${ajaxMap.start.jun }" id="startJun"/>
<input type="hidden" value = "${ajaxMap.start.jul }" id="startJul"/>
<input type="hidden" value = "${ajaxMap.start.aug }" id="startAug"/>
<input type="hidden" value = "${ajaxMap.start.sep }" id="startSep"/>
<input type="hidden" value = "${ajaxMap.start.oct }" id="startOct"/>
<input type="hidden" value = "${ajaxMap.start.nov }" id="startNov"/>
<input type="hidden" value = "${ajaxMap.start.dec }" id="startDec"/>
<input type="hidden" value = "${ajaxMap.end.jan }" id="endJan"/>
<input type="hidden" value = "${ajaxMap.end.fab }" id="endFab"/>
<input type="hidden" value = "${ajaxMap.end.mar }" id="endMar"/>
<input type="hidden" value = "${ajaxMap.end.apr }" id="endApr"/>
<input type="hidden" value = "${ajaxMap.end.may }" id="endMay"/>
<input type="hidden" value = "${ajaxMap.end.jun }" id="endJun"/>
<input type="hidden" value = "${ajaxMap.end.jul }" id="endJul"/>
<input type="hidden" value = "${ajaxMap.end.aug }" id="endAug"/>
<input type="hidden" value = "${ajaxMap.end.sep }" id="endSep"/>
<input type="hidden" value = "${ajaxMap.end.oct }" id="endOct"/>
<input type="hidden" value = "${ajaxMap.end.nov }" id="endNov"/>
<input type="hidden" value = "${ajaxMap.end.dec }" id="endDec"/>


<script type="text/javascript">
$(function(){
	
	// 오늘 출근인원중 근무유형 비율
	$(document).ready(function () {
		console.log($('#basic').val());
	    const data = {
	        labels: [
	            '기본근무',
	            '유연근무 A형',
	            '유연근무 B형',
	            '재택근무'
	        ],
	        datasets: [{
	            label: '유형근무 (단위 : 명)',
	            data: [$('#basic').val(), $('#yuyeonA').val(), $('#yuyeonB').val(), $('#atHome').val()],
	            backgroundColor: [
	            	'rgb(255, 205, 86)',
	                'rgb(214, 212, 109)',
	                'rgb(255, 99, 132)',
	                'rgb(54, 162, 235)'
	            ],
	            hoverOffset: 4
	        }]
	    };

	    const config = {
	        type: 'doughnut',
	        data: data,
	    };
		function chart1(){
	   		let ctx = document.getElementById('chart11').getContext('2d');
	    	let chart = new Chart(ctx, config);
		}
		
		chart1();
	});
	
	
	// 전체비율중 출근인원비율
	$(document).ready(function () {
		console.log($('#basic').val());
	    const data = {
	        labels: [
	            '출근인원',
	            '전체사원',
	        ],
	        datasets: [{
	            label: '출근상태 (단위 : 명)',
	            data: [$('#workCount').val(), $('#empCount').val()],
	            backgroundColor: [
	                'rgb(255, 99, 132)',
	                'rgb(54, 162, 235)',
	            ],
	            hoverOffset: 4
	        }]
	    };

	    const config = {
	        type: 'doughnut',
	        data: data,
	    };
		function chart1(){
	   		let ctx = document.getElementById('chart12').getContext('2d');
	    	let chart = new Chart(ctx, config);
		}
		
		chart1();
	});
	
	
	$(document).ready(function () {
	var startChart = [];
	var endChart = [];
	
	startChart.push($('#startJan').val());
	startChart.push($('#startFav').val());
	startChart.push($('#startMar').val());
	startChart.push($('#startApr').val());
	startChart.push($('#startMay').val());
	startChart.push($('#startJun').val());
	startChart.push($('#startJul').val());
	startChart.push($('#startAug').val());
	startChart.push($('#startSep').val());
	startChart.push($('#startOct').val());
	startChart.push($('#startNov').val());
	startChart.push($('#startDec').val());
	
	endChart.push($('#endJan').val());
	endChart.push($('#endFav').val());
	endChart.push($('#endMar').val());
	endChart.push($('#endApr').val());
	endChart.push($('#endMay').val());
	endChart.push($('#endJun').val());
	endChart.push($('#endJul').val());
	endChart.push($('#endAug').val());
	endChart.push($('#endSep').val());
	endChart.push($('#endOct').val());
	endChart.push($('#endNov').val());
	endChart.push($('#endDec').val());
	
	console.log('스타트 차트 : '+startChart);
	console.log('엔드 차트 : '+endChart);
	
		var chartData = {
			    labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
			    datasets: [
			        {
			            label: '발생 시작프로젝트',
			            yAxisID: 'y-left',
			            data: startChart,
			            backgroundColor: [
			                'rgba(255, 15, 15, 0.2)',
			            ],
			            borderColor: [
			                'rgba(230, 0, 0, 1)',
			            ],
			            borderWidth: 1
			        },
			        {
			            label: '발생 완료프로젝트',
			            yAxisID: 'y-left',
			            data: endChart,
			            backgroundColor: [
			                'rgba(15, 99, 255, 0.2)',
			            ],
			            borderColor: [
			                'rgba(0, 83, 250, 1)',
			            ],
			            borderWidth: 1
			        }
			    ]
			};

			var chartOptions = {
			    responsive: true,
			    scales: {
			        x: {
			            title: {
			                display: true,
			                text: '(단위 : 월)'
			            }
			        },
			        'y-left': {
			            type: 'linear',
			            position: 'left',
			            title: {
			                display: true,
			                text: '연장근무시간 (단위 : 시간)'
			            },
			            ticks: {
			                beginAtZero: true,
			                min: 0,
			                max: 10,
			                stepSize: 2
			            },
			            grid: {
			                display: false
			            }
			        }
			    }
			};

			function chart2(){
			    let ctx = document.getElementById('chart2').getContext('2d');
			    let chart = new Chart(ctx, {
			        type: 'bar',
			        data: chartData,
			        options: chartOptions
			    });
			};
			
			chart2();
	});
	
	
	
	// 연장근무차트 셀렉트1.
	$(document).on('change', '#chart3select1', function() {
		var year = $('#chart3select1').val();
		var dep = $('#chart3select2').val();
		console.log(year);
		console.log(dep);
		var data = {
			year : 	year,
			dep : dep
		}
		var chartDiv = $('#chartDiv3');
		chartDiv.html('');
		chartDiv.html('<canvas id="chart3" style="width:100%; height:330px;"></canvas>');
		var monthData = [];
		$.ajax({
			type : "POST",
			url : "/chart3select1Ajax.do",
			data : JSON.stringify(data),
            contentType : "application/json; charset=utf-8",
			success : function(result) {
				monthData.push(result.chartRes.jan);
				monthData.push(result.chartRes.feb);
				monthData.push(result.chartRes.mar);
				monthData.push(result.chartRes.apr);
				monthData.push(result.chartRes.may);
				monthData.push(result.chartRes.jun);
				monthData.push(result.chartRes.jul);
				monthData.push(result.chartRes.aug);
				monthData.push(result.chartRes.sep);
				monthData.push(result.chartRes.oct);
				monthData.push(result.chartRes.nov);
				monthData.push(result.chartRes.dec);
				
				
				if(dep == '전체') {
					
					var chartData = {
						    labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
						    datasets: [
						        {
						            label: dep+'팀 연장근무',
						            yAxisID: 'y-left',
						            data: monthData,
						            backgroundColor: [
						                'rgba(255, 99, 132, 0.2)',
						            ],
						            borderColor: [
						                'rgba(255, 99, 132, 1)',
						            ],
						            borderWidth: 1
						        },
						    ]
						};

						var chartOptions = {
						    responsive: true,
						    scales: {
						        x: {
						            title: {
						                display: true,
						                text: '(단위 : 월)'
						            }
						        },
						        'y-left': {
						            type: 'linear',
						            position: 'left',
						            title: {
						                display: true,
						                text: '연장근무시간 (단위 : 시간)'
						            },
						            ticks: {
						                beginAtZero: true,
						                min: 0,
						                max: 10,
						                stepSize: 2
						            },
						            grid: {
						                display: false
						            }
						        }
						    }
						};

						$(function(){
						    let ctx = document.getElementById('chart3').getContext('2d');
						    let chart = new Chart(ctx, {
						        type: 'bar',
						        data: chartData,
						        options: chartOptions
						    });
						});
					
				} else {
					
					var chartData = {
						    labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
						    datasets: [
						        {
						            label: dep+' 연장근무',
						            yAxisID: 'y-left',
						            data: monthData,
						            backgroundColor: [
						                'rgba(255, 99, 132, 0.2)',
						            ],
						            borderColor: [
						                'rgba(255, 99, 132, 1)',
						            ],
						            borderWidth: 1
						        },
						    ]
						};

						var chartOptions = {
						    responsive: true,
						    scales: {
						        x: {
						            title: {
						                display: true,
						                text: '(단위 : 월)'
						            }
						        },
						        'y-left': {
						            type: 'linear',
						            position: 'left',
						            title: {
						                display: true,
						                text: '근무시간 (단위 : 시간)'
						            },
						            ticks: {
						                beginAtZero: true,
						                min: 0,
						                max: 10,
						                stepSize: 2
						            },
						            grid: {
						                display: false
						            }
						        }
						    }
						};

						$(function(){
						    let ctx = document.getElementById('chart3').getContext('2d');
						    let chart = new Chart(ctx, {
						        type: 'bar',
						        data: chartData,
						        options: chartOptions
						    });
						});
				}

			}
		})
	})
	
	// 연장근무차트 셀렉트2.
	$(document).on('change', '#chart3select2', function() {
		var year = $('#chart3select1').val();
		var dep = $('#chart3select2').val();
		var str = "";
		console.log(year);
		console.log(dep);
		var data = {
			year : 	year,
			dep : dep
		}
		var monthData = [];
		var chartDiv = $('#chartDiv3');
		chartDiv.html('');
		chartDiv.html('<canvas id="chart3" style="width:100%; height:330px;"></canvas>');

		$.ajax({
			type : "POST",
			url : "/chart3select1Ajax.do",
			data : JSON.stringify(data),
            contentType : "application/json; charset=utf-8",
			success : function(result) {
				monthData.push(result.chartRes.jan);
				monthData.push(result.chartRes.feb);
				monthData.push(result.chartRes.mar);
				monthData.push(result.chartRes.apr);
				monthData.push(result.chartRes.may);
				monthData.push(result.chartRes.jun);
				monthData.push(result.chartRes.jul);
				monthData.push(result.chartRes.aug);
				monthData.push(result.chartRes.sep);
				monthData.push(result.chartRes.oct);
				monthData.push(result.chartRes.nov);
				monthData.push(result.chartRes.dec);
				
				
				if(dep == '전체') {
					
					var chartData = {
						    labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
						    datasets: [
						        {
						            label: dep+'팀 연장근무',
						            yAxisID: 'y-left',
						            data: monthData,
						            backgroundColor: [
						                'rgba(255, 99, 132, 0.2)',
						            ],
						            borderColor: [
						                'rgba(255, 99, 132, 1)',
						            ],
						            borderWidth: 1
						        },
						    ]
						};

						var chartOptions = {
						    responsive: true,
						    scales: {
						        x: {
						            title: {
						                display: true,
						                text: '(단위 : 월)'
						            }
						        },
						        'y-left': {
						            type: 'linear',
						            position: 'left',
						            title: {
						                display: true,
						                text: '연장근무시간 (단위 : 시간)'
						            },
						            ticks: {
						                beginAtZero: true,
						                min: 0,
						                max: 10,
						                stepSize: 2
						            },
						            grid: {
						                display: false
						            }
						        }
						    }
						};

						$(function(){
						    let ctx = document.getElementById('chart3').getContext('2d');
						    let chart = new Chart(ctx, {
						        type: 'bar',
						        data: chartData,
						        options: chartOptions
						    });
						});
					
				} else {
					
					var chartData = {
						    labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
						    datasets: [
						        {
						            label: dep+' 연장근무',
						            yAxisID: 'y-left',
						            data: monthData,
						            backgroundColor: [
						                'rgba(255, 99, 132, 0.2)',
						            ],
						            borderColor: [
						                'rgba(255, 99, 132, 1)',
						            ],
						            borderWidth: 1
						        },
						    ]
						};

						var chartOptions = {
						    responsive: true,
						    scales: {
						        x: {
						            title: {
						                display: true,
						                text: '(단위 : 월)'
						            }
						        },
						        'y-left': {
						            type: 'linear',
						            position: 'left',
						            title: {
						                display: true,
						                text: '근무시간 (단위 : 시간)'
						            },
						            ticks: {
						                beginAtZero: true,
						                min: 0,
						                max: 10,
						                stepSize: 2
						            },
						            grid: {
						                display: false
						            }
						        }
						    }
						};

						$(function(){
						    let ctx = document.getElementById('chart3').getContext('2d');
						    let chart = new Chart(ctx, {
						        type: 'bar',
						        data: chartData,
						        options: chartOptions
						    });
						});

					
				}
				
			}
		})
	})
	
	
	// 사용연차차트 셀렉트1.
	$(document).on('change', '#chart4select1', function() {
		var year = $('#chart4select1').val();
		var dep = $('#chart4select2').val();
		var chartDiv = $('#chartDiv4');
		var data = {
			year : 	year,
			dep : dep
		}
		var monthData = [];
		chartDiv.html('');
		chartDiv.html('<canvas id="chart4" style="width:100%; height:330px;"></canvas>');
		$.ajax({
			type : "POST",
			url : "/chart4select1Ajax.do",
			data : JSON.stringify(data),
            contentType : "application/json; charset=utf-8",
			success : function(result) {
				
				monthData.push(result.chartRes.jan);
				monthData.push(result.chartRes.feb);
				monthData.push(result.chartRes.mar);
				monthData.push(result.chartRes.apr);
				monthData.push(result.chartRes.may);
				monthData.push(result.chartRes.jun);
				monthData.push(result.chartRes.jul);
				monthData.push(result.chartRes.aug);
				monthData.push(result.chartRes.sep);
				monthData.push(result.chartRes.oct);
				monthData.push(result.chartRes.nov);
				monthData.push(result.chartRes.dec);
				
				
				if(dep == '전체') {
					
					var chartData = {
						    labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
						    datasets: [
						        {
						            label: dep+'팀 연차사용량',
						            yAxisID: 'y-left',
						            data: monthData,
						            backgroundColor: [
						                'rgba(54, 162, 235, 0.2)',
						            ],
						            borderColor: [
						                'rgba(54, 162, 235, 1)',
						            ],
						            borderWidth: 1
						        },
						    ]
						};

						var chartOptions = {
						    responsive: true,
						    scales: {
						        x: {
						            title: {
						                display: true,
						                text: '(단위 : 월)'
						            }
						        },
						        'y-left': {
						            type: 'linear',
						            position: 'left',
						            title: {
						                display: true,
						                text: '연차사용량 (단위 : 개)'
						            },
						            ticks: {
						                beginAtZero: true,
						                min: 0,
						                max: 10,
						                stepSize: 2
						            },
						            grid: {
						                display: false
						            }
						        }
						    }
						};

						$(function(){
						    let ctx = document.getElementById('chart4').getContext('2d');
						    let chart = new Chart(ctx, {
						        type: 'bar',
						        data: chartData,
						        options: chartOptions
						    });
						});
					
				} else {
					
					var chartData = {
						    labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
						    datasets: [
						        {
						        	label: dep+' 연차사용량',
						            yAxisID: 'y-left',
						            data: monthData,
						            backgroundColor: [
						                'rgba(54, 162, 235, 0.2)',
						            ],
						            borderColor: [
						                'rgba(54, 162, 235, 1)',
						            ],
						            borderWidth: 1
						        },
						    ]
						};

						var chartOptions = {
						    responsive: true,
						    scales: {
						        x: {
						            title: {
						                display: true,
						                text: '(단위 : 월)'
						            }
						        },
						        'y-left': {
						            type: 'linear',
						            position: 'left',
						            title: {
						                display: true,
						                text: '연차사용량 (단위 : 개)'
						            },
						            ticks: {
						                beginAtZero: true,
						                min: 0,
						                max: 10,
						                stepSize: 2
						            },
						            grid: {
						                display: false
						            }
						        }
						    }
						};

						$(function(){
						    let ctx = document.getElementById('chart4').getContext('2d');
						    let chart = new Chart(ctx, {
						        type: 'bar',
						        data: chartData,
						        options: chartOptions
						    });
						});

				}
			}
		})
	})
	
	// 사용연차차트 셀렉트2.
	$(document).on('change', '#chart4select2', function() {
		var year = $('#chart4select1').val();
		var dep = $('#chart4select2').val();
		var data = {
			year : 	year,
			dep : dep
		}
		var monthData = [];
		var chartDiv = $('#chartDiv4');
		chartDiv.html('');
		chartDiv.html('<canvas id="chart4" style="width:100%; height:330px;"></canvas>');
		$.ajax({
			type : "POST",
			url : "/chart4select1Ajax.do",
			data : JSON.stringify(data),
            contentType : "application/json; charset=utf-8",
			success : function(result) {
				monthData.push(result.chartRes.jan);
				monthData.push(result.chartRes.feb);
				monthData.push(result.chartRes.mar);
				monthData.push(result.chartRes.apr);
				monthData.push(result.chartRes.may);
				monthData.push(result.chartRes.jun);
				monthData.push(result.chartRes.jul);
				monthData.push(result.chartRes.aug);
				monthData.push(result.chartRes.sep);
				monthData.push(result.chartRes.oct);
				monthData.push(result.chartRes.nov);
				monthData.push(result.chartRes.dec);
				
				
				if(dep == '전체') {
					
					var chartData = {
						    labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
						    datasets: [
						        {
						            label: dep+' 연차사용량',
						            yAxisID: 'y-left',
						            data: monthData,
						            backgroundColor: [
						                'rgba(54, 162, 235, 0.2)',
						            ],
						            borderColor: [
						                'rgba(54, 162, 235, 1)',
						            ],
						            borderWidth: 1
						        },
						    ]
						};

						var chartOptions = {
						    responsive: true,
						    scales: {
						        x: {
						            title: {
						                display: true,
						                text: '(단위 : 월)'
						            }
						        },
						        'y-left': {
						            type: 'linear',
						            position: 'left',
						            title: {
						                display: true,
						                text: '연차사용량 (단위 : 개)'
						            },
						            ticks: {
						                beginAtZero: true,
						                min: 0,
						                max: 10,
						                stepSize: 2
						            },
						            grid: {
						                display: false
						            }
						        }
						    }
						};

						$(function(){
						    let ctx = document.getElementById('chart4').getContext('2d');
						    let chart = new Chart(ctx, {
						        type: 'bar',
						        data: chartData,
						        options: chartOptions
						    });
						});
					
				} else {
					
					var chartData = {
						    labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
						    datasets: [
						        {
						        	label: dep+' 연차사용량',
						            yAxisID: 'y-left',
						            data: monthData,
						            backgroundColor: [
						                'rgba(54, 162, 235, 0.2)',
						            ],
						            borderColor: [
						                'rgba(54, 162, 235, 1)',
						            ],
						            borderWidth: 1
						        },
						    ]
						};

						var chartOptions = {
						    responsive: true,
						    scales: {
						        x: {
						            title: {
						                display: true,
						                text: '(단위 : 월)'
						            }
						        },
						        'y-left': {
						            type: 'linear',
						            position: 'left',
						            title: {
						                display: true,
						                text: '연차사용량 (단위 : 개)'
						            },
						            ticks: {
						                beginAtZero: true,
						                min: 0,
						                max: 10,
						                stepSize: 2
						            },
						            grid: {
						                display: false
						            }
						        }
						    }
						};

						$(function(){
						    let ctx = document.getElementById('chart4').getContext('2d');
						    let chart = new Chart(ctx, {
						        type: 'bar',
						        data: chartData,
						        options: chartOptions
						    });
						});

				}
			}
		})
	})
	
	
})
$(document).ready(function(){
	
	$('#chart3select1').val('2023').trigger('change');
	$('#chart3select2').val('전체').trigger('change');
	
	$('#chart4select1').val('2023').trigger('change');
	$('#chart4select2').val('전체').trigger('change');
	
})
</script>









