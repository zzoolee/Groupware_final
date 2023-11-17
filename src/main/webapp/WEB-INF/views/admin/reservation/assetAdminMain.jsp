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
	<h2>자산 대여관리</h2>
	<p>
    	<span class="text-danger" data-feather="check"></span>
    	이미 대여된 자산은 임의로 처리할 수 없습니다.(예약현황에서 처리 후 설정 바랍니다.)
    </p>
	<div class="row g-2">
		<div class="col-12 col-xl-12">
			<div class="card mb-3">
				<div class="card-body">
					<br>
					
					<c:set value="${assList }" var="assList"/>
					<table class="table">
					  <thead>
					    <tr>
					      <th width="20px;"></th>
					      <th width="100px;">분류</th>
					      <th width="550px;">이름</th>
					      <th>위치</th>
					      <th></th>
					    </tr>
					  </thead>
					  <tbody>
					  	<c:choose>
						  	<c:when test="${empty assList }">
						  		<td>조회하신 자산이 존재하지 않습니다.</td>
						  	</c:when>
						  	<c:otherwise>
						  		<c:forEach items="${assList }" var="ass">
								    <tr> 
								      <td style="text-align: center;">
									     <c:if test="${ass.asSe eq '노트북'}">
										     <a class="icon-nav-item">
								                  <span class="fs-4 fas fa-laptop"></span>
							                </a>
									     </c:if>
									     <c:if test="${ass.asSe eq '테블릿PC'}">
										     <a class="icon-nav-item">
								                  <span class="fs-4 fas fa-tablet-alt"></span>
							                </a>
									     </c:if>
									     <c:if test="${ass.asSe eq '차량'}">
										     <a class="icon-nav-item">
								                  <span class="fs-4 fas fa-car"></span>
							                </a>
									     </c:if>
								      </td>
								     <td name="asSe">${ass.asSe }</td>
								     <td name="asName">${ass.asName }</td>
								     <td name="asLoc">${ass.asLoc }</td>
								     <td><button class="todayrentbtn btn btn-outline-info me-1 mb-1" type="button" data-bs-toggle="modal" data-bs-target="#exampleModal" data-ascd="${ass.asCd}">대여 관리</button></td>
								    </tr>
							    </c:forEach>
						    </c:otherwise>
					    </c:choose>
					 </tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>          
           
           
<!-- 모달 -->
<form action="/admin/assetreservation.do" method="post" id="resForm">             
   <div class="modal fade" id="exampleModal" tabindex="-1" aria-hidden="true">
	  <div class="modal-dialog">
	    <div class="modal-content">
		      <div class="modal-header">
		        <h5 class="modal-title" id="exampleModalLabel">대여 불가 처리</h5>
		        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close">
		        <span class="fas fa-times fs--1"></span></button>
		      </div>
		      <div class="modal-body" style="text-align: center;">
		      	<div style="display: inline-block; text-align: left;">
		      		<input type="hidden" name="asCd" value="">
		      		<c:set var="now" value="<%=new java.util.Date()%>" />
			        <c:set var="sysYear"><fmt:formatDate value="${now}" pattern="MM.dd(E)" /></c:set> 
			        <span class="fs-1 far fa-calendar-check" style="margin-right:10px;"></span><strong style="font-size:20px;"><c:out value="${sysYear }"></c:out></strong>
			       	<br><br> 
			        <p><strong>분류 : </strong><span id="asSe"> </span></p>
			        <p><strong>이름 : </strong><span id="asName"> </span></p>
			        <p><strong>위치 : </strong><span id="asLoc"> </span></p>
			        <span class="far fa-clock" style="margin-right:10px;"></span><strong style="margin-right:10px;">대여 시작 시간 </strong>
	        	<span class="fas fa-clock" style="margin-left:10px; margin-right:10px;"></span><strong>대여 종료 시간 </strong>
				<div class="float">
					<div class="d-flex">
						<select name="asrStarttime" style="margin-left:10px;width:130px;" class="form-select" aria-label="Default select example">
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
			        
						<select name="asrEndtime" style="margin-left:25px;width:130px;" class="form-select" aria-label="Default select example">
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
				<div class="d-flex justify-content-end" style="padding-top:10px;">
		        	<button class="btn btn-phoenix-danger btn-sm" type="button" id="cancleBtn">대여불가해제</button>
		        </div>
		        </div>
		      </div>
		      <div class="modal-footer">
		      	 <button class="btn btn-info" type="button" onclick="checkBlockTime()">저장</button>
      		 	 <button class="btn btn-outline-info" type="button" data-bs-dismiss="modal">취소</button>
		      </div>
	    		<sec:csrfInput/>
	        </div>
		</div>
	</div>
</form>            
               
               
                   

<script type="text/javascript">
$("button.todayrentbtn").click(function(){
	$("select option").prop('disabled', false);
	$("select option").removeClass();
	
	var asCd = $(this).data("ascd");
	var asSe = $(this).parent().siblings("td[name='asSe']").text();
	var asName = $(this).parent().siblings("td[name='asName']").text();
	var asLoc = $(this).parent().siblings("td[name='asLoc']").text();
	console.log(asCd, asSe, asName, asLoc);
	
	$("#resForm input[name='asCd']").val(asCd);
	$("#asSe").text(asSe);
	$("#asName").text(asName);
	$("#asLoc").text(asLoc);
	
	var url = "/ass/todayassetrent.do?asCd="+asCd;
	$.ajax({
		url : url,
		method : 'GET',
		dataType : 'json',
		success : function(res){
			console.log("res : {}", res);
			
			for(let i=0; i < res.length; i++){
				let asset = res[i];
				console.log("시작 asrStarttime : [",i,"]", asset.asrStarttime.substr(0,2));
				console.log("종료 asrEndtime : [",i,"]", asset.asrEndtime.substr(0,2));
				
				var start = Number(asset.asrStarttime.substr(0,2));
				var end = Number(asset.asrEndtime.substr(0,2));
				
				if(asset.empNo == 'admin'){
					while(true){
						$("select[name=asrStarttime] option[value='"+ (start < 10 ? "0" : "") + start + ":00']").prop('disabled', true).addClass('admin-option');
						$("select[name=asrEndtime] option[value='"+ (start < 10 ? "0" : "") + start + ":59']").prop('disabled', true).addClass('admin-option');
						start++;
						
						console.log(start, end);
						if(start > end) break;
					}
				} else{
					while(true){
						$("select[name=asrStarttime] option[value='"+ (start < 10 ? "0" : "") + start + ":00']").prop('disabled', true).addClass('emp-option');
						$("select[name=asrEndtime] option[value='"+ (start < 10 ? "0" : "") + start + ":59']").prop('disabled', true).addClass('emp-option');
						start++;
						
						console.log(start, end);
						if(start > end) break;
					}
				}
			}
		}
	});
});

$("#cancleBtn").on("click",function(){
	var asCd = $("#resForm input[name='asCd']").val();
	location.href="/admin/cancleassetblock.do?asCd="+asCd;
});

function checkBlockTime() {
    var start = $("select[name=asrStarttime] option:selected");
    var end = $("select[name=asrEndtime] option:selected");
    
    if(start.val() == 'timeSelect' || end.val() == 'timeSelect'){
    	alert("시간을 선택해주세요.");
    	return;
    }
    
    var flag = false;
    for(var i=start.index(); i<=end.index(); i++){
    	var option = $('select[name=asrStarttime] option').eq(i).attr('class');
    	console.log("선택한 시간 범위 내에 클래스가 있는지 확인: ", option);
	    if(option == 'emp-option'){
	    	flag = true;
	    }
    }
    
    if(flag){
    	alert("선택한 시간에 처리 불가한 시간이 포함되어 있습니다.");
    } else{
    	$("#resForm").submit();
    }
}
</script>