<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<h2>기안서 생성</h2>
<br>
<div class="card">
	<div class="card-body">
		<form action="/admin/createAtrzf.do" method="post" id="sendForm">
			<div>
				<table class="table table-sm" style="vertical-align: middle; height: 70px;">
				    <tr>
				      <th scope="col" style="width: 100px;">* 제목</th>
				      <td colspan="4">
				      	<input class="form-control form-control-sm" type="text" id="atrzfName" name="atrzfName" style="width:30%;"/>
				      </td>
				    </tr>
				</table>
			</div>
		<div class="d-flex justify-content-end align-items-start">
			<button class="btn btn-outline-info" type="button" data-bs-toggle="modal" data-bs-target="#selectForm">양식 불러오기</button>
		</div>
		</br>
			<div class="card-body">
				<div class="col-md-12">
					<textarea id="ckeditor" name="atrzfContent" class="form-control" rows="14"></textarea>
				</div>
			</div>
			<br>
			<div style="text-align: center;">
						<button class="btn btn-info me-1 mb-1" type="submit" id="updateBtn">생성</button>
			</div>
		</form>
		
		<!--  양식 불러오기 모달 -->
		<div class="modal fade" id="selectForm" tabindex="-1" aria-labelledby="scrollingLongModalLabel2" aria-hidden="true">
		  <div class="modal-dialog modal-dialog-scrollable">
		    <div class="modal-content">
		      <div class="modal-header">
		        <h5 class="modal-title" id="scrollingLongModalLabel2">기안서 양식 목록</h5>
		        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close">
		        	<span class="fas fa-times fs--1"></span>
		        </button>
		      </div>
		      <div class="modal-body" style="text-align: center;">
		        <p class="text-700 lh-lg mb-0"></p> 
		        	<div class="row g-2 gy-3" >
						<div class="col-auto" style="margin-left: 40px;">
							<div class="search-box">
								<form class="position-relative" data-bs-toggle="search" data-bs-display="static">
									<!-- 검색 위치 -->
									<input class="form-control search-input search form-control-sm" type="search" placeholder="Search" aria-label="Search"> 
									<svg class="svg-inline--fa fa-magnifying-glass search-box-icon" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="magnifying-glass" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg="">
										<path fill="currentColor" d="M500.3 443.7l-119.7-119.7c27.22-40.41 40.65-90.9 33.46-144.7C401.8 87.79 326.8 13.32 235.2 1.723C99.01-15.51-15.51 99.01 1.724 235.2c11.6 91.64 86.08 166.7 177.6 178.9c53.8 7.189 104.3-6.236 144.7-33.46l119.7 119.7c15.62 15.62 40.95 15.62 56.57 0C515.9 484.7 515.9 459.3 500.3 443.7zM79.1 208c0-70.58 57.42-128 128-128s128 57.42 128 128c0 70.58-57.42 128-128 128S79.1 278.6 79.1 208z"></path>
									</svg><!-- <span class="fas fa-search search-box-icon"></span> Font Awesome fontawesome.com -->
								</form>
							</div>
						</div>
						<div class="col-auto">
							<button class="btn btn-sm btn-phoenix-secondary bg-white hover-bg-100 me-2" type="button">검색</button>
						</div>
					<hr/>
					</div>
		        	<b>기안서 양식을 선택해주세요</b><br>
		        		<c:forEach items="${docList }" var="doc">
		        			<div style="display: flex; margin-left: 28%;">
		        				<input class="form-check-input" name="atrzfName" type="radio" value="${doc.atrzfCd }" />
		        				&nbsp;&nbsp;${doc.atrzfName }<br>
		        			</div>
		        		</c:forEach>
		      </div>
		      <div class="modal-footer">
	     		<button class="btn btn-info" type="button" id="okBtn">확인</button>
	      		<button class="btn btn-outline-info" type="button" data-bs-dismiss="modal">취소</button>
		      </div>
		    </div>
		  </div>
		</div>
	</div>
</div>
<br>
<br>
<script type="text/javascript">
$(function(){
	CKEDITOR.replace("ckeditor");
	CKEDITOR.config.width = "100%";
	CKEDITOR.config.height = "500px";

	var ckeditor = $("#ckeditor");
	//기안서 선택 후 양식 불러오기 버튼
	var okBtn = $("#okBtn");
	
	okBtn.on("click", function(){
		var atrzfCd = $("input[name=atrzfName]:checked").val();
		var scrollingLong2 = $("#scrollingLong2");
		//console.log(atrzfName);
		
		var data = {
			atrzfCd : atrzfCd
		} 
		
		authFormCd = atrzfCd;
		console.log(authFormCd);
		// AJAX 요청을 보내는 부분 (서버로 데이터 전송)
         $.ajax({
             type: "post", 				 // 또는 "GET" 등 HTTP 요청 메서드 설정
             url: "/draft/write.do", 	 // 요청을 보낼 서버의 URL
             data: JSON.stringify(data), // 선택된 데이터를 JSON 형태로 전송
             contentType: "application/json; charset=utf-8", // 요청 본문 데이터 타입
           	 success: function(res) {
               var contents= CKEDITOR.instances.ckeditor.getData();
               //console.log("결재선라인 : "+ line);
               CKEDITOR.instances.ckeditor.setData(res);
               //console.log("결재문서양식 : "+res); 
            }
         });
         $("input").remove("#formCd"); //양식을 다른 걸 선택할 시(중복되는 걸 막음) 
         $("#tempForm").append(`<input type="hidden" name="atrzfCd" value="`+authFormCd+`" id="formCd">`);
         $("#selectForm").modal("hide"); 
	});
	
	
	
});




</script>
