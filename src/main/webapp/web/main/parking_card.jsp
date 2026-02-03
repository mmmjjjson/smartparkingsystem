<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<div class="parking-card <%= request.getAttribute("status") %>">
    <div class="box-id"><%= request.getAttribute("id") %></div>
    <div class="box-car"><%= request.getAttribute("car") != null ? request.getAttribute("car") : "사용 가능" %></div>
    <div class="box-time"><%= request.getAttribute("time") != null ? request.getAttribute("time") : "" %></div>
</div>
