<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<style>
.admin-option {
  color: red !important;
  background-color: #DCDCDC !important; /* 비활성화된 옵션의 텍스트 색상을 빨간색으로 지정 */
}
.emp-option {
  background-color: #DCDCDC !important; /* 비활성화된 옵션의 텍스트 색상을 빨간색으로 지정 */
  /* 기타 스타일 속성 추가 가능 */
}
</style>

<div class="container">
    <h2>회의실예약</h2>
    <p>
    	<span class="text-danger" data-feather="check"></span>
    	예약 불가한 시간은 선택되지 않으며, 빨간색으로 표시된 시간은 관리자에 의해 예약 불가 처리된 시간입니다.
    </p>
    <br>
    <c:set value="${roomList }" var="roomList"/>
    <c:choose>
        <c:when test="${empty roomList }">
            <td>조회하신 회의실이 존재하지 않습니다.</td>
        </c:when>
        <c:otherwise>
            <div class="row">
                <c:forEach items="${roomList }" var="room">
	                <div class="col-sm-6 col-md-4 col-lg-3">
					    <div class="card border border-secondary" style="margin-bottom: 20px;">
					      <div class="card-body" >
					      	<a class="fs-4 fas fa-users"></a><br><br>
					        <h4 class="card-title">${room.roomName }</h4>
					        <p class="card-text">${room.roomLoc }</p>
					        <input type="hidden" name="roomCd" value="${room.roomCd }">
					      </div>
					      <button style="width:100px;heigth:20px; margin-left:140px;" class="mb-3 float-end todayrentbtn btn btn-outline-info resManageBtn" type="button" data-bs-toggle="modal" data-bs-target="#exampleModal">예약</button>
					    </div>
					  </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- 모달 -->
<div class="modal fade" id="exampleModal" tabindex="-1" aria-hidden="true">
	<div class="modal-dialog">
	  <div class="modal-content">
	 	<form action="/room/roomreservation.do" method="post" id="resForm">
	     <div class="modal-header">
	       <h5 class="modal-title" id="exampleModalLabel">회의실 예약</h5><button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
	     </div>
	     <div class="modal-body" style="text-align: center;">
	     	<div style="display: inline-block; text-align: left;">
	     		<input type="hidden" name="roomCd" value="${room.roomCd }">
	     		<c:set var="now" value="<%=new java.util.Date()%>" />
	        <c:set var="sysYear"><fmt:formatDate value="${now}" pattern="MM.dd(E)" /></c:set> 
	        <span class="fs-1 far fa-calendar-check" style="margin-right:10px;"></span><strong style="font-size:20px;"><c:out value="${sysYear }"></c:out></strong>
	       	<br><br>
	        <p><strong>이름 : </strong><span id="roomName"></span></p>
	        <p><strong>위치 : </strong><span id="roomLoc"></span></p>
	        <span class="far fa-clock" style="margin-right:10px;"></span><strong style="margin-right:10px;">예약 시작 시간 </strong>
	        <span class="fas fa-clock" style="margin-left:10px; margin-right:10px;"></span><strong>예약 종료 시간 </strong>
			<div class="float">
				<div class="d-flex">
					<select name="rrStarttime" style="margin-left:10px;width:130px;" class="form-select" aria-label="Default select example">
					  <option value="timeSelect">시간선택</option>
					  <option value="09:00">09:00</option>
					  <option value="10:00">10:00</option>
					  <option value="11:00">11:00</option>
					  <option value="12:00">12:00</option>
					  <option value="13:00">13:00</option>
					  <option value="14:00">14:00</option>
					  <option value="15:00">15:00</option>
					  <option value="16:00">16:00</option>
					  <option value="17:00">17:00</option>
					  <option value="18:00">18:00</option>
					</select>
		        
					<select name="rrEndtime" style="margin-left:25px;width:130px;" class="form-select" aria-label="Default select example">
					  <option value="timeSelect">시간선택</option>
					  <option value="09:59">09:59</option>
					  <option value="10:59">10:59</option>
					  <option value="11:59">11:59</option>
					  <option value="12:59">12:59</option>
					  <option value="13:59">13:59</option>
					  <option value="14:59">14:59</option>
					  <option value="15:59">15:59</option>
					  <option value="16:59">16:59</option>
					  <option value="17:59">17:59</option>
					  <option value="18:59">18:59</option>
					</select>
				</div>
			</div>
			<br>
			<div>
	        <strong>예약 사유</strong>
	        <input class="form-control" name="rrReason" type="text">
	      </div>
	       </div>
	     </div>
	     <div class="modal-footer">
	      <button class="btn btn-info" type="button" onclick="checkBlockTime()">예약</button>
	      <button class="btn btn-outline-info" type="button" data-bs-dismiss="modal">취소</button>
	     </div>
	  		<sec:csrfInput/>
	    	</form>
	    </div>
  </div>
</div>


<script type="text/javascript">
$(function(){
	$(".resManageBtn").on("click", function(){
		// 예약된 시간의 비활성화를  풀어줌.!!
		$("select option").prop('disabled', false);
		$("select option").removeClass();
		$("#resForm input[name='roomCd']").remove();
		
		var $div = $(this).closest('div'); // 클릭한 버튼이 속한 div 요소를 찾음
		var roomCd = $div.find('input[name="roomCd"]').val();
		console.log("roomCd : ", roomCd);
		
		var data = {
			roomCd	: roomCd
		}
		//console.log("data : ", data);
		
		$.ajax({
			type : "post",
			url : "/admin/room2.do",
			data : JSON.stringify(data),
			contentType : "application/json; charset=UTF-8",
			success: function(res){
				//console.log("res: ", res);
				$("#roomName").text(res.roomName);
				$("#roomLoc").text(res.roomLoc);
				$("#resForm").append("<input type='hidden' name='roomCd' value='" +res.roomCd+ "'>");
			}
		});
		
		$.ajax({
			type : "post",
			url  : "/admin/roomrent.do",
			data : JSON.stringify(data),
			contentType: "application/json; charset=utf-8",
			success: function(res) {
				console.log("결과 : ", res);
				
				for(let i=0; i < res.length; i++){
					let blockRoom = res[i];
					console.log("시작 rrStarttime : [",i,"]", blockRoom.rrStarttime.substr(0,2));
					console.log("종료 rrEndtime : [",i,"]", blockRoom.rrEndtime.substr(0,2));
					
					var start = Number(blockRoom.rrStarttime.substr(0,2));
					var end = Number(blockRoom.rrEndtime.substr(0,2));
					
					if(blockRoom.empNo == 'admin'){
						while(true){
							$("select[name=rrStarttime] option[value='"+ (start < 10 ? "0" : "") + start + ":00']").prop('disabled', true).addClass('admin-option');
							$("select[name=rrEndtime] option[value='"+ (start < 10 ? "0" : "") + start + ":59']").prop('disabled', true).addClass('admin-option');
							start++;
							
							console.log(start, end);
							if(start > end) break;
						}
					} else{
						while(true){
							$("select[name=rrStarttime] option[value='"+ (start < 10 ? "0" : "") + start + ":00']").prop('disabled', true).addClass('emp-option');
							$("select[name=rrEndtime] option[value='"+ (start < 10 ? "0" : "") + start + ":59']").prop('disabled', true).addClass('emp-option');
							start++;
							
							console.log(start, end);
							if(start > end) break;
						}
					}
				}
			}
		});
	});
});

function checkBlockTime() {
    var start = $("select[name=rrStarttime] option:selected");
    var end = $("select[name=rrEndtime] option:selected");
    
    if(start.val() == 'timeSelect' || end.val() == 'timeSelect'){
    	alert("시간을 선택해주세요.");
    	return;
    }
    
    var flag = false;
    for(var i=start.index(); i<=end.index(); i++){
    	var disabled = $('select[name=rrStarttime] option').eq(i).prop('disabled');
    	console.log("선택한 시간 범위 내에 속성이 있는지 확인: ", disabled);
	    if(disabled){
	    	flag = true;
	    }
    }
    
    if(flag){
    	alert("선택한 시간에 예약 불가한 시간이 포함되어 있습니다.");
    } else{
    	$("#resForm").submit();
    }
}
</script>