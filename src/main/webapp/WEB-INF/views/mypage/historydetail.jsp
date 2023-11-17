<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>증명서 발급</title>
<!----------------------------------------Style Start---------------------------------------->
<!-- Common style (Don't modify) -->
<style type="text/css">
/* 1. Essential style : 반드시 적용되어야 하는 스타일입니다. 문서작성 시, Sample에서 제거불가 한 스타일 */
#divCustomWrapper {
	word-break: break-all;
	font-family: malgun gothic, dotum, arial, tahoma;
	font-size: 9pt;
	width: 800px !important;
}

#divCustomWrapper * {
	max-width: 800px !important;
}
/* (1) Section(제목, 결재선, 내용) */
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

#divCustomWrapper #draftSection {
	display: inline-block;
}

#divCustomWrapper .detailSection>* {
	margin-bottom: 10px;
}
/* (2) Table */
#divCustomWrapper table {
	border-collapse: collapse;
	table-layout: fixed;
	word-break: break-all;
}
</style>
<style type="text/css">
/* 2. Option style : 용도에 따라 적용합니다.*/
/* (1) Table option : 2Type(subject / detail), Affacted elements(td), Range('divCustomWrapper' 하단요소) */
#divCustomWrapper td.subjectColumn {
	border: 1px solid black !important;
	font-size: 9pt !important;
	height: 22px;
	padding: 3px 1px 3px 1px; /*top right bottom left*/
}

#divCustomWrapper td.detailColumn {
	border: 1px solid black !important;
	font-size: 9pt !important;
	height: 22px;
	padding: 3px 5px 3px 5px;
	vertical-align: middle; /*top right bottom left*/
}

#divCustomWrapper td.detailColumn {
	text-align: left;
}

#divCustomWrapper td.subjectColumn {
	background: rgb(221, 221, 221);
	font-weight: bold;
	text-align: center;
	vertical-align: middle;
}
/* (2) detailColumn :  3Type(center / right / high), Affacted elements(All), Range('detailColumn' 하단요소) */
/* 설명 : detailColumn 커스텀 시 사용 */
/* 사용방법 : 번호와 중앙정렬 텍스트 작성 시 'centerCol' CLASS 적용, 숫자와 금액 작성 시 'rightCol' CLASS 적용,
   editor 작성 시 'editorCol' CLASS 적용, textarea 작성 시 'areaCol' CLASS 적용 */
#divCustomWrapper td.detailColumn.centerCol {
	text-align: center;
}

#divCustomWrapper td.detailColumn.rightCol {
	text-align: right;
}

#divCustomWrapper td.detailColumn.editorCol {
	height: 300px;
	vertical-align: top;
}

#divCustomWrapper td.detailColumn.areaCol {
	height: 120px;
	vertical-align: top;
}
/* (3) Partition option : 2Type (left / right), Affacted elements(div), Range('partition'div영역 하단요소) */
/* 설명 : 좌,우로 분할되는 레이아웃 작성시 사용, 1라인에 1개 요소만 배치(줄바뀜 동반) */
/* 사용방법 : 분할할 영역에 partition CLASS를 적용 -> 분할배치하고자하는 하위요소에 'left, right' CLASS 적용 */
#divCustomWrapper div.partition .left {
	display: inline-block;
	clear: left;
	float: left;
}

#divCustomWrapper div.partition .right {
	display: inline-block;
	clear: right;
	float: right;
}
/* (4) In a row option : 2Type(left / right), Affacted elements(All), Range('inaRowRight or inRowLeft'div영역 하단요소) */
/* 설명 : 좌,우 끝에 정렬되는 레이아웃 작성 시 사용, 1라인에 여러개 요소 배치, Partition option과 조합(줄바뀜 없이 배치) */
/* 사용방법 : 나란히 정렬하고자 하는 요소들을, 'in a row'div 영역 내에 배치 */
#divCustomWrapper div.inaRowRight {
	text-align: right;
}

#divCustomWrapper div.inaRowLeft {
	text-align: left;
}
/* (5) button :  2Type(td / div), Affacted elements(All) */
/* 설명 : 행 추가, 행 삭제 버튼 작성 시 'viewModeHiddenPart'(기안 시 버튼 가려주는 클래스)와 조합해서 사용 */
/* 사용방법 : 테이블에 한줄로 사용 시 td에 'viewModeHiddenPart .td_button' CLASS 적용 -> 각 버튼에 'button' CLASS 적용 td 내 텍스트 아래에 쓰이거나 테이블 밖에서 사용 시 div에 viewModeHiddenPart .div_button CLASS 적용 -> 각 버튼에 button CLASS 적용 */
#divCustomWrapper .td_button {
	word-break: break-all;
	padding: 3px;
	border: none;
	width: 800px;
	height: 22px;
	text-align: right;
	vertical-align: middle;
}

#divCustomWrapper .div_button {
	word-break: break-all;
	padding: 3px;
	border: none;
	margin-top: 2px;
	margin-bottom: 2px;
	height: 22px;
	vertical-align: middle;
}

#divCustomWrapper a.button {
	background: rgb(102, 102, 102);
	color: rgb(255, 255, 255);
	padding: 2px 5px;
	border-radius: 3px;
	margin-right: 0px;
	margin-left: 0px;
	font-size: 9pt !important;
}
/* (6) p :  2Type(titleP / freeP), Affacted elements(All) */
/* 설명 : 테이블 별 소제목과 테이블 아래 설명 작성 시 사용*/
p.titleP {
	font-weight: bold;
	font-size: 12px;
	margin: 15px 1px 5px 5px; /*top right bottom left*/
}

p.freeP {
	font-weight: normal;
	font-size: 12px;
	margin: 1px 1px 3px 5px; /*top right bottom left*/
}
</style>
<!-- Common style (Don't modify) -->
<!-- Print style (Don't modify) -->
<style type="text/css">
/* 인쇄시에만 적용되는 스타일입니다. 순서대로 1.양식 인쇄 시 중앙으로 위치 2.테이블 테두리 고정 3.버튼 가리기 */
@media print {
	.viewModeHiddenPart {
		display: none;
	}
	h1, h2, h3, h4, h5, dl, dt, dd, ul, li, ol, th, td, p, blockquote, form,
		fieldset, legend, div, body {
		-webkit-print-color-adjust: exact;
	}
}
</style>
<!-- Print style (Don't modify)-->

</head>
<%
	Date date = new Date();
%>
<body>
	<div>
		<h2 style="text-align: center;">[증명서 발급]</h2>
		<button type="button" style="float: right;" onclick="createPDF();">다운로드</button>
	</div>
<div class="pdfArea">
 	<br>
	<!-- <!-- Page Wrapping (start) : Style retention -->
	<div id="divCustomWrapper" style="margin-top: 0px; margin-bottom: 0px;">
		<!-- Embededd Style이 적용받는 범위 입니다. 상단의 스타일은 이 요소 안에서만 동작합니다. -->
		<!-- 1. Title Section (start) : 문서제목이 작성되는 영역입니다. -->
		<div id="titleSection">재직증명서</div>
		<!-- 1. Title Section (end) -->
		<!-- 2. Draft Section (Start) : 결재정보가 작성되는 영역입니다. -->
		<div class="partition" id="draftSection">
			<!-- 2.1 Drafter Information (Start) -->
			<div class="left" style="margin-top: 0px; margin-bottom: 0px;"></div>	
		</div>
			<table class="detailSection">
				<colgroup>
					<!-- ### 테이블의 컬럼 너비는 colGroup을 통해 지정합니다. td에 지정 X ### -->
					<col width="100">
					<col width="100">
					<col width="200">
					<col width="100">
					<col width="300">
				</colgroup>
				<tbody>
					<tr>
						<td class="subjectColumn dext_table_border_t dext_table_border_r dext_table_border_b dext_table_border_l" colspan="5">
							인적사항</td>
					</tr>
					<tr>
						<td class="subjectColumn dext_table_border_t dext_table_border_r dext_table_border_b dext_table_border_l" colspan="5">
							성 명</td>
					</tr>
					<tr>
						<td	class="detailColumn dext_table_border_t dext_table_border_r dext_table_border_b dext_table_border_l text-center" colspan="5">
							<p style="text-align: center;"><span unselectable="on" contenteditable="false" class="comp_wrap" data-cid="4" data-dsl="{{text}}" data-wrapper="" style="width: 100%; margin-top: 0px; margin-bottom: 0px;"data-value="" data-autotype="">
							${empVO.empName }
							</span></p>
						</td>
					</tr>
						<td class="subjectColumn dext_table_border_t dext_table_border_r dext_table_border_b dext_table_border_l " colspan="5">
							주민등록번호</td>
					</tr>
					<tr>
						<td class="detailColumn dext_table_border_t dext_table_border_r dext_table_border_b dext_table_border_l text-center" colspan="5">
							<p style="text-align: center;">
							<c:choose>
								<c:when test="${regNo eq 'secret' }">
									<span unselectable="on" contenteditable="false" class="comp_wrap" data-cid="6" data-dsl="{{text}}" data-wrapper="" style="width: 100%; font-family: &quot;malgun gothic&quot;, dotum, arial, tahoma; font-size: 9pt; line-height: 18px; margin-top: 0px; margin-bottom: 0px;" data-value="" data-autotype="">${fn:substring(empVO.empRegno,0,8) }******</span>
								</c:when>
								<c:otherwise>
									<span unselectable="on" contenteditable="false" class="comp_wrap" data-cid="6" data-dsl="{{text}}" data-wrapper="" style="width: 100%; font-family: &quot;malgun gothic&quot;, dotum, arial, tahoma; font-size: 9pt; line-height: 18px; margin-top: 0px; margin-bottom: 0px;" data-value="" data-autotype="">${empVO.empRegno }</span>
								</c:otherwise>
							</c:choose>
							<br>
							</p>
						</td>
					</tr>
					<tr>
						<td class="subjectColumn dext_table_border_t dext_table_border_r dext_table_border_b dext_table_border_l" colspan="5">
							주 소</td>
					</tr>
					<tr>
						<td class="detailColumn dext_table_border_t dext_table_border_r dext_table_border_b dext_table_border_l text-center" colspan="5">
							<p style="text-align: center;">
								<span unselectable="on" contenteditable="false" class="comp_wrap" data-cid="5" data-dsl="{{text}}" data-wrapper=""
									style="width: 100%; margin-top: 0px; margin-bottom: 0px;"  data-value="" data-autotype="">${empVO.empAdd1 }&nbsp; &nbsp; ${empVO.empAdd2 }
								</span><br>
							</p>
						</td>
					</tr>
					<tr>
						<td class="subjectColumn dext_table_border_t dext_table_border_r dext_table_border_b dext_table_border_l" colspan="5">
							재직사항</td>
					</tr>
					<tr>
						<td class="subjectColumn dext_table_border_t dext_table_border_r dext_table_border_b dext_table_border_l" colspan="5">
							소 속</td>
					</tr>
					<tr>
						<td class="detailColumn dext_table_border_t dext_table_border_r dext_table_border_b dext_table_border_l text-center" colspan="5">
							<p style="text-align: center;">
								<span unselectable="on" contenteditable="false" class="comp_wrap" data-cid="7" data-dsl="{{text}}"
									data-wrapper="" style="width: 100%; margin-top: 0px; margin-bottom: 0px;" data-value="" data-autotype="">${empVO.deptVO.deptName }
								</span><br>
							</p>
						</td>
					</tr>
					<tr>
						<td class="subjectColumn dext_table_border_t dext_table_border_r dext_table_border_b dext_table_border_l" colspan="5">
							직 위</td>
					</tr>
					<tr>
						<td class="detailColumn dext_table_border_t dext_table_border_r dext_table_border_b dext_table_border_l text-center" colspan="5">
							<p style="text-align: center;">
								<span unselectable="on" contenteditable="false" class="comp_wrap" data-cid="8" data-dsl="{{text}}"
									data-wrapper="" style="width: 100%; margin-top: 0px; margin-bottom: 0px;"
									data-value="" data-autotype=""> ${empVO.codeVO.cdName } </span><br>
							</p>
						</td>
					</tr>
					<tr>
						<td	class="subjectColumn dext_table_border_t dext_table_border_r dext_table_border_b dext_table_border_l" colspan="5">
							재직기간</td>
					</tr>
					<tr>
						<td class="detailColumn dext_table_border_t dext_table_border_r dext_table_border_b dext_table_border_l text-center" colspan="5">
							<p style="text-align: center;">
							<fmt:formatDate value="${empVO.empHire }" pattern="yyyy.MM.dd" var="hireDate"/>
							<fmt:formatDate value="${docHistoryVO.docDate }" pattern="yyyy.MM.dd" var="docDate"/>
								<span unselectable="on" contenteditable="false" class="comp_wrap" data-cid="9" data-dsl="{{period}}" 
								data-wrapper="" style="margin-top: 0px; margin-bottom: 0px;" data-value="" data-autotype="">
									${hireDate } ~ ${docDate } </span><br>
							</p>
						</td>
					</tr>
					<tr>
						<td class="subjectColumn dext_table_border_t dext_table_border_r dext_table_border_b dext_table_border_l" colspan="5">
							발급용도</td>
					</tr>
					<tr>
						<td class="detailColumn dext_table_border_t dext_table_border_r dext_table_border_b dext_table_border_l text-center" colspan="5">
							<p style="text-align: center;">
								<span unselectable="on" contenteditable="false" class="comp_wrap" data-cid="10" data-dsl="{{text}}"
								data-wrapper="" style="width: 100%; margin-top: 0px; margin-bottom: 0px;"
								data-value="" data-autotype="">제출용</span><br>
							</p>
						</td>
					</tr>
					<tr>
						<td style="text-align: center;" colspan="5" class="detailColumn dext_table_border_t dext_table_border_r dext_table_border_b dext_table_border_l" >
							<br>
							<br>
							<br>
							<br>
							위와 같이 재직하고 있음을 증명합니다.
							<br>
							<br>
							<br>
							<fmt:formatDate value="<%=date %>" pattern="yyyy년 MM월 dd일" var="now"/>
							<br>
							${now }
							<br>
							<br>
							<br>
							<br>
							<br>
							<img style="width: 50px;" alt="iworks" src="${pageContext.request.contextPath}/resources/assets/gw/IW_Logo.png">
						</td>
					</tr>
				</tbody>
			</table>
		</div>
</div>
</body>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bluebird/3.7.2/bluebird.min.js"></script>
<!-- jsPDF : PDF 파일을 생성하고 다운로드 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.5.3/jspdf.min.js"></script>
<!-- html2canvas : 웹 페이지의 DOM 요소를 캡처해 이미지로 만듦 -->
<script src="https://unpkg.com/html2canvas@1.0.0-rc.5/dist/html2canvas.js"></script>

<script type="text/javascript">
var renderedImg = new Array;
var contWidth = 200, // 너비(mm) (a4에 맞춤)
    padding = 5; // 상하좌우 여백(mm)

function createPDF(){ // 이미지를 pdf로 만들기
	var lists = $(".pdfArea > div"), // 출력 대상 명확히 지정 필요 -> div가 한 묶음으로 출력
   	
	deferreds = [],
	doc = new jsPDF("p", "mm", "a4"),
	listsLeng = lists.length;
    
	for (var i = 0; i < listsLeng; i++) { // div 개수만큼 이미지 생성
		var deferred = $.Deferred();
		deferreds.push(deferred.promise());
		generateCanvas(i, doc, deferred, lists[i]);
		}


	$.when.apply($, deferreds).then(function () { // 이미지 렌더링이 	끝난 후
		var sorted = renderedImg.sort(function(a,b){return a.num <b.num ? -1 : 1;}), // 순서대로 정렬
			curHeight = padding, // 위 여백 (이미지가 들어가기 시작할 y축)
			sortedLeng = sorted.length;
		
		for (var i = 0; i < sortedLeng; i++) {
			
			var sortedHeight = sorted[i].height, //이미지 높이
				sortedImage = sorted[i].image; //이미지
			if( curHeight + sortedHeight > 297 - padding * 2 ){ // a4 높이에 맞게 남은 공간이 이미지 높이보다 작을 경우 페이지 추가
				doc.addPage(); // 페이지를 추가함
				curHeight = padding; // 이미지가 들어갈 y축을 초기 여백값으로 초기화
				doc.addImage(sortedImage, 'jpeg', padding , curHeight, contWidth, sortedHeight); // 이미지 넣기
				curHeight += sortedHeight; // y축 = 여백 + 새로 들어간 이미지 높이
			} else { // 페이지에 남은 공간보다 이미지가 작으면 페이지 추가하지 않음
				doc.addImage(sortedImage, 'jpeg', padding , curHeight, contWidth, sortedHeight); // 이미지 넣기
				curHeight += sortedHeight; // y축 = 기존y축 + 새로 들어간 이미지 높이
			}
		}
			doc.save('재직증명서_IWORKS.pdf'); // pdf 저장
			curHeight = padding; // y축 초기화
			renderedImg = new Array; // 이미지 배열 초기화
	});
	

	function generateCanvas(i, doc, deferred, curList){ // 페이지를 이미지로 만들기
		var pdfWidth = $(curList).outerWidth() * 0.2645, // px -> mm로 변환
			pdfHeight = $(curList).outerHeight() * 0.2645,
			heightCalc = contWidth * pdfHeight / pdfWidth;
			html2canvas( curList ).then(
				function (canvas) {
					var img = canvas.toDataURL('image/jpeg', 1.0); // 이미지 형식 지정
					renderedImg.push({num:i, image:img,
					height:heightCalc}); // renderedImg 배열에 이미지 데이터 저장(뒤죽박죽 방지)
					deferred.resolve(); // 결과 보내기
				}
			);
			
		}
    }
</script>
</html>












































