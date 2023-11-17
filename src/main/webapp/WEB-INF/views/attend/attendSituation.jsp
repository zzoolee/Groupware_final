<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.4.0/Chart.min.js"></script>
 <script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>
 <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="chart-test.js"></script>
<style>
.toggleSwitch {
  width: 50px;
  height: 25px;
  display: block;
  position: relative;
  border-radius: 30px;
  background-color: #fff;
  box-shadow: 0 0 16px 3px rgba(0 0 0 / 15%);
  cursor: pointer;
}

 /* 토글 버튼 */
.toggleSwitch .toggleButton {
  /* 버튼은 토글보다 작아야함  */
  width: 20px;
  height: 20px;
  position: absolute;
  top: 50%;
  left: 4px;
  transform: translateY(-50%);
  border-radius: 50%;
  background: #f03d3d;
}

#toggle:checked ~ .toggleSwitch {
  background: #f03d3d;
}

#toggle:checked ~ .toggleSwitch .toggleButton {
  left: calc(100% - 22px);
  background: #fff;
}

.toggleSwitch, .toggleButton {
  transition: all 0.2s ease-in;
}

/* checked 부분을 active란 클래스가 포함되어있는지 여부로 바꾸기 */
.toggleSwitch.active {
  background: #f03d3d;
}

.toggleSwitch.active .toggleButton {
  left: calc(100% - 22px);
  background: #fff;
}
</style>
<c:set value="${monthExist }" var="monthExist"/>

<h2>근태현황</h2>
<div>
	<div class="row g-4">
		<div class="col-12 col-xxl-6">
			<div></div>
		</div>
	</div>
</div>
		<div data-list='{"valueNames":["product","customer","rating","review","time"],"page":6}'>
			<div>
				<div class="container-fluid pb-7">
					<div class="card mt-7" style="border-radius:20px; padding:40px;">
						<div class="col-12 d-flex justify-content-between align-items-center border-0">
							<button class="btn btn-phoenix-info me-1 mb-1" type="button" id="excelBtn">근태현황 엑셀로 저장</button>
							<div class="d-flex justify-content-end">
								<select class="form-select form-select-lg mb-3 text-start" style="width:200px;" aria-label=".form-select-lg example" id="yearMonthSelect">
									<option selected>연도와 월을 선택하세요</option>
									<c:forEach var="month" items="${monthExist}" varStatus="status">
										<option value="${month.yearMonth }">${month.yearMonth }</option>
									</c:forEach>
									<c:forEach var="month" items="${monthExist}" varStatus="status">
										<c:if test="${status.first }">
											<input type="hidden" value="${month.yearMonth }" id="lastMonth"/>
										</c:if>
									</c:forEach> 
								</select>
								&nbsp;&nbsp;
								<select class="form-select form-select-lg mb-3 text-start" style="width:200px;" aria-label=".form-select-lg example" id="weekSelect">
									<!-- if문으로 돌리기 -->
									<option selected="">주차를 선택하세요</option>
								</select>
							</div>
						</div>
						<div class="col-12">
							<div class="d-flex justify-content-end align-items-center">
								<h4 class="fw-normal px-3 pt-2" id="chartLabel">chart</h4>
								<input type="checkbox" id="toggle" hidden> 
								<labelfor="toggle" class="toggleSwitch"> 
									<span class="toggleButton"></span>
								</label>
							</div>
						</div>
						<br>
							
						<div class="row" >
							<div class="col-1"></div>
							<div class="col-7 chartDiv" id="chartContainer" ></div>
							<div class="col-3 chartDiv" id="chartContainerRound"></div>
						</div>	
						<br>
																
						<div class="row">
							<div class="col-1"></div>
							<div class="col-10 d-flex justify-content-center text-center pb-5">
								<table class="table table-striped text-center">
  									<thead>
    									<tr>
     										<th scope="col"></th>
     				 						<th scope="col">근무유형</th>
      										<th scope="col">근무시간</th>
      										<th scope="col">연장근무시간</th>
    									</tr>
  									</thead>
  									<tbody id="attendBody">	
										<!-- if문 돌리기 -->
										<tr>
											<td colspan="4">
												근무기록이 없습니다.
											</td>
										</tr>
										<!-- if문 돌리기 -->
										<!-- 포문돌릴위치 -->
  									</tbody>
								</table>								
							</div>
						</div>
						<div class="row pb-7">
							<div class="col-9"></div>
							<div class="col-2 d-flex justify-content-end">
								
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="row align-items-center py-1">
				<div class="pagination d-none"></div>
				<div class="col d-flex fs--1">
<!-- 					하단부 -->
				</div>
			</div>
			<div class="row" style="margin: 15px 0px 20px 0px;">
				<div class="col-9"></div>
				<div class="col-3 text-end">
				</div>
			</div>
		</div>

<div class="modal fade" id="excelModal" tabindex="-1" aria-labelledby="verticallyCenteredModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="verticallyCenteredModalLabel">엑셀저장완료</h5><button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
        <p class="text-700 lh-lg mb-0" id="excelModalMessage">근태현황 엑셀자료 저장이 완료되었습니다.</p>
      </div>
      <div class="modal-footer"><button class="btn btn-info" type="button" data-bs-dismiss="modal">확인</button></div>
    </div>
  </div>
</div>
<form action="/POIAjax.do" method="POST" id="excelForm">
	<input type="hidden" value="" name="days" id="days">
	<input type="hidden" value="" name="attendTime" id="attendTime">
	<input type="hidden" value="" name="overTime" id="overTime">
	<input type="hidden" value="" name="kindOfAttend" id="kindOfAttend">
</form>

<script type="text/javascript">
$(function(){
	var hiBtn = $('#hiBtn');
	var byeBtn = $('#byeBtn');
	var hiModal = $('#hiModal');
	var byeModal = $('#byeModal');
	var yearMonthSelect = $('#yearMonthSelect');
	var yearMonthForm = $('#yearMonthForm');
	var yearMonth = $('#yearMonthSelect').val();
	var weekData = $('#weekSelect').val();
	var attendBody = $('#attendBody');
	var weekSelect = $('#weekSelect');
	var chartLabel = $('#chartLabel');
	var chartFlag = false;
	var days = [];
	var attendTime = [];
	var overTime = [];
	var kindOfAttend = [];
	var basic = [];
    var yuyeonA = [];
    var yuyeonB = [];
    var workAtHome = [];
    var basicCnt = 0;
    var yuyeonACnt = 0;
    var yuyeonBCnt = 0;
    var workAtHomeCnt = 0;
	var overAllTime = [];
	const toggleList = document.querySelectorAll(".toggleSwitch");
	var chartDiv = $('.chartDiv');
	var toggle = $("#toggle");
	var toggles = $(".toggleSwitch");
	var chartContainer = $('#chartContainer');
	var chartContainerRound = $('#chartContainerRound');
	var overAllTimeSum = 0;
	var excelBtn = $('#excelBtn');
	var excelModal = $('#excelModal');
	var excelModalMessage = $('#excelModalMessage');
	
	
	excelBtn.on('click', function(){
		
		console.log(days);
		console.log(attendTime);
		console.log(overTime);
		console.log(kindOfAttend);
		
		$('#days').val(days);
		$('#attendTime').val(attendTime);
		$('#overTime').val(overTime);
		$('#kindOfAttend').val(kindOfAttend);
		
		$('#excelForm').submit();
		// 셋타임 인터벌 필요???.
		setTimeout(() => {
			alert("근태현황 엑셀 다운로드가 완료되었습니다");
		}, 1000);
		
		
// // 		var excelData = {
// // 			days : days,
// // 			attendTime : attendTime,
// // 			overTime : overTime,
// // 			kindOfAttend : kindOfAttend
// // 		}
// 		$.ajax({
// 			type:"POST", 
//             url:"/POIAjax.do",
//             data : JSON.stringify(excelData),
//             contentType : "application/json; charset=utf-8",	
//             success:function(result){
//             	console.log(result);
//             	if(result == null) {
//             	} else {
//             		console.log(result.message);
//             		excelModalMessage.html(result.message);
//             		excelModal.modal('show');
//             	}
//             }
// 		});
	});
	
// 	toggleList.forEach(($toggle) => {
// 	  $toggle.onclick = () => {
// 	    $toggle.classList.toggle('active');
// 	    if(chartFlag==false){

// 	    	chartDiv.css('display','block');
// 	    	chartFlag=true;
// 	    } else {
	    	
// 	    	chartDiv.css('display','none');
// 	    	chartFlag=false;
// 	    }
// 	  }
// 	});
	
	toggles.on("click", function(){
		if(toggle.is(":checked")){
			toggle.prop("checked",false);
			chartDiv.css('display','none');
		}else{
			toggle.prop("checked",true);			
			chartDiv.css('display','block');
		}
	});
	
	yearMonthSelect.on('change', function(){
		chartDiv.css('display','block');
		toggle.prop("checked",true);
		days = [];
		attendTime = [];
		overTime = [];
		kindOfAttend = [];
		overAllTimeSum = 0;
		overAllTime = [];
		basic = [];
	    yuyeonA = [];
	    yuyeonB = [];
	    workAtHome = [];
	    basicCnt = 0;
	    yuyeonACnt = 0;
	    yuyeonBCnt = 0;
	    workAtHomeCnt = 0;
		yearMonth = $('#yearMonthSelect').val();
		if (yearMonth == '연도와 월을 선택하세요') {
			alert ("연도와 월을 선택해주세요");
			return false;
		}
		console.log(yearMonth);
		chartContainer.html('');
		chartContainerRound.html('');
		chartContainer.html('<canvas id="attendChart" style="width:100%; height:400px;"></canvas>');
		chartContainerRound.html('<canvas id="attendChartRound" style="width:100%; height:400px;"></canvas>');
		
		var str = "";
		var strWeek = "";
		var monthObject = {
			yearMonth : yearMonth
		};
		
		
		$.ajax({ 
            type:"POST", 
            url:"/attendanceAjax.do",
            data : JSON.stringify(monthObject),
            contentType : "application/json; charset=utf-8",	
            success:function(result){
            	console.log(result.weekList);
            	attendBody.html('');
            	weekSelect.html('');
            	console.log("도착");
            	if (result.monthList == null || result.monthList.length === 0) {
                    str = '<tr><td colspan="4">근무기록이 없습니다.</td></tr>';
                } else {
                	result.monthList.forEach(function(item) {
                    	// 누적에 데이터 쌓아주기
                        // JavaScript로 날짜 형식을 변경                  
                        var date = new Date(item.atDate); // 형식화할 날짜
                        var year = String(date.getFullYear());
                        var month = String(date.getMonth() + 1).padStart(2, '0'); // 월을 2자리 숫자로
                        var day = String(date.getDate()).padStart(2, '0'); // 일을 2자리 숫자로
                        var formattedDate = year + '.' + month + '.' + day + '.';
                        
                        var startTime = new Date(item.atStart);
                        var endTime = new Date(item.atEnd);
                        var startHour = String(startTime.getHours()).padStart(2, '0');
                        var endHour = String(endTime.getHours()).padStart(2, '0');
                        var startMinute = String(startTime.getMinutes()).padStart(2, '0');
                        var endMinute = String(endTime.getMinutes()).padStart(2, '0');
                        var diffTime = endHour-startHour;
                        if(diffTime>4) {
                        	diffTime = diffTime-1;
                        }
                        
                        if((startTime.getMinutes()) > 0) {
                        	diffTime = diffTime-1;
                        }
                        
                        var overAll = diffTime+item.atOvertime;

                        str += '<tr>';
                        str += '<th scope="row">' + formattedDate + '</th>';
                        str += '<td>' + item.atType + '</td>';
                        str += '<td>'+diffTime+'시간 ('+startHour+':'+startMinute+'~'+endHour+':'+endMinute+')</td>';
                        str += '<td>' + item.atOvertime + '시간</td></tr>';
                        
                        overTime.push(item.atOvertime);
                        days.push(formattedDate);
                        attendTime.push(diffTime);
                        kindOfAttend.push(item.atType);
                        overAllTimeSum += overAll;
                        overAllTime.push(overAllTimeSum);
                        
                        if(item.atType=='기본'){
                            basicCnt = basicCnt+1;
                         } else if(item.atType=='유연A') {
                            yuyeonACnt = yuyeonACnt+1;
                            
                         } else if(item.atType=='유연B') {
                            yuyeonBCnt = yuyeonBCnt+1;
                         } else if(item.atType=='재택') {
                            workAtHomeCnt = workAtHomeCnt+1;
                         }
                         basic.push(basicCnt);
                      	 yuyeonA.push(yuyeonACnt);
                       	 yuyeonB.push(yuyeonBCnt);
                       	 workAtHome.push(workAtHomeCnt);
                        
                    });
                }
            	attendBody.html(str);
            	
            	if(result.weekList == null || result.weekList.length === 0) {
            		strWeek += '<option selected>주차를 선택하세요</option>';
            		
            	} else {
            		strWeek += '<option selected>주차를 선택하세요</option>';
            		result.weekList.forEach(function(item) {
            			strWeek += '<option value="'+item.atWeek+'">'+item.atWeek+'주차</option>';
            		});
            	}            	
            	weekSelect.html(strWeek);
            	
            	console.log(basicCnt);
            	console.log(yuyeonACnt);
            	console.log(yuyeonBCnt);
            	console.log(workAtHomeCnt);
            	
            	const data = {
          			  labels: [
          			    '기본근무',
          			    '유연근무 A형',
          			    '유연근무 B형',
          			    '재택근무'
          			  ],
          			  datasets: [{
          			    label: [' 유형근무 일수'],
          			    data: [basicCnt, yuyeonACnt, yuyeonBCnt, workAtHomeCnt],
          			    backgroundColor: [
          			      'rgb(255, 99, 132)',
          			      'rgb(54, 162, 235)',
          			      'rgb(255, 205, 86)',
          			      'rgb(214, 212, 109)'
          			    ],
          			    hoverOffset: 4
          			  }]
          		};
            	
            	const config = {
 					type: 'doughnut',
  					data: data,
				};
            	
            	
            	$(function(){
            	    let ctx = document.getElementById('attendChartRound').getContext('2d');
            	    let chart = new Chart(ctx, config);
            	});
            	
            	
            	
            	
            	$(function(){
            	    let ctx = document.getElementById('attendChart').getContext('2d');
            	    let chart = new Chart(ctx, {
            	        type: 'bar',
            	        data: chartData,
            	        options: chartOptions
            	    })
            	})
            	
            	var chartData = {
            		    labels: days,
            		    datasets: [
            		        {
            		            label: '근무',
            		            yAxisID: 'y-left',
            		            data: attendTime,
            		            backgroundColor: [
            		                'rgba(255, 99, 132, 0.2)',
            		            ],
            		            borderColor: [
            		                'rgba(255, 99, 132, 1)',
            		            ],
            		            borderWidth: 1
            		        },
            		        {
            		            label: '연장근무',
            		            yAxisID: 'y-left',
            		            data: overTime,
            		            backgroundColor: [
            		                'rgba(54, 162, 235, 0.2)',
            		            ],
            		            borderColor: [
            		                'rgba(54, 162, 235, 1)',
            		            ],
            		            borderWidth: 1
            		        },
            		        {
            		            label: '누적근무시간',
            		            yAxisID: 'y-right',
            		            type: 'line',
            		            data: overAllTime,
            		            backgroundColor: [
            		                'rgba(255, 159, 64, 0.2)'
            		            ],
            		            borderColor: [
            		                'rgba(255, 159, 64, 1)'
            		            ],
            		            borderWidth: 1
            		        },
            		    ]
            		}
            	var chartOptions = {
            		    responsive:true,
            		    // maintainAspectRatio: false,
            		    scales: {
            		        x: {
            		            title: {
            		                display: true,
            		                text: '근무 날짜(일)'
            		            }
            		        },
            		        'y-left': {
            		            type: 'linear',
            		            position: 'left',
            		            title: {
            		                display: true,
            		                text: '근무시간 (시간)'
            		            },
								ticks: {
									 beginAtZero: true,
				                     min: 0, // 축 최소 값
				                     max: 10, // 축 최대 값
				                     stepSize: 2 // 그리드 간격 값
            		            },
            		            grid: {
            		                display: false
            		            }
            		        },
            		        'y-right': {
            		            type: 'linear',
            		            
            		            position: 'right',
            		            title: {
            		                display: true,
            		                text: '누적 근무시간 (시간)'
            		            },
            		            ticks: {
            		            	beginAtZero: true,
				                     min: 0, // 축 최소 값
				                     max: 200, // 축 최대 값
				                     stepSize: 10 // 그리드 간격 값
            		            },
            		            grid: {
            		                display: false
            		            }
            		        }
            		    }
            		}

            }
        })
	});
	
	
	
	
	
	weekSelect.on('change', function(){
		chartDiv.css('display','block');
		toggle.prop("checked",true);
		days = [];
		basic = [];
	    yuyeonA = [];
	    yuyeonB = [];
	    workAtHome = [];
	    basicCnt = 0;
	    yuyeonACnt = 0;
	    yuyeonBCnt = 0;
	    workAtHomeCnt = 0;
		attendTime = [];
		overTime = [];
		overAllTime = [];
		kindOfAttend = [];
		overAllTimeSum = 0;
		yearMonth = $('#yearMonthSelect').val();
		weekData = $('#weekSelect').val();
		if (yearMonth == '연도와 월을 선택하세요') {
			alert ("연도와 월을 선택해주세요");
			return false;
		}
		if (weekData == '주차를 선택하세요') {
			alert ("주차를 선택해주세요");
			return false;
		}
		console.log("위크데이터"+weekData);
		if(weekData.length != 1){
			weekData = null;
		}
		chartContainer.html('');
		chartContainerRound.html('');
		chartContainer.html('<canvas id="attendChart" style="width:100%; height:400px;"></canvas>');
		chartContainerRound.html('<canvas id="attendChartRound" style="width:100%; height:400px;"></canvas>');
		var strWeekAttend = "";
		var weekObject = {
			yearMonth : yearMonth
			,weekData : weekData
		};
		
		$.ajax({ 
            type:"POST", 
            url:"/attendanceAjax2.do",
            data : JSON.stringify(weekObject),
            contentType : "application/json; charset=utf-8",
            success:function(result){
            	console.log("위크어텐드 리스트"+result);
            	attendBody.html('');
            	if (result.weekAttendList == null || result.weekAttendList.length === 0) {
                    str = '<tr><td colspan="4">근무기록이 없습니다.</td></tr>';
                } else {
                	result.weekAttendList.forEach(function(item) {
                        // JavaScript로 날짜 형식을 변경                  
                        var date = new Date(item.atDate); // 형식화할 날짜
                        var year = String(date.getFullYear());
                        var month = String(date.getMonth() + 1).padStart(2, '0'); // 월을 2자리 숫자로
                        var day = String(date.getDate()).padStart(2, '0'); // 일을 2자리 숫자로
                        var formattedDate = year + "." + month + '.' + day + ".";
                        
                        var startTime = new Date(item.atStart);
                        var endTime = new Date(item.atEnd);
                        var startHour = String(startTime.getHours()).padStart(2, '0');
                        var startMinute = String(startTime.getMinutes()).padStart(2, '0');
                        var endHour = String(endTime.getHours()).padStart(2, '0');
                        var endMinute = String(endTime.getMinutes()).padStart(2, '0');
                        var diffTime = endHour-startHour;
                        if(diffTime>4) {
                        	diffTime = diffTime-1;
                        }
                        
                        if((startTime.getMinutes()) > 0) {
                        	diffTime = diffTime-1;
                        }
                        
                        var overAll = diffTime+item.atOvertime;
                        
                        strWeekAttend += '<tr>';
                        strWeekAttend += '<th scope="row">' + formattedDate + '</th>';
                        strWeekAttend += '<td>' + item.atType + '</td>';
                        strWeekAttend += '<td>'+diffTime+'시간 ('+startHour+':'+startMinute+'~'+endHour+':'+endMinute+')</td>';
                        strWeekAttend += '<td>' + item.atOvertime + '시간</td></tr>';
                        
                        overTime.push(item.atOvertime);
                        days.push(formattedDate);
                        attendTime.push(diffTime);
                        overAllTimeSum += overAll;
                        overAllTime.push(overAllTimeSum);
                        
                        if(item.atType=='기본'){
                            basicCnt = basicCnt+1;
                         } else if(item.atType=='유연A') {
                            yuyeonACnt = yuyeonACnt+1;
                            
                         } else if(item.atType=='유연B') {
                            yuyeonBCnt = yuyeonBCnt+1;
                         } else if(item.atType=='재택') {
                            workAtHomeCnt = workAtHomeCnt+1;
                         }
                        
                         basic.push(basicCnt);
                      	 yuyeonA.push(yuyeonACnt);
                       	 yuyeonB.push(yuyeonBCnt);
                       	 workAtHome.push(workAtHomeCnt);
                       	 
                       	kindOfAttend.push(item.atType);
                        
                    });
                }
            	attendBody.html(strWeekAttend);
            	
            	
            	const data = {
            			  labels: [
            			    '기본근무',
            			    '유연근무 A형',
            			    '유연근무 B형',
            			    '재택근무'
            			  ],
            			  datasets: [{
            			    label: [' 유형근무 일수'],
            			    data: [basicCnt, yuyeonACnt, yuyeonBCnt, workAtHomeCnt],
            			    backgroundColor: [
            			      'rgb(255, 99, 132)',
            			      'rgb(54, 162, 235)',
            			      'rgb(255, 205, 86)',
            			      'rgb(214, 212, 109)'
            			    ],
            			    hoverOffset: 4
            			  }]
            		};
              	
              	const config = {
   				 type: 'doughnut',
    					data: data,
  					};
              	
              	
              	$(function(){
              	    let ctx = document.getElementById('attendChartRound').getContext('2d');
              	    let chart = new Chart(ctx, config);
              	});
            	
            	$(function(){
            	    let ctx = document.getElementById('attendChart').getContext('2d');
            	    let chart = new Chart(ctx, {
            	        type: 'bar',
            	        data: chartData,
            	        options: chartOptions
            	    })
            	})
            	
            	var chartData = {
            		    labels: days,
            		    datasets: [
            		        {
            		            label: '근무',
            		            yAxisID: 'y-left',
            		            data: attendTime,
            		            backgroundColor: [
            		                'rgba(255, 99, 132, 0.2)',
            		            ],
            		            borderColor: [
            		                'rgba(255, 99, 132, 1)',
            		            ],
            		            borderWidth: 1
            		        },
            		        {
            		            label: '연장근무',
            		            yAxisID: 'y-left',
            		            data: overTime,
            		            backgroundColor: [
            		                'rgba(54, 162, 235, 0.2)',
            		            ],
            		            borderColor: [
            		                'rgba(54, 162, 235, 1)',
            		            ],
            		            borderWidth: 1
            		        },
            		        {
            		            label: '누적근무시간',
            		            yAxisID: 'y-right',
            		            type: 'line',
            		            data: overAllTime,
            		            backgroundColor: [
            		                'rgba(255, 159, 64, 0.2)'
            		            ],
            		            borderColor: [
            		                'rgba(255, 159, 64, 1)'
            		            ],
            		            borderWidth: 1
            		        },
            		    ]
            		}
            	var chartOptions = {
            		    responsive:true,
            		    // maintainAspectRatio: false,
            		    scales: {
            		        x: {
            		            title: {
            		                display: true,
            		                text: '근무 날짜(일)'
            		            }
            		        },
            		        'y-left': {
            		            type: 'linear',
            		            position: 'left',
            		            title: {
            		                display: true,
            		                text: '근무시간 (시간)'
            		            },
								ticks: {
									 beginAtZero: true,
				                     min: 0, // 축 최소 값
				                     max: 10, // 축 최대 값
				                     stepSize: 2 // 그리드 간격 값
            		            },
            		            grid: {
            		                display: false
            		            }
            		        },
            		        'y-right': {
            		            type: 'linear',
            		            
            		            position: 'right',
            		            title: {
            		                display: true,
            		                text: '누적 근무시간 (시간)'
            		            },
            		            ticks: {
            		            	beginAtZero: true,
				                     min: 0, // 축 최소 값
				                     max: 200, // 축 최대 값
				                     stepSize: 10 // 그리드 간격 값
            		            },
            		            grid: {
            		                display: false
            		            }
            		        }
            		    }
            		}
            	
            	
            }           	
        })		
	});
	
	
	hiBtn.on('click', function(){
		hiModal.show();
	});
	
	byeBtn.on('click', function(){
		byeModal.show();
	});
	
	CKEDITOR.replace('exampleTextarea'
            , {height: 500                                                  
            });

	
});
$(document).ready(function(){
	var lastMonth = $('#lastMonth').val(); 
	
	console.log(lastMonth);
	$('#yearMonthSelect').val(lastMonth).trigger('change');
})

</script>