<%@ page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>급여명세서</title>
<!-- ----------------------------------------------스타일 -->
<style type="text/css">
#divCustomWrapper #titleSection, #divCustomWrapper #draftSection,
	#divCustomWrapper .detailSection {
	width: 800px !important;
	clear: both;
	margin-top: 20px !important;
	vertical-align: middle;
}

#divCustomWrapper #titleSection {
	text-align: center;
	font-size: 25px;
	font-weight: bold;
	margin-bottom: 30px !important;
	margin-top: 20px !important;
}

</style>
<!-- ----------------------------------------------스타일 -->
</head>
<body>
		<div>
			<h2 style="text-align: center;">[증명서 발급]</h2>
			<button type="button" style="float: right;" onclick="createPDF();">다운로드</button>
		</div>
		<!-- 문서 시작-->

<div class="pdfArea">
<br>
	<div id="divCustomWrapper" style="margin-top: 0px; margin-bottom: 0px;">
		<div id="titleSection">급여명세서</div>
		
		<table style="width: 800px; border-collapse: collapse !important; color: black; background: white; border: 1px solid black; font-size: 12px; font-family: malgun gothic, dotum, arial, tahoma;">
			<colgroup>
				<col style="width: 90px;">
				<col style="width: 710px;">
			</colgroup>

			<tbody>

				<tr>
					<td style="padding: 3px; vertical-align: top; border: 0px solid black;" colspan="2" class="dext_table_border_t dext_table_border_r dext_table_border_b dext_table_border_l">
						<br>
						<table style="width: 770px; margin: 9px; border-collapse: collapse !important; color: black; background: white; border: 2px solid black; font-size: 12px; font-family: malgun gothic, dotum, arial, tahoma;">
							<colgroup>
								<col style="width: 100px;">
								<col style="width: 290px;">
								<col style="width: 100px;">
								<col style="width: 280px;">
							</colgroup>
							<tbody>
								<tr>
									<td class="" style="padding: 3px; height: 20px; vertical-align: middle; border: 1px solid black; text-align: center; font-weight: bold; background: rgb(221, 221, 221);" colspan="4">부서</td>
								</tr>
								<tr>
									<td style="padding: 3px; height: 20px; vertical-align: middle; border: 1px solid black; text-align: left; text-align: center;" colspan="4">${empVO.deptVO.deptName }
									</td>
								</tr>
								<tr>
									<td class="subjectColumn" style="padding: 3px; height: 20px; vertical-align: middle; border: 1px solid black; text-align: center; font-weight: bold; background: rgb(221, 221, 221);" colspan="4">
										성명</td>
								</tr>
								<tr>
									<td style="padding: 3px; height: 20px; vertical-align: middle; border: 1px solid black; text-align: left; text-align: center;" colspan="4">${empVO.empName }</td>
								</tr>
								<tr>
									<td class="subjectColumn" style="padding: 3px; height: 20px; vertical-align: middle; border: 1px solid black; text-align: center; font-weight: bold; background: rgb(221, 221, 221);" colspan="4">사번</td>
								</tr>
								<tr>
									<td style="padding: 3px; height: 20px; vertical-align: middle; border: 1px solid black; text-align: left; text-align: center;" colspan="4">${empVO.empNo }
									</td>
								</tr>
								<tr>
									<td class="subjectColumn" style="padding: 3px; height: 20px; vertical-align: middle; border: 1px solid black; text-align: center; font-weight: bold; background: rgb(221, 221, 221);" colspan="4">
										직급</td>
								</tr>
								<tr>
									<td style="padding: 3px; height: 20px; vertical-align: middle; border: 1px solid black; text-align: left; text-align: center;" colspan="4">
									${empVO.codeVO.cdName }
									</td>
								</tr>
								<tr>
									<td class="subjectColumn" style="padding: 3px; height: 20px; vertical-align: middle; border: 1px solid black; text-align: center; font-weight: bold; background: rgb(221, 221, 221);" colspan="4">
										주민번호</td>
								</tr>
								<tr>
									<td style="padding: 3px; height: 20px; vertical-align: middle; border: 1px solid black; text-align: left; text-align: center;" colspan="4">
										<c:choose>
											<c:when test="${regNo eq 'secret' }">
												${fn:substring(empVO.empRegno,0,8) }******
											</c:when>
											<c:otherwise>
												${empVO.empRegno }
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
								<tr>
									<td class="subjectColumn" style="padding: 3px; height: 20px; vertical-align: middle; border: 1px solid black; text-align: center; font-weight: bold; background: rgb(221, 221, 221);" colspan="4">
										지급일</td>
								</tr>
								<tr>
									<td class="text text-center" style="padding: 3px; height: 20px; vertical-align: middle; border: 1px solid black; text-align: center;" colspan="4">
									<fmt:formatDate value="${salaryVO.salActrsfdate }" pattern="yyyy-MM-dd"/>
									</td>
								</tr>
							</tbody>
						</table> <br>

						<table
							style="width: 770px; margin: 9px; color: black; background: white; border: 2px solid black; font-size: 12px; font-family: &amp; quot; malgun gothic&amp;quot; , dotum , arial, tahoma; border-collapse: collapse !important; height: 404.545px;">
							<colgroup>
								<col width:="" "120px;"="">
								<col width:="" "120px;"="">
								<col width:="" "100px;"="">
								<col width:="" "100px;"="">
								<col width:="" "100px;"="">
								<col width:="" "230px;"="">
							</colgroup>

							<tbody>
								<tr>
									<td class="subjectColumn" style="padding: 3px; height: 20px; vertical-align: middle; border: 1px solid black; text-align: center; font-weight: bold; background: rgb(221, 221, 221);">
										지급총액</td>
									<td class="subjectColumn" style="padding: 3px; height: 20px; vertical-align: middle; border: 1px solid black; text-align: center; font-weight: bold; background: rgb(221, 221, 221);">
										연장수당</td>
									<td class="subjectColumn" style="padding: 3px; height: 20px; vertical-align: middle; border: 1px solid black; text-align: center; font-weight: bold; background: rgb(221, 221, 221);">
										휴일수당</td>
									<td class="subjectColumn" style="padding: 3px; height: 20px; vertical-align: middle; border: 1px solid black; text-align: center; font-weight: bold; background: rgb(221, 221, 221);">
										공제총액</td>
									<td class="subjectColumn" style="padding: 3px; height: 20px; vertical-align: middle; border: 1px solid black; text-align: center; font-weight: bold; background: rgb(221, 221, 221);">
										실지급액</td>
									<td class="subjectColumn" style="padding: 3px; height: 20px; vertical-align: middle; border: 1px solid black; text-align: center; font-weight: bold; background: rgb(221, 221, 221);">
										귀속월</td>
								</tr>
								<tr>
									<td style="padding: 3px; height: 20px; vertical-align: middle; border: 1px solid black; text-align: center; font-weight: bold;">
									<fmt:formatNumber value="${salaryVO.salGramt }" type="currency"/>
									</td>
									<td style="padding: 3px; height: 20px; vertical-align: middle; border: 1px solid black; text-align: center;">
									<fmt:formatNumber value="${salaryVO.salOvertimeamt }" type="currency"/>
									</td>
									<td style="padding: 3px; height: 20px; vertical-align: middle; border: 1px solid black; text-align: center;">
									<fmt:formatNumber value="${salaryVO.salHolidayamt }" type="currency"/>
									</td>
									<td style="padding: 3px; height: 20px; vertical-align: middle; border: 1px solid black; text-align: center;">
									<fmt:formatNumber value="${salaryVO.salDdcamt }" type="currency"/>
									</td>
									<td class="amount" style="padding: 3px; height: 20px; vertical-align: middle; border: 1px solid black; text-align: center;">
									<fmt:formatNumber value="${salaryVO.salNetamt }" type="currency"/>
									</td>
									<td style="padding: 3px; height: 20px; vertical-align: middle; border: 1px solid black; text-align: center;">
									${salaryVO.salBelongmonth }</td>
								</tr>
								<tr>
									<td style="padding: 3px; height: 20px; vertical-align: middle; border: 1px solid black; text-align: center; font-weight: bold;" colspan="6">
										<br>
										<br>
										<br>
										<br>
										- 귀하의 노고에 감사드립니다.
										<br>
										<br>
										<br>
											<fmt:formatDate value="${salaryVO.salActrsfdate }" pattern="yyyy년 MM월 dd일"/> 
										<br>
										<br>
										<br>
										<img style="width: 50px;" alt="iworks" src="${pageContext.request.contextPath}/resources/assets/gw/IW_Logo.png">
									</td>
								</tr>
							</tbody>
						</table> 
						<br>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>
</body>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/bluebird/3.7.2/bluebird.min.js"></script>
<!-- jsPDF : PDF 파일을 생성하고 다운로드 -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.5.3/jspdf.min.js"></script>
<!-- html2canvas : 웹 페이지의 DOM 요소를 캡처해 이미지로 만듦 -->
<script
	src="https://unpkg.com/html2canvas@1.0.0-rc.5/dist/html2canvas.js"></script>

<script type="text/javascript">
	var renderedImg = new Array;
	var contWidth = 200, // 너비(mm) (a4에 맞춤)
	padding = 5; // 상하좌우 여백(mm)

	function createPDF() { // 이미지를 pdf로 만들기
		var lists = $(".pdfArea > div"), // 출력 대상 명확히 지정 필요 -> div가 한 묶음으로 출력

		deferreds = [], doc = new jsPDF("p", "mm", "a4"), listsLeng = lists.length;

		for (var i = 0; i < listsLeng; i++) { // div 개수만큼 이미지 생성
			var deferred = $.Deferred();
			deferreds.push(deferred.promise());
			generateCanvas(i, doc, deferred, lists[i]);
		}

		$.when.apply($, deferreds).then(
				function() { // 이미지 렌더링이 	끝난 후
					var sorted = renderedImg.sort(function(a, b) {
						return a.num < b.num ? -1 : 1;
					}), // 순서대로 정렬
					curHeight = padding, // 위 여백 (이미지가 들어가기 시작할 y축)
					sortedLeng = sorted.length;

					for (var i = 0; i < sortedLeng; i++) {

						var sortedHeight = sorted[i].height, //이미지 높이
						sortedImage = sorted[i].image; //이미지
						if (curHeight + sortedHeight > 297 - padding * 2) { // a4 높이에 맞게 남은 공간이 이미지 높이보다 작을 경우 페이지 추가
							doc.addPage(); // 페이지를 추가함
							curHeight = padding; // 이미지가 들어갈 y축을 초기 여백값으로 초기화
							doc.addImage(sortedImage, 'jpeg', padding,
									curHeight, contWidth, sortedHeight); // 이미지 넣기
							curHeight += sortedHeight; // y축 = 여백 + 새로 들어간 이미지 높이
						} else { // 페이지에 남은 공간보다 이미지가 작으면 페이지 추가하지 않음
							doc.addImage(sortedImage, 'jpeg', padding,
									curHeight, contWidth, sortedHeight); // 이미지 넣기
							curHeight += sortedHeight; // y축 = 기존y축 + 새로 들어간 이미지 높이
						}
					}
					doc.save('급여명세서_IWORKS.pdf'); // pdf 저장
					curHeight = padding; // y축 초기화
					renderedImg = new Array; // 이미지 배열 초기화
				});

		function generateCanvas(i, doc, deferred, curList) { // 페이지를 이미지로 만들기
			var pdfWidth = $(curList).outerWidth() * 0.2645, // px -> mm로 변환
			pdfHeight = $(curList).outerHeight() * 0.2645, heightCalc = contWidth
					* pdfHeight / pdfWidth;
			html2canvas(curList).then(function(canvas) {
				var img = canvas.toDataURL('image/jpeg', 1.0); // 이미지 형식 지정
				renderedImg.push({
					num : i,
					image : img,
					height : heightCalc
				}); // renderedImg 배열에 이미지 데이터 저장(뒤죽박죽 방지)
				deferred.resolve(); // 결과 보내기
			});

		}
	}
</script>
</html>