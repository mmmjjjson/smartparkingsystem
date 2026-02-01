<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String status = (String) request.getAttribute("status");
    String id = (String) request.getAttribute("id");
    String car = (String) request.getAttribute("car");
    String timer = (String) request.getAttribute("time");

    String carNum = car != null ? car : "사용 가능";
    String time = timer != null ? timer : "";
%>
<div class="parking-card <%=status%>"
    data-status="<%=status%>"
    data-id="<%=id%>"
    data-carNum="<%=car != null ? car : ""%>"
    data-full-time="<%=time%>"
    data-car-type="">

    <!-- 출력용 -->
    <div class="box-id"><%=id%></div>
    <div class="box-car"><%=carNum%></div>
    <div class="box-time"><%=time%></div>
</div>