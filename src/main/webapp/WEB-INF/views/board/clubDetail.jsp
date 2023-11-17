<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<style>
.hidden {
    display: none !important;
}
</style>

<c:if test="${tab eq 'main' }">
	<c:set value="active" var="mainActive"/>
	<c:set value="show active" var="mainShowActive"/>
</c:if>
<c:if test="${tab eq 'notice' }">
	<c:set value="active" var="noticeActive"/>
	<c:set value="show active" var="noticeShowActive"/>
</c:if>
<c:if test="${tab eq 'free' }">
	<c:set value="active" var="freeActive"/>
	<c:set value="show active" var="freeShowActive"/>
</c:if>
<c:if test="${tab eq 'activity' }">
	<c:set value="active" var="activityActive"/>
	<c:set value="show active" var="activityShowActive"/>
</c:if>
<c:if test="${tab eq 'manage' }">
	<c:set value="active" var="manageActive"/>
	<c:set value="show active" var="manageShowActive"/>
</c:if>

<c:if test="${not empty message }">
	<script type="text/javascript">
		alert("${message}");
		<c:remove var="message" scope="request"/>
		<c:remove var="message" scope="session"/>
	</script>
</c:if>

<sec:authentication property='principal.emp.empNo' var="empNo"/>
<sec:authentication property='principal.emp.empName' var="empName"/>
<sec:authentication property='principal.emp.empPhoto' var="empPhoto"/>

<c:set value="${club.clubCd }" var="clubCd"/>

<!-- 권한 부여 : clubRank가  clubHead면 회장, clubMem면 회원, notMem면 비회원 -->
<c:set value="notMem" var="clubRank"/>
<c:if test="${club.clubEmpno eq empNo }">
	<c:set value="clubHead" var="clubRank"/>
<!-- 	<script type="text/javascript"> -->
<!-- // 		alert("회장임"); -->
<!-- 	</script> -->
</c:if>
<c:forEach items="${club.memberList }" var="mem">
	<c:if test="${mem.cmEmpno eq empNo}">
		<c:set value="clubMem" var="clubRank"/>
<!-- 		<script type="text/javascript"> -->
<!-- // 			alert("멤버임"); -->
<!-- 		</script> -->
	</c:if>
</c:forEach>

<div class="d-flex justify-content-between align-items-center border-0">
<div class="mb-5">
  <div class="d-flex justify-content-between">
    <h2 class="text-black fw-bolder mb-2">${club.clubName }</h2>&nbsp;&nbsp;
    <c:if test="${clubRank eq 'notMem'}">
	    <button class="btn btn-outline-info me-1 mb-1" type="button" data-bs-toggle="modal" data-bs-target="#joinModal">가입하기</button>
    </c:if>
    <c:if test="${clubRank eq 'clubHead'}">
	    <button class="btn btn-outline-success me-1 mb-1" type="button" data-bs-toggle="modal" data-bs-target="#clubInfoModal">동호회관리</button>
    </c:if>
    <c:if test="${clubRank eq 'clubMem'}">
	    <button class="btn btn-outline-warning me-1 mb-1" type="button" id="leaveClub" data-clubcd="${clubCd }" data-empno="${empNo }">탈퇴하기</button>
    </c:if>
  </div>
</div>
<ul class="nav nav-underline" id="myTab" role="tablist" data-empno="${empNo }" data-clubcd="${clubCd }">
  <li class="nav-item"><a class="nav-link fs-2 ${mainActive }" id="main-tab" data-bs-toggle="tab" href="#tab-main" role="tab" aria-controls="tab-main" aria-selected="true">메인</a></li>
  <li class="nav-item"><a class="nav-link fs-2 ${noticeActive }" id="notice-tab" data-bs-toggle="tab" href="#tab-notice" role="tab" aria-controls="tab-notice" aria-selected="false">공지사항</a></li>
  <li class="nav-item"><a class="nav-link fs-2 ${freeActive }" id="free-tab" data-bs-toggle="tab" href="#tab-free" role="tab" aria-controls="tab-free" aria-selected="false">자유게시판</a></li>
  <li class="nav-item"><a class="nav-link fs-2 ${activityActive }" id="activity-tab" data-bs-toggle="tab" href="#tab-activity" role="tab" aria-controls="tab-activity" aria-selected="false">활동내역</a></li>
  <c:if test="${clubRank eq 'clubHead'}">
  	<li class="nav-item"><a class="nav-link fs-2 ${manageActive }" id="manage-tab" data-bs-toggle="tab" href="#tab-manage" role="tab" aria-controls="tab-manage" aria-selected="false">회원관리</a></li>
  </c:if>
</ul>
</div>

<div class="tab-content mt-3" id="myTabContent">

  <div class="tab-pane fade ${mainShowActive }" id="tab-main" role="tabpanel" aria-labelledby="main-tab">
  	<div class="row g-0">
          <div class="col-12 col-xxl-6 px-0 bg-soft">
            <div class="px-4 px-lg-6 pt-6 pb-9">
<!--               <div class="row gx-0 gx-sm-5 gy-8 mb-8"> -->
<!--                 <div class="col-12 col-xl-9 col-xxl-8"> -->
                  <div class="row flex-between-center mb-3 g-3">
                    <div class="col-auto">
                      <img src="${club.clubPhoto }" style="width:700px;height:500px;"><br>
                    </div>
                  </div>
<!--                 </div> -->
<!--                 <div class="col-12 col-sm-7 col-lg-8 col-xl-5"> -->
                  <h4 class="text-1100 mb-4">${club.clubInfo }</h4>
<!--                 </div> -->
<!--               </div> -->
<!--               <h3 class="text-1100 mb-4">Project overview</h3> -->
<!--               <p class="text-800 mb-4">The new redirection team is happy to announce that we’ve fixed all our unresponsive URLs and redirected them to new URLs. The tremendous assistance from our support team and the dev team, as well as that of the team lead’s, this team has made an impossible possible within a week. They didn’t stop for a moment, and we got our pages working again for all the valuable users. </p> -->
<!--               <p class="text-800 mb-0">Join us in celebrating the massive success of data transferring and getting us a huge revenue by eating out. Free public viewing and a buffet is offered for the great team as well as for the other teams working with us. We’ll be checking out places for the best option available at hands and we’ll let you know the schedule once we decide on one.<a class="fw-semi-bold" href="#!">read more </a></p> -->
            </div>
          </div>
          <div class="col-12 col-xxl-6 px-0">
          	<div class="px-4 px-lg-6 pt-6 pb-9">
            <div class="w-100">
              <div class="bg-light dark__bg-1100 h-100 text-center" style="padding:30px;">
              	<div class="row">
              		<div class="col-4">
              			<h3 class="text-1000 mb-4 fw-bold">동호회장</h3>
              		</div>
              		<div class="col-4">
              			<h3 class="text-1000 mb-4 fw-bold">회원수</h3>
              		</div>
              		<div class="col-4">
              			<h3 class="text-1000 mb-4 fw-bold">개설일</h3>
              		</div>
              	</div>
              	<div class="row">
              		<div class="col-4">
              			<span class="fs-2">${club.empName }</span>
              		</div>
              		<div class="col-4">
              			<span class="fs-2">${club.memCount }명</span>
              		</div>
              		<div class="col-4">
              			<span class="fs-2"><fmt:formatDate value="${club.clubDate }" pattern="yyyy-MM-dd"/></span>
              		</div>
              	</div>
              </div>
              <br>
              <br>
              	<div class="row">
              		<img src="/resources/assets/gw/clubimg.png">
              	</div>
<!--                 <div class="p-4 p-lg-6"> -->
                  
                  
<!--                 </div> -->
<!--                 <div class="p-4 p-lg-6"> -->
                  
                  
<!--                 </div> -->
<!--                 <div class="p-4 p-lg-6"> -->
                  
                  
<!--                 </div> -->
            </div>
            </div>
          </div>
  	</div>
  </div>
  
  <div class="tab-pane fade ${noticeShowActive }" id="tab-notice" role="tabpanel" aria-labelledby="notice-tab">
  	<div class="card mt-7" id="notice" style="border-radius:20px; padding:20px;">
		<!-- 검색창 포함 테이블 -->
		<div id="noticeTable" data-list='{"valueNames":["no","title","writer","date"],"page":8,"pagination":true}'> <!-- 검색, 페이징 설정 -->
			<div class="row align-items-center justify-content-between g-3 mb-4">
			  <div class="d-flex justify-content-end">
			    <!-- 검색창 -->
			    <div class="search-box">
			      <form class="position-relative" data-bs-toggle="search" data-bs-display="static">
			        <input class="form-control search-input search" type="search" placeholder="" aria-label="Search">
			        <span class="fas fa-search search-box-icon"></span>
			      </form>
			    </div> 
			  </div>
			</div>
			
			<div class="table-responsive"> <!-- 클래스 지정 -->
			<table class="table table-hover" style="vertical-align: middle;">
			  <thead>
			    <tr style="text-align: center;">
			      <th scope="col">번호</th>
			      <th scope="col">제목</th>
			      <th scope="col">작성자</th>
			      <th scope="col">작성일</th>
			      <th scope="col">조회수</th>
			    </tr>
			  </thead>
			  <tbody class="list"> <!-- 클래스 지정, td에 class 지정(valueNames로) -->
			  	<c:choose>
			  		<c:when test="${empty club.clubNOPostList }">
				  		<tr style="text-align: center;">
				  			<td colspan="5">게시글이 존재하지 않습니다.</td>
				  		</tr>
			  		</c:when>
			  		<c:otherwise>
			  			<c:forEach items="${club.clubNOPostList }" var="noPost">
						    <tr class="hover-actions-trigger btn-reveal-trigger position-static">
						      <td class="no col-2" style="text-align: center;">${noPost.cpNo }</td>
						      <td class="title col-5">
						      	<a href="" name="postDetail" data-cpno="${noPost.cpNo }" data-sort="notice">${noPost.cpTitle }</a>
						      </td>
						      <td class="writer col-2" style="text-align: center;">${noPost.empName }</td>
						      <td class="date col-2" style="text-align: center;"><fmt:formatDate value="${noPost.cpDate }" pattern="yyyy-MM-dd"/></td>
						      <td class="hit col-1" style="text-align: center;">${noPost.cpHit }</td>
						    </tr>
					    </c:forEach>
			  		</c:otherwise>
			  	</c:choose>
			  </tbody>
			</table>
			<c:if test="${clubRank eq 'clubHead'}">
				<div class="d-flex justify-content-end">
				    <button class="btn btn-info me-1 mb-1" name="writeBtn" data-sort="notice">글쓰기</button>
				</div>
			</c:if>
			</div>
		    <div class="d-flex justify-content-center mt-3">
		      <button class="page-link" data-list-pagination="prev"><span class="fas fa-chevron-left"></span></button>
		      <ul class="mb-0 pagination"></ul>
		      <button class="page-link pe-0" data-list-pagination="next"><span class="fas fa-chevron-right"></span></button>
		    </div>
			
		    <br>
		</div>
	</div>
	
	<!-- 게시글 등록/수정 페이지 -->
	<div class="card mt-7" name="writeTable" style="border-radius:20px; padding:20px; display: none;">
		<form class="row g-3 needs-validation" novalidate="" method="post" action="/clubboard/insert.do" enctype="multipart/form-data">
			<input type="hidden" name="clubCd" value="${club.clubCd }">
			<input type="hidden" name="cbCd" value="NO">
			<input type="hidden" name="cpNo" value="cpNo">
			<div class="col-12 col-sm-6 col-xl-12">
				<div class="mb-4">
					<div class="d-flex flex-wrap mb-2">
						<h5 class="mb-0 text-1000 me-2">제목</h5><span class="text-danger">*</span>
					</div>
					<input class="form-control mb-xl-3" type="text" name="cpTitle" required="">
				</div>
			</div>
			<div class="col-12 col-sm-6 col-xl-12">
				<div class="mb-4">
					<div class="d-flex flex-wrap mb-2">
						<h5 class="mb-0 text-1000 me-2">작성자</h5><span class="text-danger">*</span>
					</div>
					<span class="text-secondary">${empName }</span>
				</div>
			</div>
			<div class="col-12 col-sm-6 col-xl-12">
				<div class="mb-4">
					<div class="d-flex flex-wrap mb-2">
						<h5 class="mb-0 text-1000 me-2">내용</h5><span class="text-danger">*</span>
					</div>
					<textarea class="form-control" id="ckeditor_notice" name="cpContent" rows="3" required=""></textarea>
				</div>
			</div>
			<div class="col-12 col-sm-6 col-xl-12">
				<div class="mb-4">
					<div class="d-flex flex-wrap mb-2">
						<h5 class="mb-0 text-1000 me-2">첨부파일</h5>
					</div>
					<input class="form-control" type="file" multiple="multiple" name="files">
				</div>
			</div>
			<div name="cpfiles"></div>
			
			<div class="d-flex justify-content-end mt-3">
				<button class="btn btn-info me-1 mb-1" type="submit" style="width:80px;">저장</button>
				<button class="btn btn-outline-info me-1 mb-1" type="button" onclick="history.back()" style="width:80px;">취소</button>
			</div>
		</form>
	</div>
	
	<!-- 게시글 상세 페이지 -->
	<div class="card mt-7" name="detailTable" style="border-radius:20px; padding:50px; display: none;">
		<div class="row d-flex justify-content-center text-center" style="padding:20px;">
			<h3 name="cpTitle"></h3>
		</div>
		<div class="d-flex justify-content-between align-items-center border-0" style="padding:30px;">
			<div><span name="empName"></span> / <span name="cpDate"></span></div>
			<div>조회수 : <span name="cpHit"></span></div>
		</div>
		<div class="d-flex justify-content-end mt-3" name="myBtn" data-empno="">
		  	<button class="btn btn-phoenix-secondary btn-sm" name="modifyBtn" data-sort="notice">
		      <svg class="svg-inline--fa fa-pencil fs--2 mr-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="pencil" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg=""><path fill="currentColor" d="M421.7 220.3L188.5 453.4L154.6 419.5L158.1 416H112C103.2 416 96 408.8 96 400V353.9L92.51 357.4C87.78 362.2 84.31 368 82.42 374.4L59.44 452.6L137.6 429.6C143.1 427.7 149.8 424.2 154.6 419.5L188.5 453.4C178.1 463.8 165.2 471.5 151.1 475.6L30.77 511C22.35 513.5 13.24 511.2 7.03 504.1C.8198 498.8-1.502 489.7 .976 481.2L36.37 360.9C40.53 346.8 48.16 333.9 58.57 323.5L291.7 90.34L421.7 220.3zM492.7 58.75C517.7 83.74 517.7 124.3 492.7 149.3L444.3 197.7L314.3 67.72L362.7 19.32C387.7-5.678 428.3-5.678 453.3 19.32L492.7 58.75z"></path></svg><!-- <span class="fas fa-pencil-alt fs--2 mr-2"></span> Font Awesome fontawesome.com --> 수정
		    </button>
		    &nbsp;&nbsp;
		    <button class="btn btn-phoenix-danger btn-sm" name="delBtn">
		      <svg class="svg-inline--fa fa-trash fs--1 mr-2" data-fa-transform="shrink-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="trash" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="" style="transform-origin: 0.4375em 0.5em;"><g transform="translate(224 256)"><g transform="translate(0, 0)  scale(0.875, 0.875)  rotate(0 0 0)"><path fill="currentColor" d="M135.2 17.69C140.6 6.848 151.7 0 163.8 0H284.2C296.3 0 307.4 6.848 312.8 17.69L320 32H416C433.7 32 448 46.33 448 64C448 81.67 433.7 96 416 96H32C14.33 96 0 81.67 0 64C0 46.33 14.33 32 32 32H128L135.2 17.69zM394.8 466.1C393.2 492.3 372.3 512 346.9 512H101.1C75.75 512 54.77 492.3 53.19 466.1L31.1 128H416L394.8 466.1z" transform="translate(-224 -256)"></path></g></g></svg><!-- <span class="fa-solid fa-trash fs--1 mr-2" data-fa-transform="shrink-2"></span> Font Awesome fontawesome.com --> 삭제
		    </button>
		</div>
		
		<div class="row">
			<div class="col-12">
				<hr>
			</div>
		</div>
		
		<div name="cpContent" style="padding:30px;"></div>
		
		<div name="cpfiles"></div>
		
	</div>
	
  </div>
  
  <div class="tab-pane fade ${freeShowActive }" id="tab-free" role="tabpanel" aria-labelledby="free-tab">
  	<div class="card mt-7" id="free" style="border-radius:20px; padding:20px;">
		<!-- 검색창 포함 테이블 -->
		<div id="freeTable" data-list='{"valueNames":["no","title","writer","date"],"page":8,"pagination":true}'> <!-- 검색, 페이징 설정 -->
			<div class="row align-items-center justify-content-between g-3 mb-4">
			  <div class="d-flex justify-content-end">
			    <!-- 검색창 -->
			    <div class="search-box">
			      <form class="position-relative" data-bs-toggle="search" data-bs-display="static">
			        <input class="form-control search-input search" type="search" placeholder="" aria-label="Search">
			        <span class="fas fa-search search-box-icon"></span>
			      </form>
			    </div> 
			  </div>
			</div>
			
			<div class="table-responsive"> <!-- 클래스 지정 -->
			<table class="table table-hover" style="vertical-align: middle;">
			  <thead>
			    <tr style="text-align: center;">
			      <th scope="col">번호</th>
			      <th scope="col">제목</th>
			      <th scope="col">작성자</th>
			      <th scope="col">작성일</th>
			      <th scope="col">조회수</th>
			    </tr>
			  </thead>
			  <tbody class="list"> <!-- 클래스 지정, td에 class 지정(valueNames로) -->
			  	<c:choose>
			  		<c:when test="${empty club.clubFRPostList }">
				  		<tr style="text-align: center;">
				  			<td colspan="5">게시글이 존재하지 않습니다.</td>
				  		</tr>
			  		</c:when>
			  		<c:otherwise>
			  			<c:forEach items="${club.clubFRPostList }" var="frPost">
						    <tr class="hover-actions-trigger btn-reveal-trigger position-static">
						      <td class="no col-2" style="text-align: center;">${frPost.cpNo }</td>
						      <td class="title col-5">
						      	<a href="" name="postDetail" data-cpno="${frPost.cpNo }" data-sort="free">${frPost.cpTitle }</a>
						      	<span class="badge bg-info-500 ms-2">${frPost.cmCnt }</span>
						      </td>
						      <td class="writer col-2" style="text-align: center;">${frPost.empName }</td>
						      <td class="date col-2" style="text-align: center;"><fmt:formatDate value="${frPost.cpDate }" pattern="yyyy-MM-dd"/></td>
						      <td class="hit col-1" style="text-align: center;">${frPost.cpHit }</td>
						    </tr>
					    </c:forEach>
			  		</c:otherwise>
			  	</c:choose>
			  </tbody>
			</table>
			<c:if test="${clubRank ne 'notMem'}">
				<div class="d-flex justify-content-end">
				    <button class="btn btn-info me-1 mb-1" name="writeBtn" data-sort="free">글쓰기</button>
				</div>
			</c:if>
			</div>
		    <div class="d-flex justify-content-center mt-3">
		      <button class="page-link" data-list-pagination="prev"><span class="fas fa-chevron-left"></span></button>
		      <ul class="mb-0 pagination"></ul>
		      <button class="page-link pe-0" data-list-pagination="next"><span class="fas fa-chevron-right"></span></button>
		    </div>
			
		    <br>
		</div>
	</div>
	
	<!-- 게시글 등록/수정 페이지 -->
	<div class="card mt-7" name="writeTable" style="border-radius:20px; padding:20px; display: none;">
		<form class="row g-3 needs-validation" novalidate="" method="post" action="/clubboard/insert.do" enctype="multipart/form-data">
			<input type="hidden" name="clubCd" value="${club.clubCd }">
			<input type="hidden" name="cbCd" value="FR">
			<input type="hidden" name="cpNo" value="cpNo">
			<div class="col-12 col-sm-6 col-xl-12">
				<div class="mb-4">
					<div class="d-flex flex-wrap mb-2">
						<h5 class="mb-0 text-1000 me-2">제목</h5><span class="text-danger">*</span>
					</div>
					<input class="form-control mb-xl-3" type="text" name="cpTitle" required="">
				</div>
			</div>
			<div class="col-12 col-sm-6 col-xl-12">
				<div class="mb-4">
					<div class="d-flex flex-wrap mb-2">
						<h5 class="mb-0 text-1000 me-2">작성자</h5><span class="text-danger">*</span>
					</div>
					<span class="text-secondary">${empName }</span>
				</div>
			</div>
			<div class="col-12 col-sm-6 col-xl-12">
				<div class="mb-4">
					<div class="d-flex flex-wrap mb-2">
						<h5 class="mb-0 text-1000 me-2">내용</h5><span class="text-danger">*</span>
					</div>
					<textarea class="form-control" id="ckeditor_free" name="cpContent" rows="3" required=""></textarea>
				</div>
			</div>
			<div class="col-12 col-sm-6 col-xl-12">
				<div class="mb-4">
					<div class="d-flex flex-wrap mb-2">
						<h5 class="mb-0 text-1000 me-2">첨부파일</h5>
					</div>
					<input class="form-control" type="file" multiple="multiple" name="files">
				</div>
			</div>
			<div name="cpfiles"></div>
			
			<div class="d-flex justify-content-end mt-3">
				<button class="btn btn-info me-1 mb-1" type="submit" style="width:80px;">저장</button>
				<button class="btn btn-outline-info me-1 mb-1" type="button" onclick="history.back()" style="width:80px;">취소</button>
			</div>
		</form>
	</div>
	
	<!-- 게시글 상세 페이지 -->
	<div class="card mt-7" name="detailTable" style="border-radius:20px; padding:50px; display: none;">
		<div class="row d-flex justify-content-center text-center" style="padding:20px;">
			<h3 name="cpTitle"></h3>
		</div>
		<div class="d-flex justify-content-between align-items-center border-0" style="padding:30px;">
			<div><span name="empName"></span> / <span name="cpDate"></span></div>
			<div>조회수 : <span name="cpHit"></span></div>
		</div>
		<div class="d-flex justify-content-end mt-3" name="myBtn" data-empno="">
		  	<button class="btn btn-phoenix-secondary btn-sm" name="modifyBtn" data-sort="free">
		      <svg class="svg-inline--fa fa-pencil fs--2 mr-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="pencil" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg=""><path fill="currentColor" d="M421.7 220.3L188.5 453.4L154.6 419.5L158.1 416H112C103.2 416 96 408.8 96 400V353.9L92.51 357.4C87.78 362.2 84.31 368 82.42 374.4L59.44 452.6L137.6 429.6C143.1 427.7 149.8 424.2 154.6 419.5L188.5 453.4C178.1 463.8 165.2 471.5 151.1 475.6L30.77 511C22.35 513.5 13.24 511.2 7.03 504.1C.8198 498.8-1.502 489.7 .976 481.2L36.37 360.9C40.53 346.8 48.16 333.9 58.57 323.5L291.7 90.34L421.7 220.3zM492.7 58.75C517.7 83.74 517.7 124.3 492.7 149.3L444.3 197.7L314.3 67.72L362.7 19.32C387.7-5.678 428.3-5.678 453.3 19.32L492.7 58.75z"></path></svg><!-- <span class="fas fa-pencil-alt fs--2 mr-2"></span> Font Awesome fontawesome.com --> 수정
		    </button>
		    &nbsp;&nbsp;
		    <button class="btn btn-phoenix-danger btn-sm" name="delBtn">
		      <svg class="svg-inline--fa fa-trash fs--1 mr-2" data-fa-transform="shrink-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="trash" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="" style="transform-origin: 0.4375em 0.5em;"><g transform="translate(224 256)"><g transform="translate(0, 0)  scale(0.875, 0.875)  rotate(0 0 0)"><path fill="currentColor" d="M135.2 17.69C140.6 6.848 151.7 0 163.8 0H284.2C296.3 0 307.4 6.848 312.8 17.69L320 32H416C433.7 32 448 46.33 448 64C448 81.67 433.7 96 416 96H32C14.33 96 0 81.67 0 64C0 46.33 14.33 32 32 32H128L135.2 17.69zM394.8 466.1C393.2 492.3 372.3 512 346.9 512H101.1C75.75 512 54.77 492.3 53.19 466.1L31.1 128H416L394.8 466.1z" transform="translate(-224 -256)"></path></g></g></svg><!-- <span class="fa-solid fa-trash fs--1 mr-2" data-fa-transform="shrink-2"></span> Font Awesome fontawesome.com --> 삭제
		    </button>
		</div>
		
		<div class="row">
			<div class="col-12">
				<hr>
			</div>
		</div>
		
		<div name="cpContent" style="padding:30px;"></div>
		
		<div name="cpfiles"></div>
		
		<br>
		
		<div class="bg-100 border-top p-3 p-sm-4">
		  <div id="comment">
			<!-- 댓글 들어가는 곳 -->
          </div>
          <div class="d-flex align-items-center">
            <div class="avatar avatar-m  me-2">
              <c:if test="${clubRank ne 'notMem'}">
              	<img class="rounded-circle " src="${empPhoto }">
              </c:if>
            </div>
            <div class="flex-1">
            	<div class="d-flex">
		           	<c:if test="${clubRank ne 'notMem'}">
			              <input class="form-control" type="text" placeholder="댓글을 남겨주세요" name="cmContent"></input>&nbsp;
		    	          <button class="btn btn-phoenix-info btn-sm" style="width:100px;" id="commentBtn">등록</button>
		           	</c:if>
		           	<c:if test="${clubRank eq 'notMem'}">
		           		<span style="font-weight: bold;">회원만 댓글을 남길 수 있습니다.</span>
		           	</c:if>
            	</div>
            </div>
          </div>
        </div>
	</div>
	
  </div>
  
  <div class="tab-pane fade ${activityShowActive }" id="tab-activity" role="tabpanel" aria-labelledby="activity-tab">
  <div class="card mt-7" id="activity" style="border-radius:20px; padding:20px;">
    <c:if test="${clubRank eq 'clubHead'}">
	    <div class="d-flex justify-content-end mt-3">
	   		<button class="btn btn-info me-1 mb-1" data-bs-toggle="modal" data-bs-target="#insertActivity">활동내역 추가</button>
	    </div>
    </c:if>
	<div class="card-body">
<!--        <div class="card-title mb-1"> -->
<!--          <h3 class="text-1100">Activity</h3> -->
<!--        </div> -->
<!--        <p class="text-700 mb-4">Recent activity across all projects</p> -->
       <c:choose>
       	<c:when test="${empty club.clubACPostList }">
	       	<span class="text-info" data-feather="alert-circle" style="height: 30px; width: 30px;"></span>
		  	활동내역이 존재하지 않습니다.
       	</c:when>
       	<c:otherwise>
       		<div class="timeline-vertical timeline-with-details">
       			<c:forEach items="${club.clubACPostList }" var="acPost" varStatus="i">
			         <div class="timeline-item position-relative">
			           <div class="row g-md-3" style="padding:10px;">
			             <div class="col-12 col-md-auto d-flex">
			               <div class="timeline-item-date order-1 order-md-0 me-md-4">
			                 <p class="fs-2 fw-semi-bold text-600 text-end">
				                 <fmt:formatDate value="${acPost.cpDate }" pattern="yyyy-MM-dd"/>
<!-- 				                 <br class="d-none d-md-block"> -->
			                 </p>
			               </div>
			               <div class="timeline-item-bar position-md-relative me-3 me-md-0 border-400">
			                 <div class="icon-item icon-item-sm rounded-7 shadow-none bg-primary-100"></div>
			                 <c:if test="${i.count != fn:length(club.clubACPostList) }">
				                 <span class="timeline-bar border-end border-dashed border-400"></span>
			                 </c:if>
			               </div>
			             </div>
			             <div class="col">
			               <c:if test="${clubRank eq 'clubHead'}">
			               <div class="float-end">
							  	<button class="btn btn-phoenix-secondary btn-sm" name="modifyActivity" data-cpno="${acPost.cpNo }">
							      <svg class="svg-inline--fa fa-pencil fs--2 mr-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="pencil" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg=""><path fill="currentColor" d="M421.7 220.3L188.5 453.4L154.6 419.5L158.1 416H112C103.2 416 96 408.8 96 400V353.9L92.51 357.4C87.78 362.2 84.31 368 82.42 374.4L59.44 452.6L137.6 429.6C143.1 427.7 149.8 424.2 154.6 419.5L188.5 453.4C178.1 463.8 165.2 471.5 151.1 475.6L30.77 511C22.35 513.5 13.24 511.2 7.03 504.1C.8198 498.8-1.502 489.7 .976 481.2L36.37 360.9C40.53 346.8 48.16 333.9 58.57 323.5L291.7 90.34L421.7 220.3zM492.7 58.75C517.7 83.74 517.7 124.3 492.7 149.3L444.3 197.7L314.3 67.72L362.7 19.32C387.7-5.678 428.3-5.678 453.3 19.32L492.7 58.75z"></path></svg><!-- <span class="fas fa-pencil-alt fs--2 mr-2"></span> Font Awesome fontawesome.com --> 수정
							    </button>
							    &nbsp;
							    <button class="btn btn-phoenix-danger btn-sm" name="delActivity" data-clubcd="${acPost.clubCd }" data-cbcd="${acPost.cbCd }" data-cpno="${acPost.cpNo }">
							      <svg class="svg-inline--fa fa-trash fs--1 mr-2" data-fa-transform="shrink-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="trash" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="" style="transform-origin: 0.4375em 0.5em;"><g transform="translate(224 256)"><g transform="translate(0, 0)  scale(0.875, 0.875)  rotate(0 0 0)"><path fill="currentColor" d="M135.2 17.69C140.6 6.848 151.7 0 163.8 0H284.2C296.3 0 307.4 6.848 312.8 17.69L320 32H416C433.7 32 448 46.33 448 64C448 81.67 433.7 96 416 96H32C14.33 96 0 81.67 0 64C0 46.33 14.33 32 32 32H128L135.2 17.69zM394.8 466.1C393.2 492.3 372.3 512 346.9 512H101.1C75.75 512 54.77 492.3 53.19 466.1L31.1 128H416L394.8 466.1z" transform="translate(-224 -256)"></path></g></g></svg><!-- <span class="fa-solid fa-trash fs--1 mr-2" data-fa-transform="shrink-2"></span> Font Awesome fontawesome.com --> 삭제
							    </button>
						   </div>
						   </c:if>
			               <div class="timeline-item-content ps-6 ps-md-3">
			                 <h5 class="fs--6 lh-sm">${acPost.cpTitle }</h5>
			                 <p class="fs--6 text-800 mb-2">${acPost.cpContent }</p>
			                 <c:if test="${!empty acPost.fileNo }">
				               	 <img src="${acPost.fileSavepath }" style="width:500px;">
			                 </c:if>
			               </div>
			             </div>
			           </div>
			         </div>
       			</c:forEach>
       		</div>
       	</c:otherwise>
       </c:choose>
     </div>
     </div>
  </div>
  
  <c:if test="${clubRank eq 'clubHead'}">
  <div class="tab-pane fade ${manageShowActive }" id="tab-manage" role="tabpanel" aria-labelledby="manage-tab">
	<!-- 검색창 포함 테이블 -->
	<div id="manageTable" data-list='{"valueNames":["name","rank","dept","hp","joindate","status"],"page":8,"pagination":true}'> <!-- 검색, 페이징 설정 -->
		<div class="row align-items-center justify-content-between g-3 mb-4">
		  <div class="d-flex justify-content-between align-items-center border-0">
		    <h3>회원목록</h3>
		    <!-- 검색창 -->
		    <div class="search-box">
		      <form class="position-relative" data-bs-toggle="search" data-bs-display="static">
		        <input class="form-control search-input search" type="search" placeholder="Search..." aria-label="Search">
		        <span class="fas fa-search search-box-icon"></span>
		      </form>
		    </div>
		  </div>
		</div>
		
		<div class="table-responsive"> <!-- 클래스 지정 -->
		<table class="table table-hover" style="vertical-align: middle;">
		  <thead>
		    <tr style="text-align: center;">
		      <th scope="col">이름</th>
		      <th scope="col">직급</th>
		      <th scope="col">부서</th>
		      <th scope="col">연락처</th>
		      <th scope="col">가입일자</th>
		      <th scope="col">상태</th>
		      <th scope="col"></th>
		    </tr>
		  </thead>
		  <tbody class="list"> <!-- 클래스 지정, td에 class 지정(valueNames로) -->
		  	<c:choose>
		  		<c:when test="${empty club.allMemberList }">
			  		<tr style="text-align: center;">
			  			<td colspan="7">회원이 존재하지 않습니다.</td>
			  		</tr>
		  		</c:when>
		  		<c:otherwise>
		  			<c:forEach items="${club.allMemberList }" var="allMem">
					    <tr class="hover-actions-trigger btn-reveal-trigger position-static" style="text-align: center;">
					      <td class="name">${allMem.empName }</td>
					      <td class="rank">${allMem.cdName }</td>
					      <td class="dept">${allMem.deptName }</td>
					      <td class="hp">${allMem.empHp }</td>
					      <td class="joindate"><fmt:formatDate value="${allMem.joinDate }" pattern="yyyy-MM-dd"/></td>
					      <td class="status">${allMem.status }</td>
					      <td>
					      	<c:if test="${allMem.status == '대기'}">
						      	<button class="btn btn-info me-1 mb-1" name="manageBtn" data-joincontent="${allMem.joinContent }" data-empno="${allMem.joinEmpno }">승인관리</button>
					      	</c:if>
					      </td>
					    </tr>
				    </c:forEach>
		  		</c:otherwise>
		  	</c:choose>
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
  </c:if>
  
</div>
<br>

<!-- 가입하기 모달창 시작 -->
<div class="modal fade" id="joinModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">동호회 가입</h5>
        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <form method="post" action="/club/joinclub.do">
      <div class="modal-body">
      	<input type="hidden" name="cnmEmpno" value="${empNo }">
      	<input type="hidden" name="clubCd" value="${clubCd }">
        <p class="text-700 lh-lg mb-0">
			<textarea class="form-control" name="cnmContent" placeholder="가입소개글을 입력해주세요." style="height: 150px"></textarea>
		</p>
      </div>
      <div class="modal-footer">
      	<button class="btn btn-info" type="submit">저장</button>
      	<button class="btn btn-outline-info" type="button" data-bs-dismiss="modal">취소</button>
      </div>
      </form>
    </div>
  </div>
</div>
<!-- 가입하기 모달창 끝 -->

<!-- 승인관리 모달창 시작 -->
<div class="modal fade" id="manageModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">승인관리</h5>
        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body" style="padding:20px;">
        <span class="text-info" style="font-weight: bold;">가입소개글</span>
        <p class="text-700 lh-lg mb-0"><!-- 가입소개글 들어가는 곳 --></p><br>
      </div>
      <div class="modal-footer">
        <button class="btn btn-info me-1 mb-1" type="button" id="joinConfirmBtn" data-empno="">승인</button>
        <button class="btn btn-outline-info me-1 mb-1" type="button" id="joinRejectBtn" data-empno="">거절</button>
      </div>
    </div>
  </div>
</div>
<!-- 승인관리 모달창 끝 -->

<!-- 승인거절 모달창 시작 -->
<div class="modal fade" id="rejectModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">승인관리</h5>
        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
      <div class="modal-body">
      <form id="rejectForm" method="post" action="/club/joinreject.do">
      	<input type="hidden" name="clubCd" value="${clubCd }">
      	<input type="hidden" name="cnmEmpno" value="">
        <p class="text-700 lh-lg mb-0">
			<textarea class="form-control" name="cnmNocontent" placeholder="거절사유를 입력하세요." style="height: 150px"></textarea>
		</p>
      </form>
      </div>
      <div class="modal-footer">
      	<button class="btn btn-info" type="button" id="rejectConfirmBtn">저장</button>
      	<button class="btn btn-outline-info" type="button" data-bs-dismiss="modal">취소</button>
      </div>
    </div>
  </div>
</div>
<!-- 승인거절 모달창 끝 -->

<!-- 동호회관리 모달창 시작 -->
<div class="modal fade" id="clubInfoModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">동호회관리</h5>
        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
   	  <form method="post" action="/club/modifyInfo.do" enctype="multipart/form-data">
      <div class="modal-body" style="padding:20px;">
      	<p>
	    	<span class="text-danger" data-feather="check"></span>
	    	수정사항은 즉시 반영됩니다.
	    </p>
		<input type="hidden" name="clubCd" value="${clubCd }">
  		<div class="mb-4">
	      	<div class="d-flex flex-wrap mb-2">
				<h4 class="mb-0 text-1000 me-2">대표이미지</h4>
			</div>
	      	<input class="form-control" type="file" name="picture">
      	</div>
     	<div class="mb-4">
	        <div class="d-flex flex-wrap mb-2">
				<h4 class="mb-0 text-1000 me-2">소개</h4>
			</div>
	        <textarea class="form-control" name="clubInfo" placeholder="" style="height: 150px"></textarea>
      	</div>
      </div>
      <div class="modal-footer d-flex justify-content-between align-items-center border-0">
   	    <button class="btn btn-danger me-1 mb-1" type="button" id="removeClubBtn" data-clubcd="${clubCd }">동호회 폐쇄</button>
        <button class="btn btn-info me-1 mb-1" type="submit">수정</button>
      </div>
     </form>
    </div>
  </div>
</div>
<!-- 동호회관리 모달창 끝 -->

<!-- 활동내역 모달창 시작 -->
<div class="modal fade" id="insertActivity" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">활동내역 추가</h5>
        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
   	  <form class="needs-validation" novalidate="" method="post" action="/clubboard/activity/insert.do" enctype="multipart/form-data">
      <div class="modal-body" style="padding:20px;">
		<input type="hidden" name="clubCd" value="${clubCd }">
		<input type="hidden" name="cbCd" value="AC">
  		<div class="mb-4">
	      	<div class="d-flex flex-wrap mb-2">
				<h5 class="mb-0 text-1000 me-2">제목</h5><span class="text-danger">*</span>
			</div>
	      	<input class="form-control" type="text" name="cpTitle" required>
      	</div>
  		<div class="mb-4">
	      	<div class="d-flex flex-wrap mb-2">
				<h5 class="mb-0 text-1000 me-2">내용</h5>
			</div>
	        <textarea class="form-control" name="cpContent" placeholder="" style="height: 150px"></textarea>
      	</div>
  		<div class="mb-4">
	      	<div class="d-flex flex-wrap mb-2">
				<h5 class="mb-0 text-1000 me-2">활동일자</h5><span class="text-danger">*</span>
			</div>
	      	<input class="form-control" type="date" name="cpDate" required>
      	</div>
  		<div class="mb-4">
	      	<div class="d-flex flex-wrap mb-2">
				<h5 class="mb-0 text-1000 me-2">활동사진</h5>
			</div>
	      	<input class="form-control" type="file" name="picture">
      	</div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-info me-1 mb-1" type="submit">추가</button>
        <button class="btn btn-outline-info" type="button" data-bs-dismiss="modal">취소</button>
      </div>
     </form>
    </div>
  </div>
</div>
<!-- 활동내역 모달창 끝 -->

<!-- 활동내역 수정 모달창 시작 -->
<div class="modal fade" id="modifyActivity" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">활동내역 수정</h5>
        <button class="btn p-1" type="button" data-bs-dismiss="modal" aria-label="Close"><span class="fas fa-times fs--1"></span></button>
      </div>
   	  <form class="needs-validation" novalidate="" method="post" action="/clubboard/activity/modify.do" enctype="multipart/form-data">
      <div class="modal-body" style="padding:20px;">
		<input type="hidden" name="clubCd" value="${clubCd }">
		<input type="hidden" name="cbCd" value="AC">
		<input type="hidden" name="cpNo" value="">
  		<div class="mb-4">
	      	<div class="d-flex flex-wrap mb-2">
				<h5 class="mb-0 text-1000 me-2">제목</h5><span class="text-danger">*</span>
			</div>
	      	<input class="form-control" type="text" name="cpTitle" required>
      	</div>
  		<div class="mb-4">
	      	<div class="d-flex flex-wrap mb-2">
				<h5 class="mb-0 text-1000 me-2">내용</h5>
			</div>
	        <textarea class="form-control" name="cpContent" placeholder="" style="height: 150px"></textarea>
      	</div>
  		<div class="mb-4">
	      	<div class="d-flex flex-wrap mb-2">
				<h5 class="mb-0 text-1000 me-2">활동일자</h5><span class="text-danger">*</span>
			</div>
	      	<input class="form-control" type="date" name="cpDate" required>
      	</div>
  		<div class="mb-4">
	      	<div class="d-flex flex-wrap mb-2">
				<h5 class="mb-0 text-1000 me-2">활동사진</h5>
			</div>
	      	<input class="form-control" type="file" name="picture">
      	</div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-info me-1 mb-1" type="submit">수정</button>
        <button class="btn btn-outline-info" type="button" data-bs-dismiss="modal">취소</button>
      </div>
     </form>
    </div>
  </div>
</div>
<!-- 활동내역 수정 모달창 끝 -->

<script type="text/javascript">

// 상세보기 페이지 들어가면 세팅되는 데이터 //
let clubCd = $("#myTab").data("clubcd");
let cbCd;
let cpNo;
let cpTitle;
let cpContent;
let cpDate;
let cpHit;
let empName; // 글 작성자
let empNo; // 글 작성자
let fileList;
//상세보기 페이지 들어가면 세팅되는 데이터 //

let modal;

$(function(){
	CKEDITOR.replace('ckeditor_notice', {
		filebrowserUploadUrl : "/imageUpload.do" // 속성 지정해줘야 업로드 탭 생긴다
	});
	CKEDITOR.replace('ckeditor_free', {
		filebrowserUploadUrl : "/imageUpload.do"
	});
	
	$("button[name='writeBtn']").on("click",function(){
		var tableSort = $(this).data("sort");
		console.log(tableSort);
// 		$("#" + tableSort).css("display", "none");
// 	    $("#" + tableSort).siblings("div[name='writeTable']").css("display", "block");
		
		$("#" + tableSort).siblings("div[name='writeTable']").find("form").attr("action","/clubboard/insert.do");
		$("#" + tableSort).siblings("div[name='writeTable']").find("input[name='cpTitle']").val(""); // find 붙이니까 된다
		CKEDITOR.instances.ckeditor_notice.setData("");
		CKEDITOR.instances.ckeditor_free.setData("");
		$("#" + tableSort).siblings("div[name='writeTable']").find("input[name='files']").val("");
		$("#" + tableSort).siblings("div[name='writeTable']").find("div[name='cpfiles']").text("");
		
		$("#" + tableSort).toggle();
		$("#" + tableSort).siblings("div[name='writeTable']").toggle();
	});
	
	$('#myTab a').on('click', function (e) {
//         e.preventDefault();
		if($(this).attr('id') == 'main-tab'){
			return;
		}
        var targetTab = $(this).attr('href'); // 클릭된 탭의 href 속성을 가져옴 #tab-main
        
        $(targetTab).find("div:first").css("display", "block"); // 클릭된 탭에 해당하는 첫 번째 div를 보이도록 함
        $(targetTab).find("div[name='writeTable']").css("display", "none"); // 클릭된 탭에 해당하는 div를 숨김
        $(targetTab).find("div[name='detailTable']").css("display", "none"); // 클릭된 탭에 해당하는 div를 숨김
//         $(this).tab('show');
//         $(targetTab).show().siblings().hide();

     	// 게시글/댓글 버튼 다 보이게 변경
		$("div[name='myBtn']").each(function() {
	    	$(this).removeClass('hidden');
		});
    });
	
	$("a[name='postDetail']").on("click",function(e){
		e.preventDefault();
		console.log($(this).data("cpno"));
		
		cpNo = $(this).data("cpno");
		var tableSort = $(this).data("sort");
		
		$.ajax({
	    	type: "get",
			url: "/clubboarddetail.do?cpNo="+cpNo,
			success: function(result){
				console.log(result);
				
// 				clubCd = result.clubCd;
				cbCd = result.cbCd;
				cpNo = result.cpNo;
				cpTitle = result.cpTitle;
				cpContent = result.cpContent;
				cpDate = result.cpDate;
				cpHit = result.cpHit;
				empName = result.empName; // 글 작성자
				empNo = result.cpwriterEmpno; // 글 작성자
				fileList = result.fileList;
				commentList = result.commentList;
				
				var target = $("#" + tableSort).siblings("div[name='detailTable']");
				
				target.find("div[name='myBtn']").attr("data-empno", empNo);
				target.find("h3[name='cpTitle']").html(cpTitle);
				target.find("span[name='empName']").html(empName);
				target.find("span[name='cpDate']").html(cpDate);
				target.find("span[name='cpHit']").html(cpHit);
				target.find("div[name='cpContent']").html(cpContent);
				
				// 파일 세팅
				var str = "";
				for(var i=0; i<fileList.length; i++){
					if(i==0){
						str += `
							<div class="px-4 px-lg-6">
					          <h4 class="mb-1">첨부파일</h4>
					        </div>
						`;
					}
					str += `
						<div class="border-top border-300 px-4 px-lg-6 py-4">
				          <div class="me-n3">
				            <div class="d-flex flex-between-center">
				              <div class="d-flex mb-1">
				              	<svg class="svg-inline--fa fa-image me-2 text-700 fs--1" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="image" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg=""><path fill="currentColor" d="M447.1 32h-384C28.64 32-.0091 60.65-.0091 96v320c0 35.35 28.65 64 63.1 64h384c35.35 0 64-28.65 64-64V96C511.1 60.65 483.3 32 447.1 32zM111.1 96c26.51 0 48 21.49 48 48S138.5 192 111.1 192s-48-21.49-48-48S85.48 96 111.1 96zM446.1 407.6C443.3 412.8 437.9 416 432 416H82.01c-6.021 0-11.53-3.379-14.26-8.75c-2.73-5.367-2.215-11.81 1.334-16.68l70-96C142.1 290.4 146.9 288 152 288s9.916 2.441 12.93 6.574l32.46 44.51l93.3-139.1C293.7 194.7 298.7 192 304 192s10.35 2.672 13.31 7.125l128 192C448.6 396 448.9 402.3 446.1 407.6z"></path></svg>
				                <a href="/clubboard/download.do?fileSec=\${fileList[i].fileSec}"><p class="text-1000 mb-0 lh-1">\${fileList[i].fileOrgname}</p></a>
				              </div>
				            </div>
				            <div class="d-flex fs--1 text-700 mb-2 flex-wrap">
					            <span>\${fileList[i].fileSize}</span>
					            <span class="text-400 mx-1">| </span>
					            <span class="text-nowrap">\${fileList[i].fileMime}</span>
					        </div>
				            </div>
		            `;
				    if(fileList[i].fileMime.startsWith('image')){
				    	str += `<img class="rounded-2" src="\${fileList[i].fileSavepath}" style="max-width:270px">`;
				    }
				    str += `
				        </div>
					`;
				}
				target.find("div[name='cpfiles']").html(str);
				
				// 댓글 세팅
				var str2 = "";
				for(var i=0; i<commentList.length; i++){
					str2 += `
				      <div class="d-flex align-items-start mb-3">
			            <div class="avatar avatar-m  me-2">
			              <img class="rounded-circle " src="\${commentList[i].empPhoto}">
			            </div>
			            <div class="flex-1">
			              <div class="d-flex justify-content-between align-items-center">
				              <div class="d-flex align-items-center">
				              	  <p class="fw-bold mb-0 text-black">\${commentList[i].empName}</p>
					              <span class="text-600 fw-semi-bold fs--2 ms-2">\${commentList[i].cmDate}</span>
				              </div>
				              <div class="d-flex justify-content-end closeGroup" name="myBtn" data-empno="\${commentList[i].cmwriterEmpno}">
					  		  	<button class="btn btn-phoenix-secondary btn-sm me-1 mb-1" name="modifyCommentBtn" data-cmno="\${commentList[i].cmNo}" style="display: block;">
					  		      <svg class="svg-inline--fa fa-pencil fs--2 mr-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="pencil" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg=""><path fill="currentColor" d="M421.7 220.3L188.5 453.4L154.6 419.5L158.1 416H112C103.2 416 96 408.8 96 400V353.9L92.51 357.4C87.78 362.2 84.31 368 82.42 374.4L59.44 452.6L137.6 429.6C143.1 427.7 149.8 424.2 154.6 419.5L188.5 453.4C178.1 463.8 165.2 471.5 151.1 475.6L30.77 511C22.35 513.5 13.24 511.2 7.03 504.1C.8198 498.8-1.502 489.7 .976 481.2L36.37 360.9C40.53 346.8 48.16 333.9 58.57 323.5L291.7 90.34L421.7 220.3zM492.7 58.75C517.7 83.74 517.7 124.3 492.7 149.3L444.3 197.7L314.3 67.72L362.7 19.32C387.7-5.678 428.3-5.678 453.3 19.32L492.7 58.75z"></path></svg><!-- <span class="fas fa-pencil-alt fs--2 mr-2"></span> Font Awesome fontawesome.com --> 수정
					  		    </button>
					  		    &nbsp;
					  		    <button class="btn btn-phoenix-danger btn-sm me-1 mb-1" name="delCommentBtn" data-cmno="\${commentList[i].cmNo}" style="display: block;">
					  		      <svg class="svg-inline--fa fa-trash fs--1 mr-2" data-fa-transform="shrink-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="trash" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="" style="transform-origin: 0.4375em 0.5em;"><g transform="translate(224 256)"><g transform="translate(0, 0)  scale(0.875, 0.875)  rotate(0 0 0)"><path fill="currentColor" d="M135.2 17.69C140.6 6.848 151.7 0 163.8 0H284.2C296.3 0 307.4 6.848 312.8 17.69L320 32H416C433.7 32 448 46.33 448 64C448 81.67 433.7 96 416 96H32C14.33 96 0 81.67 0 64C0 46.33 14.33 32 32 32H128L135.2 17.69zM394.8 466.1C393.2 492.3 372.3 512 346.9 512H101.1C75.75 512 54.77 492.3 53.19 466.1L31.1 128H416L394.8 466.1z" transform="translate(-224 -256)"></path></g></g></svg><!-- <span class="fa-solid fa-trash fs--1 mr-2" data-fa-transform="shrink-2"></span> Font Awesome fontawesome.com --> 삭제
					  		    </button>
			  		   		  </div>
				              <div class="d-flex justify-content-end openGroup hidden">
					  		  	<button class="btn btn-phoenix-info btn-sm" name="modifyCommentConfirmBtn" data-cmno="\${commentList[i].cmNo}" style="display: block;">저장</button>
					  		    &nbsp;
					  		    <button class="btn btn-phoenix-secondary btn-sm" name="cancleCommentBtn" data-cmno="\${commentList[i].cmNo}" style="display: block;">취소</button>
			  		   		  </div>
			              </div>
			              <p class="mb-0 closeGroup">\${commentList[i].cmContent}</p>
			              <input class="form-control openGroup hidden" type="text" name="cmContent" value="\${commentList[i].cmContent}">
			            </div>
			          </div>
		            `;
				}
				$("#comment").html(str2);
				
				$("#" + tableSort).toggle();
				target.toggle();
				
				// 게시글/댓글 본인인지 확인 후 숨기기
				$("div[name='myBtn']").map(function(i,e){ // 첫번째 index, 두번째 element
				    var empNo = e.dataset.empno;
				    var me = $("#myTab").data('empno');
				    if(me != empNo){
// 				    	$(this).css("display", "none");
				    	$(this).addClass('hidden');
				    }
					console.log(e + " ::: index : " + i);
				});
// 				$("div[name='myBtn']").each(function(i,v) { // this로 제대로 가져오지 못한다
// 				    var empNo = $(this).data('empno');
// 				    var me = $("#myTab").data('empno');
// 				    console.log("empNo", empNo, typeof empNo);
// 				    console.log("me", me, typeof me);
// 				    if(me != empNo){
// 				    	console.log($(this));
// // 				    	$(this).css("display", "none");
// 				    	$(this).addClass('hidden');
// 				    }
// 				});
			}
		});
		
		
	});
	
	$("button[name='modifyBtn']").on("click",function(){
		console.log("수정 버튼!!");
		
		var tableSort = $(this).data("sort");
		
		var target = $("#" + tableSort).siblings("div[name='writeTable']");
		
		target.find("input[name='cpNo']").val(cpNo);
		
		// 제목 세팅
		target.find("input[name='cpTitle']").val(cpTitle);
		
		// 내용 세팅
		if(tableSort == 'notice'){
			CKEDITOR.instances.ckeditor_notice.setData(cpContent);
		} else if(tableSort == 'free'){
			CKEDITOR.instances.ckeditor_free.setData(cpContent);
		}
// 		target.find("textarea[name='cpContent']").val(cpContent);

		// 파일 첨부 비워주기
		target.find("input[name='files']").val("");
		
		// 파일 세팅
		var str = "";
		for(var i=0; i<fileList.length; i++){
			str += `
				<div class="border-top border-300 px-4 px-lg-6 py-4">
		          <div class="me-n3">
		            <div class="d-flex flex-between-center">
		              <div class="d-flex mb-1">
		              	<svg class="svg-inline--fa fa-image me-2 text-700 fs--1" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="image" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg=""><path fill="currentColor" d="M447.1 32h-384C28.64 32-.0091 60.65-.0091 96v320c0 35.35 28.65 64 63.1 64h384c35.35 0 64-28.65 64-64V96C511.1 60.65 483.3 32 447.1 32zM111.1 96c26.51 0 48 21.49 48 48S138.5 192 111.1 192s-48-21.49-48-48S85.48 96 111.1 96zM446.1 407.6C443.3 412.8 437.9 416 432 416H82.01c-6.021 0-11.53-3.379-14.26-8.75c-2.73-5.367-2.215-11.81 1.334-16.68l70-96C142.1 290.4 146.9 288 152 288s9.916 2.441 12.93 6.574l32.46 44.51l93.3-139.1C293.7 194.7 298.7 192 304 192s10.35 2.672 13.31 7.125l128 192C448.6 396 448.9 402.3 446.1 407.6z"></path></svg>
		                <p class="text-1000 mb-0 lh-1">\${fileList[i].fileOrgname}</p>
		              </div>
		              <div class="font-sans-serif btn-reveal-trigger">
                      	<button class="btn btn-sm transition-none btn-reveal" name="delFileBtn" id="\${fileList[i].fileSec}" type="button"><svg xmlns="http://www.w3.org/2000/svg" width="16px" height="16px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-x text-900 fs-3"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg></button>
                      </div>
		            </div>
		            <div class="d-flex fs--1 text-700 mb-2 flex-wrap">
			            <span>\${fileList[i].fileSize}</span>
			            <span class="text-400 mx-1">| </span>
			            <span class="text-nowrap">\${fileList[i].fileMime}</span>
			        </div>
		            </div>
            `;
		    if(fileList[i].fileMime.startsWith('image')){
		    	str += `<img class="rounded-2" src="\${fileList[i].fileSavepath}" style="max-width:270px">`;
		    }
		    str += `
		        </div>
			`;
		}
		target.find("div[name='cpfiles']").html(str);
		
		target.find("form").attr("action","/clubboard/modify.do");
		
		$("#" + tableSort).siblings("div[name='detailTable']").toggle();
		target.toggle();
	});
	$("button[name='modifyActivity']").on("click",function(){
		var cpNo = $(this).data("cpno");
		var cpDate = $(this).closest(".timeline-item").find(".timeline-item-date p").text();
		var cpTitle = $(this).closest(".timeline-item").find(".timeline-item-content h5").text();
		var cpContent = $(this).closest(".timeline-item").find(".timeline-item-content p").text();
		console.log(cpNo, ":::", cpDate, ":::", cpTitle, ":::", cpContent);
		
		$("#modifyActivity form input[name='cpNo']").val(cpNo);
		$("#modifyActivity form input[name='cpDate']").val(cpDate.trim());
		$("#modifyActivity form input[name='cpTitle']").val(cpTitle);
		$("#modifyActivity form textarea[name='cpContent']").val(cpContent);
		new window.bootstrap.Modal(modifyActivity).show();
	});
	
	$("button[name='delBtn']").on("click",function(){
		customConfirm('정말 삭제하시겠습니까?').then((userConfirmed) => {
          if (userConfirmed) { 
        	  location.href="/clubboard/remove.do?clubCd="+clubCd+"&cbCd="+cbCd+"&cpNo="+cpNo;
          }
        });
	});
	$("button[name='delActivity']").on("click",function(){
		var clubCd = $(this).data("clubcd");
		var cbCd = $(this).data("cbcd");
		var cpNo = $(this).data("cpno");
		
		customConfirm('정말 삭제하시겠습니까?').then((userConfirmed) => {
          if (userConfirmed) { 
        	  location.href="/clubboard/remove.do?clubCd="+clubCd+"&cbCd="+cbCd+"&cpNo="+cpNo;
          }
        });
	});
	
	$("div[name='writeTable']").on("click", "button[name='delFileBtn']", function(){
		var fileNo = $(this).prop("id");
		console.log("fileNo : ", fileNo);
		var ptrn = "<input type='hidden' name='delFileSec' value='%V'/>";
		$(this).parents("form").append(ptrn.replace("%V", fileNo)); // 어디에는 append되고,,, 어디엔 안되고,,
		$(this).parents(".border-top").hide();
	});
	
	$("#commentBtn").on("click",function(){
		var cmContent = $(this).siblings("input[name='cmContent']").val();
		console.log(cmContent);
		
		// 알림용, 가져올 수 있으려나 
		var title = $("h3[name='cpTitle']").text();
		console.log("알림용 셋팅값 cpTitle 확인 : ",title);
		// 알림 핸들러에 쏴줄 메세지 셋팅 
		var msg = "clubBoard,"+title+","+empNo;
		console.log("알림용 셋팅값 msg 확인 : ",msg);
		
		var data = {
			"cmBno" : cpNo,
			"cmContent" : cmContent
		}
		
		$.ajax({
			type: "post",
			url: "/clubboard/comment/insert.do",
			data: data,
			success: function(cmt){
				console.log(cmt);
				
				const TIME_ZONE = 9 * 60 * 60 * 1000; // 9시간
				var date = new Date();
				date = new Date(date.getTime() + TIME_ZONE).toISOString().replace('T', ' ').slice(0, -8); // 2021-08-05 09:51
				
				// 댓글 세팅
				var str2 = "";
				
				str2 += `
					<div class="d-flex align-items-start mb-3">
		            <div class="avatar avatar-m  me-2">
		              <img class="rounded-circle " src="${empPhoto}">
		            </div>
		            <div class="flex-1">
		              <div class="d-flex justify-content-between align-items-center">
			              <div class="d-flex align-items-center">
			              	  <p class="fw-bold mb-0 text-black">${empName}</p>
				              <span class="text-600 fw-semi-bold fs--2 ms-2">\${date}</span>
			              </div>
			              <div class="d-flex justify-content-end closeGroup">
				  		  	<button class="btn btn-phoenix-secondary btn-sm me-1 mb-1" name="modifyCommentBtn" data-cmno="\${cmt.cmNo}" style="display: block;">
				  		      <svg class="svg-inline--fa fa-pencil fs--2 mr-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="pencil" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg=""><path fill="currentColor" d="M421.7 220.3L188.5 453.4L154.6 419.5L158.1 416H112C103.2 416 96 408.8 96 400V353.9L92.51 357.4C87.78 362.2 84.31 368 82.42 374.4L59.44 452.6L137.6 429.6C143.1 427.7 149.8 424.2 154.6 419.5L188.5 453.4C178.1 463.8 165.2 471.5 151.1 475.6L30.77 511C22.35 513.5 13.24 511.2 7.03 504.1C.8198 498.8-1.502 489.7 .976 481.2L36.37 360.9C40.53 346.8 48.16 333.9 58.57 323.5L291.7 90.34L421.7 220.3zM492.7 58.75C517.7 83.74 517.7 124.3 492.7 149.3L444.3 197.7L314.3 67.72L362.7 19.32C387.7-5.678 428.3-5.678 453.3 19.32L492.7 58.75z"></path></svg><!-- <span class="fas fa-pencil-alt fs--2 mr-2"></span> Font Awesome fontawesome.com --> 수정
				  		    </button>
				  		    &nbsp;
				  		    <button class="btn btn-phoenix-danger btn-sm me-1 mb-1" name="delCommentBtn" data-cmno="\${cmt.cmNo}" style="display: block;">
				  		      <svg class="svg-inline--fa fa-trash fs--1 mr-2" data-fa-transform="shrink-2" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="trash" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" data-fa-i2svg="" style="transform-origin: 0.4375em 0.5em;"><g transform="translate(224 256)"><g transform="translate(0, 0)  scale(0.875, 0.875)  rotate(0 0 0)"><path fill="currentColor" d="M135.2 17.69C140.6 6.848 151.7 0 163.8 0H284.2C296.3 0 307.4 6.848 312.8 17.69L320 32H416C433.7 32 448 46.33 448 64C448 81.67 433.7 96 416 96H32C14.33 96 0 81.67 0 64C0 46.33 14.33 32 32 32H128L135.2 17.69zM394.8 466.1C393.2 492.3 372.3 512 346.9 512H101.1C75.75 512 54.77 492.3 53.19 466.1L31.1 128H416L394.8 466.1z" transform="translate(-224 -256)"></path></g></g></svg><!-- <span class="fa-solid fa-trash fs--1 mr-2" data-fa-transform="shrink-2"></span> Font Awesome fontawesome.com --> 삭제
				  		    </button>
		  		   		  </div>
			              <div class="d-flex justify-content-end openGroup hidden">
				  		  	<button class="btn btn-phoenix-info btn-sm" name="modifyCommentConfirmBtn" data-cmno="\${cmt.cmNo}" style="display: block;">저장</button>
				  		    &nbsp;
				  		    <button class="btn btn-phoenix-secondary btn-sm" name="cancleCommentBtn" data-cmno="\${cmt.cmNo}" style="display: block;">취소</button>
		  		   		  </div>
		              </div>
		              <p class="mb-0 closeGroup">\${cmContent}</p>
		              <input class="form-control openGroup hidden" type="text" name="cmContent" value="\${cmContent}">
		            </div>
		          </div>
	            `;
	            
				$("#comment").append(str2);
				$("#commentBtn").siblings("input[name='cmContent']").val("");
				ws.send(msg);
			}
		});
	});
	
	$("#comment").on("click", "button[name='modifyCommentBtn']", function(){ // 폼 생성 필요
		var currentButton = $(this);
		
		currentButton.closest(".align-items-start").find(".openGroup").removeClass('hidden');
		currentButton.closest(".align-items-start").find(".closeGroup").addClass('hidden');
	});
	
	$("#comment").on("click", "button[name='modifyCommentConfirmBtn']", function(){
		var currentButton = $(this);
		
		var cmNo = currentButton.data("cmno");
		var cmContent = currentButton.closest(".align-items-start").find("input").val();
		console.log(cmNo, cmContent);
		
		var data = {
			"cmNo" : cmNo,
			"cmContent" : cmContent
		}
			
		$.ajax({
			type: "post",
			url: "/clubboard/comment/modify.do",
			data: data,
			success: function(result){
				if(result == 'SUCCESS'){
					currentButton.closest(".align-items-start").find("p.closeGroup").text(cmContent);
					
					currentButton.closest(".align-items-start").find(".openGroup").addClass('hidden');
					currentButton.closest(".align-items-start").find(".closeGroup").removeClass('hidden');
					alert("정상적으로 수정되었습니다.");
				}
			}
		});
		
	});
	
	$("#comment").on("click", "button[name='cancleCommentBtn']", function(){
		var currentButton = $(this);
		
		currentButton.closest(".align-items-start").find(".openGroup").addClass('hidden');
		currentButton.closest(".align-items-start").find(".closeGroup").removeClass('hidden');
	});
	
	$("#comment").on("click", "button[name='delCommentBtn']", function(){
		var currentButton = $(this); // 현재 버튼 요소를 변수에 저장
		
		customConfirm('정말 삭제하시겠습니까?').then((userConfirmed) => {
          if (userConfirmed) { 
        	  var cmNo = $(this).data("cmno");
        	  $.ajax({
      			type: "get",
      			url: "/clubboard/comment/remove.do?cmNo="+cmNo,
      			success: function(result){
      				if(result == 'SUCCESS'){
      					// 여기서 $(this)는 콜백 함수의 컨텍스트로, AJAX 요청이 아닌 콜백 함수 자체를 가리키게 됩니다. 
      					currentButton.parents(".align-items-start").remove(); // ^^ 왜 또 hide는 안되고...
						alert("정상적으로 삭제되었습니다.");
      				}
      			}
        	  });
          }
		})
	});
	
	$("button[name='manageBtn']").on("click",function(){
		var content = $(this).data("joincontent");
		var empNo = $(this).data("empno");
		if(content == "" || content == null){
			content = "가입소개글을 작성하지 않았습니다.";
		}
		$("#manageModal .modal-body p").text(content);
		$("#joinConfirmBtn").attr("data-empno", empNo);
		$("#joinRejectBtn").attr("data-empno", empNo);
		
		modal = new window.bootstrap.Modal(manageModal);
		modal.show();
	});
	
	$("#joinConfirmBtn").on("click",function(){
		var empNo = $(this).data("empno");
		console.log(clubCd, empNo);
		location.href="/club/joinconfirm.do?clubCd="+clubCd+"&cnmEmpno="+empNo;
	});
	$("#joinRejectBtn").on("click",function(){
		var empNo = $(this).data("empno");
		$("#rejectModal input[name='cnmEmpno']").val(empNo);
		
		modal.hide();
		new window.bootstrap.Modal(rejectModal).show();
	});
	$("#rejectConfirmBtn").on("click",function(){
		if($("#rejectModal textarea[name='cnmEmpno']").val() == "") {
			alert("사유를 입력해주세요");
		}else{
			rejectForm.submit();
		}
	});
	
	joinModal.addEventListener('hide.bs.modal', function (event) {
		$(this).find("textarea").val("");
	});
	
	// 동호회 폐쇄
	$("#removeClubBtn").on("click",function(){
		var clubCd = $(this).data("clubcd");
		customConfirm('정말 폐쇄하시겠습니까?').then((userConfirmed) => {
			if (userConfirmed){
				location.href="/club/shutdown.do?clubCd="+clubCd;
			}
		})
	});
	$("#leaveClub").on("click",function(){
		var clubCd = $(this).data("clubcd");
		var empNo = $(this).data("empno");
		customConfirm('정말 탈퇴하시겠습니까?').then((userConfirmed) => {
			if (userConfirmed){
				location.href="/club/leaveclub.do?clubCd="+clubCd+"&cmEmpno="+empNo;
			}
		})
	});
	
	insertActivity.addEventListener('hide.bs.modal', function (event) {
		$('#insertActivity input').each(function(){
			$(this).val("");
		});
		$('#insertActivity textarea').val("");
		
		$("#insertActivity form").attr("class", "needs-validation");
	});
	modifyActivity.addEventListener('hide.bs.modal', function (event) {
		$("#modifyActivity form").attr("class", "needs-validation");
	});
	
});


</script>