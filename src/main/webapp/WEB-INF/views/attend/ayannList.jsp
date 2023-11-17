
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:set value="${ayannList }" var="ayannList" />
<c:set value="${ayannThisYear }" var="thisYear" />

<h2>연차관리</h2>

<div>
	<div>
		<div class="container-fluid">
			<div class="card mt-7" style="border-radius: 20px; height: auto;">

				<div class="row" style="padding: 40px;">
					<div class="d-flex justify-content-between align-items-center border-0">
						<h3>당해잔여연차</h3>
						<button class="btn btn-phoenix-info me-1 mb-1" type="button" id="draftBtn">연차신청하기</button>
					</div>
				</div>
				
				<div class="row pb-2">
						<div class="col-12 px-11">
							<div class="row align-items-center bg-info bg-gradient opacity-75"
								style="border-radius: 10px; height: 40px;">
								<div class="col-4">
									<h4 class="text-white text-center">총연차개수</h4>
								</div>
								<div class="col-4">
									<h4 class="text-white text-center">사용연차개수</h4>
								</div>
								<div class="col-4">
									<h4 class="text-white text-center">잔여연차개수</h4>
								</div>
							</div>
						</div>
					</div>

					<div class="row pb-3">
						<div class="col-12 px-11">
							<div class="row align-items-center"
								style="border-radius: 10px; height: auto;">
								<c:forEach items="${ayannMap.yearList }" var="yearInfo" varStatus="status">
									<c:if test="${status.last }">
										<div class="col-4 pb-2">
											<h4 class="text-center p">${yearInfo.ayannCnt }개</h4>
										</div>
										<div class="col-4 pb-2">
											<h4 class="text-center">${yearInfo.ayannCnt-yearInfo.ayannRest }개</h4>
										</div>
										<div class="col-4 pb-2">
											<h4 class="text-center">${yearInfo.ayannRest }개</h4>
										</div>
									</c:if>
								</c:forEach>
							</div>
						</div>
					</div>

					<div class="row pb-7">
						<div class="col-12 d-flex justify-content-end px-11">
							<span>잔여연차는 당해연도 12월 31일 전까지 사용을 권장합니다.</span>
						</div>
					</div>

					<div class="row pb-7">
						<div class="col-12 d-flex justify-content-end px-11">
							
						</div>
					</div>
				
				<div class="row">
					<div class="col-6">

						<div class="row">
							<div class="col-1"></div>
							<div class="col-11">
								<h3>연차발생내역</h3>
							</div>
						</div>

						<div class="row pb-3">
							<div class="col-7"></div>
							<div class="col-4">
								<select class="form-select form-select-lg mb-3 text-start"
									aria-label=".form-select-lg example" id="ayannSelectBox">
									<!-- if문으로 돌리기 -->
									<c:forEach var="ayann" items="${ayannMap.yearList }"
										varStatus="status">
										<c:if test="">
											<option value="">연도를 선택하세요</option>
										</c:if>
									</c:forEach>
									<c:forEach var="ayann" items="${ayannMap.yearList }"
										varStatus="status">
										<option value="${ayann.ayannDt }">${ayann.ayannDt }년</option>
										<c:if test="${status.last }">
											<input type="hidden" value="${ayann.ayannDt }"
												id="defaultAyannYear" />
										</c:if>
									</c:forEach>
								</select>
							</div>
						</div>

						<div class="row pb-2">
							<div class="col-1"></div>
							<div class="col-10 ">
								<div class="row align-items-center bg-info bg-gradient opacity-75"
									style="border-radius: 10px; height: 40px;">
									<div class="col-6">
										<h4 class="text-white text-center">연차발생일</h4>
									</div>
									<div class="col-6">
										<h4 class="text-white text-center">연차개수</h4>
									</div>
								</div>
							</div>
						</div>

						<div class="row pb-13">
							<div class="col-1"></div>
							<div class="col-10">
								<div class="row align-items-center"
									style="border-radius: 10px; height: auto;">
									<div class="col-6" id="ayannYearDiv">
									</div>
									<div class="col-6" id="ayannCntDiv">
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="col-6">


						<div class="row pt-2">
							<div class="col-1"></div>
							<div class="col-11">
								<h3>연차사용내역</h3>
							</div>
						</div>

						<div class="row pb-4">
							<div class="col-7"></div>
							<div class="col-4">
								<select class="form-select form-select-lg text-start"
									aria-label=".form-select-lg example" id="ayannUsedSelectBox">
									<!-- if문으로 돌리기 -->
									<c:forEach var="ayann" items="${ayannMap.yearList }"
										varStatus="status">
										<c:if test="${status.last }">
											<option value="" selected>연도를 선택하세요</option>
										</c:if>
									</c:forEach>
									<c:forEach var="ayann" items="${ayannMap.yearList }"
										varStatus="status">
										<option value="${ayann.ayannDt }">${ayann.ayannDt }년</option>
										<c:if test="${status.last }">
											<input type="hidden" value="${ayann.ayannDt }"
												id="defaultAyannUsedYear" />
										</c:if>
									</c:forEach>
								</select>
							</div>
						</div>

						<div class="row pb-2">
							<div class="col-1"></div>
							<div class="col-10 ">
								<div class="row align-items-center bg-info bg-gradient opacity-75"
									style="border-radius: 10px; height: 40px;">
									<div class="col-6">
										<h4 class="text-white text-center">연차사용일</h4>
									</div>
									<div class="col-6">
										<h4 class="text-white text-center">연차사용개수</h4>
									</div>
								</div>
							</div>
						</div>


						<div class="row pb-9 d-flex align-items-center" id="ayannListDiv">
							
						</div>

					</div>

				</div>
			</div>
		</div>


	</div>
	<div class="row align-items-center py-1">
		<div class="pagination d-none"></div>
		<div class="col d-flex fs--1">
			<!-- 하단부 -->

		</div>
	</div>
	<div class="row" style="margin: 15px 0px 20px 0px;">
		<div class="col-9"></div>
	</div>
</div>


<script type="text/javascript">
	$(function() {
		var hiBtn = $('#hiBtn');
		var byeBtn = $('#byeBtn');
		var hiModal = $('#hiModal');
		var byeModal = $('#byeModal');

		hiBtn.on('click', function() {
			hiModal.show();
		});

		byeBtn.on('click', function() {
			byeModal.show();
		});

		CKEDITOR.replace('exampleTextarea', {
			height : 500
		});

		// 연차 발생내역을 보여줄 로직.
		$(document).on(
				'change',
				'#ayannSelectBox',
				function() {
					// div공간 id 연도Div, 연차개수Div
					var ayannYearDiv = $('#ayannYearDiv');
					var ayannCntDiv = $('#ayannCntDiv');

					// 연도 데이터
					var year = $('#ayannSelectBox').val();
					var yearData = {
						"year" : year
					}

					$.ajax({
						type : "POST",
						url : "/selectYearAyann.do",
						data : JSON.stringify(yearData),
						contentType : "application/json; charset=utf-8",
						success : function(result) {
							ayannYearDiv.html('');
							ayannCntDiv.html('');

							ayannYearDiv.html('<h4 class="text-center pb-2">'
									+ result.yearAyann.ayannDt + '</h4>');
							ayannCntDiv.html('<h4 class="text-center pb-2">'
									+ result.yearAyann.ayannCnt + '개 </h4>');
						}
					})
				});

		// 연차 사용내역을 보여줄 로직.
		$(document).on(
				'change',
				'#ayannUsedSelectBox',
				function() {
					// div공간 id 연도Div, 연차개수Div
					var ayannListDiv = $('#ayannListDiv');

					var yearStr = "";

					// 연도 데이터
					var year = $('#ayannUsedSelectBox').val();
					var yearData = {
						"year" : year
					}

					$.ajax({
						type : "POST",
						url : "/selectYearUsedAyann.do",
						data : JSON.stringify(yearData),
						contentType : "application/json; charset=utf-8",
						success : function(result) {
							ayannListDiv.html('');
							result.yearAyannUsed.forEach(function(item) {
								yearStr += '<div class="col-1"></div>';
								yearStr += '<div class="col-10">';
								yearStr += '<div class="row align-items-center" style="border-radius: 10px; height: auto;">';
								yearStr += '<div class="col-6">';
								yearStr += '<h4 class="text-center">'
									+ item.ayannStartdate + '</h4>';
								yearStr += '</div>';
								yearStr += '<div class="col-6">';
								yearStr += '<h4 class="text-center">'
									+ item.ayannUsedamt + '</h4>';
								yearStr += '</div>';
								yearStr += '</div>';
								yearStr += '<hr/>';
								yearStr += '</div>';
								yearStr += '<div class="col-1"></div>'
							})
							ayannListDiv.html(yearStr);
						}
					})
				});
		
		$(document).on('click', '#draftBtn', function(){
			location.href="/draft/write/af001.do";
		});

	});

	$(document).ready(function() {
		var defaultAyannYear = $('#defaultAyannYear').val();

		console.log('처음이어');
		console.log(defaultAyannYear);
		$('#ayannSelectBox').val(defaultAyannYear).trigger('change');

		var defaultAyannUsedYear = $('#defaultAyannUsedYear').val();

		console.log('처음이어');
		console.log(defaultAyannUsedYear);
		$('#ayannUsedSelectBox').val(defaultAyannUsedYear).trigger('change');
	})
</script>

















