<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<h2>내게쓴메일함</h2>
<br>

<div class="card">
	<div class="card-body">
	<!-- 검색창 포함 테이블 -->
		<div id="mailTable" data-list='{"valueNames":["receiver","title"],"page":8,"pagination":true}'> <!-- 검색, 페이징 설정 -->
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
			      <th scope="col">
			      	<input class="form-check-input  mb-2 m-sm-0 me-sm-2" type="checkbox" data-bulk-select-row="data-bulk-select-row" id="allCheckBox" />
			      	<button class="btn p-0 me-2" data-bs-toggle="tooltip" data-bs-placement="top" data-bs-title="삭제하기" id="deleteMailBtn" style="transform: scale(1.5);">
					    <span class="uil uil-trash"></span>
					</button>
			      </th>
			      <th scope="col">받는이</th>
			      <th scope="col">제목</th>
			      <th scope="col">발신날짜</th>
			    </tr>
			  </thead>
		  	<tr> 
						<!-- 상단 메뉴 버튼 (삭제 중요메일) -->
			 </tr>
			  <tbody class="list"> <!-- 클래스 지정, td에 class 지정(valueNames로) -->
			  	<c:if test="${empty mailList}">
			  	  <tr style="text-align: center;"><td colspan="7">내게쓴메일이 존재하지 않습니다.</tr>
			  	</c:if>
			  	
			  	<c:if test="${!empty mailList }">
			  	<c:forEach items="${mailList }" var="mailAll">
				  	<form action="/sendmail.do" method="POST" id=${mailAll.mailNo }>
					    <tr class="hover-actions-trigger btn-reveal-trigger position-static" style="text-align: center;">
						      <td>
						      	<input class="form-check-input mb-2 m-sm-0 me-sm-2 mailSelectBox" type="checkbox" id="checkbox-1" data-value="${mailAll.mailNo }" data-bulk-select-row="data-bulk-select-row" />
						      	  <input type="hidden" value="${mailAll.mailNo }" name="mailNo" id="${mailAll.mailNo }+'no'"/>
						      	  <!-- input td 밖으로 빼면 페이징 오류 -->
									<input type="hidden" value="${mailAll.mailTitle }" name="mailTitle"/>
									<input type="hidden" value="${mailAll.mailContent }" name="mailContent"/>
									<input type="hidden" value="${mailAll.mailDate }" name="mailDate"/>
									<input type="hidden" value="${mailAll.mailrEmpno }" name="mailDate"/>
									<input type="hidden" value="${mailAll.mailsEmpno }" name="mailsEmpno"/>
									<input type="hidden" value="${mailAll.mailImpse }" name="mailImpse"/>
									<input type="hidden" value="${mailAll.mailDelse }" name="mailDelse"/>
									<input type="hidden" value="${mailAll.mailFileno }" name="mailFileno"/>
									<input type="hidden" value="${mailAll.mailChkse }" name="mailChkse"/>
									<input type="hidden" value="${mailAll.mailrEmpname }" name="mailrEmpname"/>
									<input type="hidden" value="${mailAll.mailsEmpname }" name="mailsEmpname"/>
						      </td>
						      <td class="receiver">
						      	${mailAll.mailsEmpname }
						      </td>
						      <td class="title" style="text-align: left; padding-left:100px;">
						      	<a class="d-block inbox-link"">
						      		<!-- 작성제목 -->
									<p class="ps-0 fw-bold text-1100 mb-0 line-clamp-3 detailSelector" style="cursor:pointer" data-value="${mailAll.mailNo }">${mailAll.mailTitle }</p>
								</a>
							  </td>
						      <td>
						      	<fmt:formatDate value="${mailAll.mailDate}" pattern="yyyy-MM-dd HH:mm" var="isThisToday" />
						      	<div class="font-sans-serif btn-reveal-trigger position-static">
						      	<span>${isThisToday}</span>
					            </div>
						      </td>	
					     </tr>
					  </form>
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
$(function(){
	
	$(document).on('click','.detailSelector', function(){
		console.log($(this).data('value'));
		location.href="/receivedMailDetail.do?mailNo="+$(this).data('value');
	});
	
	
	// 전체 체크박스 처리에 필요한 변수
	var mailSelectBox = $('.mailSelectBox'); // 클래스로 정의된 개인 체크박스들.
	// 전체체크박스 처리
	$(document).on("click",'#allCheckBox',function(){
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
	
	// 삭제 버튼을 눌렀을때의 이벤트.
	$(document).on('click', '#deleteMailBtn', function() {
		
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
		customConfirm('해당 메일을 삭제하시겠습니까?').then((userConfirmed) => {
	          if (userConfirmed) {
				$('#selectBoxForm').prop('action', '/mailMyselfDelete.do');
				selectBoxForm.submit();
	          } else {
	        	  return false;
	          }
		})
	});
	
	
});
</script>



