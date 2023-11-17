<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<c:set value="text-info fw-bold" var="focus"/>
      <nav class="navbar navbar-vertical navbar-expand-lg">
        <script>
          var navbarStyle = window.config.config.phoenixNavbarStyle;
          if (navbarStyle && navbarStyle !== 'transparent') {
            document.querySelector('body').classList.add(`navbar-${navbarStyle}`);
          }
        </script>
        <div class="collapse navbar-collapse" id="navbarVerticalCollapse">
          <!-- scrollbar removed-->
          <div class="navbar-vertical-content">
            <ul class="navbar-nav flex-column" id="navbarVerticalNav">
              <li class="nav-item">
                <!-- parent pages-->
                <div class="nav-item-wrapper">
                  <div class="nav-item-wrapper">
	                  <a class="nav-link label-1" href="/" role="button" data-bs-toggle="" aria-expanded="false">
	                    <div class="d-flex align-items-center">
	                    	<span class="uil uil-home fs-1"></span><span class="nav-link-icon"><span class="nav-link-text">&nbsp;&nbsp;&nbsp;Home</span></span>
	                    </div>
	                  </a>
                  </div>
                </div>
                <!-- parent pages-->
                <div class="nav-item-wrapper"><a class="nav-link dropdown-indicator label-1" href="#nv-mypage" role="button" data-bs-toggle="collapse" aria-expanded="${not empty myInfo}" aria-controls="nv-email">
                    <div class="d-flex align-items-center">
                      <div class="dropdown-indicator-icon"><span class="fas fa-caret-right"></span></div><span class="uil uil-user fs-1"></span><span class="nav-link-text">&nbsp;&nbsp;&nbsp;내정보</span>
                    </div>
                  </a>
                  <div class="parent-wrapper label-1">
                    <ul class="nav collapse parent <c:if test="${not empty myInfo}">show</c:if>" data-bs-parent="#navbarVerticalCollapse" id="nv-mypage">
                      <li class="collapsed-nav-item-title d-none">mypage
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/myinfo.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty myInfo1}'>${focus }</c:if>">개인정보</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                      <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/dochistory.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty myInfo2}'>${focus }</c:if>">증명서출력</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                    </ul>
                  </div>
                </div>
              </li>
              <li class="nav-item">
                <!-- label-->
<!--                 <p class="navbar-vertical-label">Apps -->
                </p>
                <hr class="navbar-vertical-line" />
                <!-- parent pages-->
                <div class="nav-item-wrapper"><a class="nav-link dropdown-indicator label-1" href="#nv-e-commerce" role="button" data-bs-toggle="collapse" aria-expanded="${not empty attendBar }" aria-controls="nv-e-commerce">
                    <div class="d-flex align-items-center">
                      <div class="dropdown-indicator-icon"><span class="fas fa-caret-right"></span></div><span class="uil uil-clock fs-1"></span><span class="nav-link-text">&nbsp;&nbsp;&nbsp;근태</span>
                    </div>
                  </a>
                  <div class="parent-wrapper label-1">
                    <ul class="nav collapse parent <c:if test="${not empty attendBar}">show</c:if>" data-bs-parent="#navbarVerticalCollapse" id="nv-e-commerce">
                      <li class="collapsed-nav-item-title d-none">E commerce
                      </li>

                      <li class="nav-item">
                      	<a class="nav-link dropdown-indicator" href="#nv-customer" data-bs-toggle="collapse" aria-expanded="true" aria-controls="nv-customer">
                          <div class="d-flex align-items-center">
                            <div class="dropdown-indicator-icon"><span class="fas fa-caret-right"></span></div><span class="nav-link-text">출퇴근관리</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                        <div class="parent-wrapper">
                          <ul class="nav collapse parent show" data-bs-parent="#e-commerce" id="nv-customer">
                            <li class="nav-item"><a class="nav-link" href="/attendance.do" data-bs-toggle="" aria-expanded="false">
                                <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty attendBar1}'>${focus }</c:if>">출근/퇴근</span>
                                </div>
                              </a>
                              <!-- more inner pages-->
                            </li>
                            <li class="nav-item">
                            	<a class="nav-link" href="/attendsituation.do" data-bs-toggle="" aria-expanded="false">
                                	<div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty attendBar2}'>${focus }</c:if>">근태현황</span>
                                		
                                	</div>
                             	 </a>
                              <!-- more inner pages-->
                            </li>
                            
                          </ul>
                        </div>
                      </li>
                      <li class="nav-item">
                      	<a class="nav-link" href="/ayannlist.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center">
                            <span class="nav-link-text <c:if test='${not empty attendBar3}'>${focus }</c:if>">연차관리</span>
                          </div>
                        </a>
                      </li>
                    </ul>
                  </div>
                </div>
                <!-- parent pages-->
                <div class="nav-item-wrapper"><a class="nav-link dropdown-indicator label-1" href="#nv-events" role="button" data-bs-toggle="collapse" aria-expanded="${not empty taskBar}" aria-controls="nv-events">
                    <div class="d-flex align-items-center">
                      <div class="dropdown-indicator-icon"><span class="fas fa-caret-right"></span></div><span class="uil uil-archive fs-1"></span><span class="nav-link-text">&nbsp;&nbsp;&nbsp;업무</span>
                    </div>
                  </a>
                  <div class="parent-wrapper label-1">
                    <ul class="nav collapse parent <c:if test="${not empty taskBar}">show</c:if>" data-bs-parent="#navbarVerticalCollapse" id="nv-events">
                      <li class="collapsed-nav-item-title d-none">Events
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/task.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty taskBar1}'>${focus }</c:if>">내업무현황</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/mytaskdetail.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty taskBar2}'>${focus }</c:if>">세부업무목록</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                    </ul>
                  </div>
                </div>
                <!-- parent pages-->
                <div class="nav-item-wrapper"><a class="nav-link dropdown-indicator label-1" href="#nv-kanban" role="button" data-bs-toggle="collapse" aria-expanded="${not empty draftBar}" aria-controls="nv-kanban">
                    <div class="d-flex align-items-center">
                      <div class="dropdown-indicator-icon"><span class="fas fa-caret-right"></span></div><span class="uil uil-check fs-1"></span><span class="nav-link-text">&nbsp;&nbsp;&nbsp;결재</span>
                    </div>
                  </a>
                  <div class="parent-wrapper label-1">
                    <ul class="nav collapse parent <c:if test="${not empty draftBar}">show</c:if>" data-bs-parent="#navbarVerticalCollapse" id="nv-kanban">
                      <li class="collapsed-nav-item-title d-none">Kanban
                      </li>
                      <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath }/draft/write.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty draftBar1}'>${focus }</c:if>">기안서작성</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                      <li class="nav-item">
                      	<a class="nav-link dropdown-indicator" href="#nv-customer" data-bs-toggle="collapse" aria-expanded="true" aria-controls="nv-customer">
                          <div class="d-flex align-items-center">
                            <div class="dropdown-indicator-icon"><span class="fas fa-caret-right"></span></div><span class="nav-link-text">기안함</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                        <div class="parent-wrapper">
                          <ul class="nav collapse parent show" data-bs-parent="#e-commerce" id="nv-customer">
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath }/draft/tempsave.do" data-bs-toggle="" aria-expanded="false">
                                <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty draftBar2}'>${focus }</c:if>">임시저장문서</span>
                                <span class="badge bg-info-500 ms-2" id="tsDocCnt"><!-- 임시저장문서 갯수 --></span>	
                                </div>
                              </a>
                              <!-- more inner pages-->
                            </li>
                            <li class="nav-item">
                            	<a class="nav-link" href="${pageContext.request.contextPath }/draft/progdoc.do" data-bs-toggle="" aria-expanded="false">
                                	<div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty draftBar3}'>${focus }</c:if>">진행중문서</span>
                                	 <span class="badge bg-info-500 ms-2" id="progDocCnt"><!-- 진행중문서 갯수 --></span>
                                	</div>
                             	 </a>
                              <!-- more inner pages-->
                            </li>
                            <li class="nav-item">
                            	<a class="nav-link" href="${pageContext.request.contextPath }/draft/retdoc.do" data-bs-toggle="" aria-expanded="false">
                                	<div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty draftBar4}'>${focus }</c:if>">반려문서</span>
                                	<span class="badge bg-danger-500 ms-2" id="retDocCnt"><!-- 반려문서 갯수 --></span>	
                                	</div>
                             	 </a>
                              <!-- more inner pages-->
                            </li>
                            <li class="nav-item">
                            	<a class="nav-link" href="${pageContext.request.contextPath }/draft/comdoc.do" data-bs-toggle="" aria-expanded="false">
                                	<div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty draftBar5}'>${focus }</c:if>">완료문서</span>
                	               	<span class="badge bg-info-500 ms-2" id="comDocCnt"><!-- 완료문서 갯수 --></span>	
                                	</div>
                             	 </a>
                              <!-- more inner pages-->
                            </li>
                            
                          </ul>
                        </div>
                      </li>
                    <!-- 사원 레벨이 2,3이면 결재함이 보이도록  --> 
                    <sec:authentication property="principal.emp.empLevel" var="level"/> 
                    <c:if test="${level ne '1' }">
                      <li class="nav-item">
                      	<a class="nav-link dropdown-indicator" href="#nv-customer" data-bs-toggle="collapse" aria-expanded="true" aria-controls="nv-customer">
                          <div class="d-flex align-items-center">
                            <div class="dropdown-indicator-icon"><span class="fas fa-caret-right"></span></div><span class="nav-link-text">결재함</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                        <div class="parent-wrapper">
                          <ul class="nav collapse parent show" data-bs-parent="#e-commerce" id="nv-customer">
                            <li class="nav-item">
                            	<a class="nav-link" href="${pageContext.request.contextPath }/auth/waitdoc.do" data-bs-toggle="" aria-expanded="false">
                                <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty draftBar6}'>${focus }</c:if>">결재대기문서</span>
                               	<span class="badge bg-info-500 ms-2" id="waitDocCnt"><!-- 결재대기문서 갯수 --></span>	
                                </div>
                              </a>
                              <!-- more inner pages-->
                            </li>
                            <li class="nav-item">
                            	<a class="nav-link" href="${pageContext.request.contextPath }/auth/refdoc.do" data-bs-toggle="" aria-expanded="false">
                                	<div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty draftBar7}'>${focus }</c:if>">참조문서</span>
                                  	<span class="badge bg-info-500 ms-2" id="refDocCnt"><!-- 참조문서 갯수 --></span>	
                                	</div>
                             	 </a>
                              <!-- more inner pages-->
                            </li>
                            <li class="nav-item">
                            	<a class="nav-link" href="${pageContext.request.contextPath }/auth/retdoc.do" data-bs-toggle="" aria-expanded="false">
                                	<div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty draftBar8}'>${focus }</c:if>">반려문서</span>
                                	<span class="badge bg-danger-500 ms-2" id="returnDocCnt"><!-- 반려 문서 갯수 --></span>		
                                	</div>
                             	 </a>
                              <!-- more inner pages-->
                            </li>
                            <li class="nav-item">
                            	<a class="nav-link" href="${pageContext.request.contextPath }/auth/comdoc.do" data-bs-toggle="" aria-expanded="false">
                                	<div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty draftBar9}'>${focus }</c:if>">완료문서</span>
                                	<span class="badge bg-info-500 ms-2" id="completeDocCnt"><!-- 완료문서 갯수 --></span>		
                                	</div>
                             	 </a>
                              <!-- more inner pages-->
                            </li>
                            
                          </ul>
                        </div>
                      </li>
                   </c:if>
                   
                      <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath }/auth/appline.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty draftBar10}'>${focus }</c:if>">결재선관리</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                    </ul>
                  </div>
                </div>
                <!-- parent pages-->
                <div class="nav-item-wrapper"><a class="nav-link dropdown-indicator label-1" href="#nv-email" role="button" data-bs-toggle="collapse" aria-expanded="${not empty mailBar}" aria-controls="nv-email">
                    <div class="d-flex align-items-center">
                      <div class="dropdown-indicator-icon"><span class="fas fa-caret-right"></span></div><span class="uil uil-envelope-alt fs-1"></span><span class="nav-link-text">&nbsp;&nbsp;&nbsp;메일</span>
                    </div>
                  </a>
                  <div class="parent-wrapper label-1">
                    <ul class="nav collapse parent <c:if test="${not empty mailBar }">show</c:if>" data-bs-parent="#navbarVerticalCollapse" id="nv-email">
                      <li class="collapsed-nav-item-title d-none">Email
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/sendmail.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty mailBar1}'>${focus }</c:if>">메일보내기</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/receivedmail.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center">
                          	<span class="nav-link-text <c:if test='${not empty mailBar2}'>${focus }</c:if>">받은메일함</span>
                          	<span class="badge bg-info-500 ms-2" id="unreadMailCnt"><!-- 안읽은 메일 갯수 --></span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/sendedmail.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty mailBar3}'>${focus }</c:if>">보낸메일함</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/receivedmyselfmail.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty mailBar4}'>${focus }</c:if>">내게쓴메일함</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/importantmail.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty mailBar5}'>${focus }</c:if>">중요메일함</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/deletedmail.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty mailBar6}'>${focus }</c:if>">휴지통</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                    </ul>
                  </div>
                </div>
                
                
                <!-- parent pages-->
         		<!-- <div class="nav-item-wrapper"><a class="nav-link label-1" href="apps/chat.html" role="button" data-bs-toggle="" aria-expanded="false">
                    <div class="d-flex align-items-center"><span class="nav-link-icon"><span data-feather="message-square"></span></span><span class="nav-link-text-wrapper"><span class="nav-link-text">채팅</span></span>
                    </div>
                  </a>
                </div> -->
                
                <!-- parent pages-->
				<div class="nav-item-wrapper">
						<a class="nav-link label-1" href="/chatMain.do"
							role="button" data-bs-toggle="" aria-expanded="false">
							<div class="d-flex align-items-center">
								<span class="uil uil-chat fs-1"></span> 
								<span class="nav-link-text-wrapper"> 
							<span class="nav-link-text <c:if test='${not empty chatBar}'>${focus }</c:if>">&nbsp;&nbsp;&nbsp;채팅</span></span>
						</div> 
					</a>
				</div>
                
                
                <!-- parent pages-->
                <div class="nav-item-wrapper"><a class="nav-link dropdown-indicator label-1" href="#nv-project-management" role="button" data-bs-toggle="collapse" aria-expanded="${not empty addBar}" aria-controls="nv-project-management">
                    <div class="d-flex align-items-center">
                      <div class="dropdown-indicator-icon"><span class="fas fa-caret-right"></span></div><span class="uil uil-phone fs-1"></span></span><span class="nav-link-text">&nbsp;&nbsp;&nbsp;주소록</span>
                    </div>
                  </a>
                  <div class="parent-wrapper label-1">
                    <ul class="nav collapse parent <c:if test="${not empty addBar}">show</c:if>" data-bs-parent="#navbarVerticalCollapse"  id="nv-project-management">
                      <li class="collapsed-nav-item-title d-none">Project management
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/add/comadd.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty addBar1}'>${focus }</c:if>">전사주소록</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                      <li class="nav-item">
                      	<a class="nav-link dropdown-indicator" href="#nv-customer" data-bs-toggle="collapse" aria-expanded="true" aria-controls="nv-customer">
                          <div class="d-flex align-items-center">
                            <div class="dropdown-indicator-icon"><span class="fas fa-caret-right"></span></div><span class="nav-link-text ">내주소록</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                        <div class="parent-wrapper">
                          <ul class="nav collapse parent show" data-bs-parent="#e-commerce" id="nv-customer">
                            <li class="nav-item"><a class="nav-link" href="/add/myadd.do" data-bs-toggle="" aria-expanded="false">
                                <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty addBar2}'>${focus }</c:if>">즐겨찾는주소록</span>
                                </div>
                              </a>
                              <!-- more inner pages-->
                            </li>
                            <li class="nav-item">
                            	<a class="nav-link" href="/add/myextadd.do" data-bs-toggle="" aria-expanded="false">
                                	<div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty addBar3}'>${focus }</c:if>">거래처주소록</span>
                                		
                                	</div>
                             	 </a>
                              <!-- more inner pages-->
                            </li>
                          </ul>
                        </div>
                      </li>
                    </ul>
                  </div>
                </div>
                <!-- parent pages-->
                <div class="nav-item-wrapper">
                  <a class="nav-link label-1" href="/schedule.do" role="button" data-bs-toggle="" aria-expanded="false">
                    <div class="d-flex align-items-center"><span class="uil uil-calender fs-1"></span><span class="nav-link-text-wrapper"><span class="nav-link-text <c:if test='${not empty scheduleBar }'>${focus }</c:if>">&nbsp;&nbsp;&nbsp;일정</span></span>
                    </div>
                  </a>
                </div>
                
                <!-- parent pages-->
                <div class="nav-item-wrapper"><a class="nav-link dropdown-indicator label-1" href="#nv-social" role="button" data-bs-toggle="collapse" aria-expanded="${not empty fileBar}" aria-controls="nv-social">
                    <div class="d-flex align-items-center">
                      <div class="dropdown-indicator-icon"><span class="fas fa-caret-right"></span></div><span class="uil uil-folder fs-1"></span><span class="nav-link-text">&nbsp;&nbsp;&nbsp;자료실</span>
                    </div>
                  </a>
                  <div class="parent-wrapper label-1">
                    <ul class="nav collapse parent <c:if test="${not empty fileBar}">show</c:if>" data-bs-parent="#navbarVerticalCollapse" id="nv-social">
                      <li class="collapsed-nav-item-title d-none">Social
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/comfiles.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty fileBar1}'>${focus }</c:if>">전사자료실</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/depfiles.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty fileBar2}'>${focus }</c:if>">부서자료실</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/indfiles.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty fileBar3}'>${focus }</c:if>">개인자료실</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/impfiles.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty fileBar4}'>${focus }</c:if>">즐겨찾는자료</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                    </ul>
                  </div>
                </div>
                
              </li>
              <li class="nav-item">
                <!-- label-->
<!--                 <p class="navbar-vertical-label">Pages -->
<!--                 </p> -->
                <hr class="navbar-vertical-line" />
                
               
                
                <!-- parent pages-->
                <div class="nav-item-wrapper"><a class="nav-link dropdown-indicator label-1" href="#nv-landing22" role="button" data-bs-toggle="collapse" aria-expanded="${not empty resBar}" aria-controls="nv-landing">
                    <div class="d-flex align-items-center">
                      <div class="dropdown-indicator-icon"><span class="fas fa-caret-right "></span></div><span class="uil uil-check-circle fs-1"></span><span class="nav-link-text">&nbsp;&nbsp;&nbsp;예약</span>
                    </div>
                  </a>
                  <div class="parent-wrapper label-1">
                    <ul class="nav collapse parent <c:if test="${not empty resBar}">show</c:if>" data-bs-parent="#navbarVerticalCollapse"  id="nv-landing22">
                      <li class="collapsed-nav-item-title d-none">Landing
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/room/room.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty resBar1}'>${focus }</c:if>">회의실예약</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/ass/asset.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty resBar2}'>${focus }</c:if>">자산대여</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/rsv/seatlayout.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty resBar3}'>${focus }</c:if>">자율좌석예약</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/myrsv/list.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty resBar4}'>${focus }</c:if>">내예약</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                    </ul>
                  </div>
                </div>
                <!-- parent pages-->
                <div class="nav-item-wrapper"><a class="nav-link dropdown-indicator label-1" href="#nv-landing" role="button" data-bs-toggle="collapse" aria-expanded="${not empty boardBar}" aria-controls="nv-landing">
                    <div class="d-flex align-items-center">
                      <div class="dropdown-indicator-icon"><span class="fas fa-caret-right"></span></div><span class="uil uil-globe fs-1"></span><span class="nav-link-text">&nbsp;&nbsp;&nbsp;커뮤니티</span>
                    </div>
                  </a>
                  <div class="parent-wrapper label-1">
                    <ul class="nav collapse parent <c:if test="${not empty boardBar}">show</c:if>" data-bs-parent="#navbarVerticalCollapse" id="nv-landing">
                      <li class="collapsed-nav-item-title d-none">Landing
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/noticemain.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty boardBar1}'>${focus }</c:if>">공지사항</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/freemain.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty boardBar2}'>${focus }</c:if>">자유게시판</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                      <li class="nav-item"><a class="nav-link" href="/feventmain.do" data-bs-toggle="" aria-expanded="false">
                          <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty boardBar3}'>${focus }</c:if>">경조사게시판</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                      </li>
                      <li class="nav-item">
                      	<a class="nav-link dropdown-indicator" href="#nv-customer" data-bs-toggle="collapse" aria-expanded="true" aria-controls="nv-customer">
                          <div class="d-flex align-items-center">
                            <div class="dropdown-indicator-icon"><span class="fas fa-caret-right"></span></div><span class="nav-link-text">동호회게시판</span>
                          </div>
                        </a>
                        <!-- more inner pages-->
                        <div class="parent-wrapper">
                          <ul class="nav collapse parent show" data-bs-parent="#e-commerce" id="nv-customer">
                          	<li class="nav-item"><a class="nav-link" href="/clubmain.do" data-bs-toggle="" aria-expanded="false">
                                <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty boardBar4}'>${focus }</c:if>">동호회메인</span>
                                </div>
                              </a>
                              <!-- more inner pages-->
                            </li>
                            <li class="nav-item"><a class="nav-link" href="/clubmypage.do" data-bs-toggle="" aria-expanded="false">
                                <div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty boardBar5}'>${focus }</c:if>">내동호회</span>
                                </div>
                              </a>
                              <!-- more inner pages-->
                            </li>
                            <li class="nav-item">
                            	<a class="nav-link" href="/createclub.do" data-bs-toggle="" aria-expanded="false">
                                	<div class="d-flex align-items-center"><span class="nav-link-text <c:if test='${not empty boardBar6}'>${focus }</c:if>">동호회개설</span>
                                		
                                	</div>
                             	 </a>
                              <!-- more inner pages-->
                            </li>
                            
                          </ul>
                        </div>
                      </li>
                    </ul>
                  </div>
                </div>
                
              
              </li>
              
            </ul>
          </div>
        </div>
        <div class="navbar-vertical-footer">
          <button class="btn navbar-vertical-toggle border-0 fw-semi-bold w-100 white-space-nowrap d-flex align-items-center"><span class="uil uil-left-arrow-to-left fs-0"></span><span class="uil uil-arrow-from-right fs-0"></span><span class="navbar-vertical-footer-text ms-2">Collapsed View</span></button>
        </div>
      </nav>
      
      
<script>
$(function(){
	unreadMailCnt();
	docCnt();
});

function unreadMailCnt(){
	$.ajax({
		type: 'get',
		url: '/unreadmailcnt.do',
		success: function(cnt){
			$("#unreadMailCnt").text(cnt);
		}
	});
}

function docCnt(){
	$.ajax({
		type: 'get',
		url: '/draftCnt/tsCnt.do',
		success: function(cnt){
			$("#tsDocCnt").text(cnt);
		}
	});
	
	$.ajax({
		type: 'get',
		url: '/draftCnt/progCnt.do',
		success: function(cnt){
			$("#progDocCnt").text(cnt);
		}
	});
	$.ajax({
		type: 'get',
		url: '/draftCnt/retCnt.do',
		success: function(cnt){
			$("#retDocCnt").text(cnt);
		}
	});
	$.ajax({
		type: 'get',
		url: '/draftCnt/comCnt.do',
		success: function(cnt){
			$("#comDocCnt").text(cnt);
		}
	});
	$.ajax({
		type: 'get',
		url: '/draftCnt/waitCnt.do',
		success: function(cnt){
			$("#waitDocCnt").text(cnt);
		}
	});
	$.ajax({
		type: 'get',
		url: '/draftCnt/refCnt.do',
		success: function(cnt){
			$("#refDocCnt").text(cnt);
		}
	});
	$.ajax({
		type: 'get',
		url: '/draftCnt/returnCnt.do',
		success: function(cnt){
			$("#returnDocCnt").text(cnt);
		}
	});
	$.ajax({
		type: 'get',
		url: '/draftCnt/completeCnt.do',
		success: function(cnt){
			$("#completeDocCnt").text(cnt);
		}
	});
	
}

</script>