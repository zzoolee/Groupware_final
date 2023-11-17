<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<h2>휴지통</h2>
<br>
<div class="card">
	<div class="card-body">
	<!-- 검색창 포함 테이블 -->
		<div id="addressTable" data-list='{"valueNames":["sender","title"],"page":8,"pagination":true}'> <!-- 검색, 페이징 설정 -->
			<div class="row align-items-center justify-content-between g-3 mb-4">
			  <div class="d-flex justify-content-center align-items-center border-0">
			    <!-- 검색창 -->
			    <div class="search-box">
			      <form class="position-relative" data-bs-toggle="search" data-bs-display="static">
			        <input class="form-control search-input search" type="search" placeholder="Search mails" aria-label="Search">
			        <span class="fas fa-search search-box-icon"></span>
			      </form>
			    </div>
			    <div class="d-flex justify-content-center">
				</div>	  
			  </div>
			</div>
			
			<div class="table-responsive"> <!-- 클래스 지정 -->
			<table class="table table-hover" style="vertical-align: middle;">
			  <thead>
			    <tr class="bg-light" style="text-align: center;">
			      <th style="width:10%">
			      	<input class="form-check-input mb-2 m-sm-0 me-sm-2" type="checkbox" data-bulk-select-row="data-bulk-select-row" id="allCheckBox" />
			      	<button class="btn p-0 me-2" data-bs-toggle="tooltip" data-bs-placement="top" data-bs-title="삭제하기" id="deleteMailBtn" style="transform: scale(1.5);">
					    <span class="uil uil-trash"></span>
					 </button>
					 |&nbsp;
					 <button class="btn p-0 me-2" data-bs-toggle="tooltip" data-bs-placement="top" data-bs-title="복구하기" id="resMailBtn" style="transform: scale(1.5);">
							<span class="text-700 uil uil-redo"></span>
					 </button>
			      </th>
<!-- 			      <th>&nbsp;</th> -->
			      <th>보낸이</th>
			      <th>제목</th>
			      <th>수신날짜</th>
			    </tr>
			  </thead>
		  	<tr> 
		  
						<!-- 상단 메뉴 버튼 (삭제 중요메일) -->
				
			 </tr>
			  <tbody class="list"> <!-- 클래스 지정, td에 class 지정(valueNames로) -->
			  	<c:if test="${empty mailList}">
			  	  <tr style="text-align: center;"><td colspan="4">삭제한 메일이 존재하지 않습니다.</tr>
			  	</c:if>
			  	<c:if test="${!empty mailList }">
			  	<c:forEach items="${mailList }" var="mailAll">
				    <tr class="hover-actions-trigger btn-reveal-trigger position-static" style="text-align: center;">
			  	<form action="/sendmail.do" method="POST" id="${mailAll.mailNo }">
				     <td style="width:100px;">
				      	<input class="form-check-input mb-2 m-sm-0 me-sm-2 mailSelectBox" type="checkbox" id="checkbox-1" data-value="${mailAll.mailNo }" data-bulk-select-row="data-bulk-select-row" />
				     </td>
<!-- 				     <td> -->
<%-- 				      	<button class="btn p-0 mailLike" id="mailLike_${mailAll.mailNo }" type="button" style="transform: scale(1);" data-value="${mailAll.mailNo }" style="cursor:pointer"> --%>
<%-- 				      		<c:choose> --%>
<%-- 				      			<c:when test="${mailAll.mailImpse eq '1' }"> --%>
<!-- 						      		<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-star text-warning" viewBox="0 0 16 16"> -->
<!-- 				  						<path d="M2.866 14.85c-.078.444.36.791.746.593l4.39-2.256 4.389 2.256c.386.198.824-.149.746-.592l-.83-4.73 3.522-3.356c.33-.314.16-.888-.282-.95l-4.898-.696L8.465.792a.513.513 0 0 0-.927 0L5.354 5.12l-4.898.696c-.441.062-.612.636-.283.95l3.523 3.356-.83 4.73zm4.905-2.767-3.686 1.894.694-3.957a.565.565 0 0 0-.163-.505L1.71 6.745l4.052-.576a.525.525 0 0 0 .393-.288L8 2.223l1.847 3.658a.525.525 0 0 0 .393.288l4.052.575-2.906 2.77a.565.565 0 0 0-.163.506l.694 3.957-3.686-1.894a.503.503 0 0 0-.461 0z"/> -->
<!-- 									</svg> -->
<%-- 				      			</c:when> --%>
<%-- 				      			<c:otherwise> --%>
<!-- 									<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-star-fill text-warning" viewBox="0 0 16 16"> -->
<!-- 									  <path d="M3.612 15.443c-.386.198-.824-.149-.746-.592l.83-4.73L.173 6.765c-.329-.314-.158-.888.283-.95l4.898-.696L7.538.792c.197-.39.73-.39.927 0l2.184 4.327 4.898.696c.441.062.612.636.282.95l-3.522 3.356.83 4.73c.078.443-.36.79-.746.592L8 13.187l-4.389 2.256z"/> -->
<!-- 									</svg> -->
<%-- 				      			</c:otherwise> --%>
<%-- 				      		</c:choose> --%>
		<%--  					<span class='<c:if test="${mailAll.mailImpse eq '2' }">text-warning</c:if>uil uil-favorite mailLike' data-value="${mailAll.mailNo }" style="cursor:pointer"></span> --%>
<!-- 						</button> -->
<!-- 				      </td> -->
				      <td class="sender" style="width:200px;">${mailAll.mailsEmpname }</td>
				      <td class="title" style="width:800px; text-align: left; padding-left: 100px;">
				      	<a class="d-block inbox-link">
							<p class="ps-0 fw-bold mb-0 line-clamp-3 detailSelector" style="cursor:pointer;" data-value="${mailAll.mailNo }">${mailAll.mailTitle }</p>
						</a>
					  </td>
				      <td>
				      	<fmt:formatDate value="${mailAll.mailDate}" pattern="yyyy-MM-dd HH:mm" var="isThisToday" />
				      	<div class="font-sans-serif btn-reveal-trigger position-static">
				      	<span>${isThisToday}</span>
			            </div>
				      </td>	
				    </form>
				     </tr>
			    </c:forEach>
			    </c:if>
			  </tbody>
			</table>
			</div>
		    <div class="d-flex justify-content-center mt-3">
		      <button class="page-link" data-list-pagination="prev"><span class="fas fa-chevron-left"></span></button>
		      <ul class="mb-0 pagination"></ul>
		      <button class="page-link pe-0" data-list-pagination="next"><span class="fas fa-chevron-right"></span></button>
		    </div>
		    <br>
		</div>
	</div>
</div>
<!--  -->
<input type="hidden" value="true" id="checkFlag" />
<!-- 체크된 애들을 모아놓는 곳. -->
<form action="" method="POST" id="selectBoxForm">
	<input type="hidden" value="" name="mailArray" class="mailSelectArray"/>
</form>






<script>

$(function() {

	$(document).on('click','.detailSelector', function(){
		console.log($(this).data('value'));
		location.href="/receivedMailDetail.do?mailNo="+$(this).data('value');
	});
	
	// 전체 체크박스 처리에 필요한 변수
	var mailSelectBox = $('.mailSelectBox'); // 클래스로 정의된 개인 체크박스들.
	// 전체체크박스 처리
	$(document).on("click", '#allCheckBox', function() {
		if ($('#checkFlag').val() == "true") {
			console.log("트루");
			$('.mailSelectBox').prop('checked', true);
			$('#checkFlag').val('false');
			mailSelectBox.prop('checked', true);
		} else {
			console.log("펄스");
			$('#checkFlag').val('true');
			$('.mailSelectBox').prop('checked', false);
		}
	});
	
	
	// 별모양 버튼을 눌렀을때 좋아요를 수정해줄 ajax문
	$(document).on("click",".mailLike",function(){
		console.log($(this).data('value'));
		// 돔요소 자체를 가져올 예정이므로 제이쿼리 선택자가 아닌 돔선택자를 사용.
		var starIcon = this;
		console.log(this);
		console.log(starIcon);
		var mailNo = $(this).data('value');
		var mailNo = {
				"mailNo" : mailNo
		}
		$.ajax({
			type : "POST",
			url : "/mailLikeAjax.do",
			data : JSON.stringify(mailNo),
			contentType : "application/json; charset=utf-8",
			success : function(result){
				// 반환값으로 vo를 가져와서 그안에 fileLikese에 따라 class를 변경해준다.
				// 클래스내용을 변경할땐 classList.remove('내용'); 혹은 classList.add('내용'); 을 사용한다.
				if(result.mailLike.mailImpse == "1") {
					console.log(starIcon);
					console.log('1일떄');
					starIcon.classList.remove('text-warning');
				} else if (result.mailLike.mailImpse == "2") {
					console.log(starIcon);
					console.log('2일떄');
					starIcon.classList.add('text-warning');
				}
			}
		})
	});

	// 삭제 버튼을 눌렀을때의 이벤트.
	$(document).on('click', '#deleteMailBtn', function() {
		
		var mailList = []; // 히든에 있는메일 어레이에 담아준 어레이변수.
		var mailSelectArray = $('.mailSelectArray'); // 히든으로 되어있는 인풋의 클래스값.
		var selectBoxDelForm = $('#selectBoxForm'); // 히든으로 되어있는 인풋을 서브밋해줄 form값.
		
		// 체크박스 체크된 파일코드 어레이에 넣기.
		$('.mailSelectBox').each(function() {
			if ($(this).is(":checked") == true) {
				console.log($(this).data('value'));
				mailList.push($(this).data('value'));
			}
		})
		console.log(mailList)
			console.log('랭쓰 : ' + mailList.length);
		if (mailList.length == 0) {
			alert('메일을 선택해주세요');
			return false;
		}

		if (mailList != null) {
			mailSelectArray.val(mailList);
		}
		customConfirm('휴지통에서 삭제 된 메일은 다시 복구가 되지 않습니다. 정말 삭제하시겠습니까?').then((userConfirmed) => {
	          if (userConfirmed) {
				$('#selectBoxForm').prop('action', '/deleteMailAll.do');
				selectBoxForm.submit();
	          } else {
	        	  return false;
	          }
		})
	});
	
	
	// 복구 버튼을 눌렀을때의 이벤트.
	$(document).on('click', '#resMailBtn', function() {
		
		var mailList = []; // 히든에 있는메일 어레이에 담아준 어레이변수.
		var mailSelectArray = $('.mailSelectArray'); // 히든으로 되어있는 인풋의 클래스값.
		var selectBoxDelForm = $('#selectBoxForm'); // 히든으로 되어있는 인풋을 서브밋해줄 form값.
		
		// 체크박스 체크된 파일코드 어레이에 넣기.
		mailSelectBox.each(function() {
			if ($(this).is(":checked") == true) {
				console.log($(this).data('value'));
				mailList.push($(this).data('value'));
			}
		})
		console.log(mailList)
			console.log('랭쓰 : ' + mailList.length);
		if (mailList.length == 0) {
			alert('메일을 선택해주세요');
			return false;
		}

		if (mailList != null) {
			mailSelectArray.val(mailList);
		}
		customConfirm('받은 메일함으로 복구하시겠습니까?').then((userConfirmed) => {
	          if (userConfirmed) {
				$('#selectBoxForm').prop('action', '/resMail.do');
				selectBoxForm.submit();
	          } else {
	        	  return false;
	          }
		})
	});
});
</script>



