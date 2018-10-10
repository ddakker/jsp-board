<%--
  Created by IntelliJ IDEA.
  User: TRQ1
  Date: 2018. 10. 8.
  Time: AM 11:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@include file="database_process.jsp" %>
<%
    String author = request.getParameter("author");
    String password = request.getParameter("password");
    String title = request.getParameter("title");
    String content = request.getParameter("content");
    int idx = Integer.parseInt(request.getParameter("id"));

    Connection conn = connDb();
    PreparedStatement pstm = null;
    PreparedStatement pstmUpdate = null;
    ResultSet rs = null;
    int parent = 0;
    int indent = 0;
    int step = 0;
    int count = 0;
    int countAfter = 0;

    try {
        String sqlId = "SELECT parent, indent, step FROM board WHERE id=" + idx;
        pstm = conn.prepareStatement(sqlId);
        rs = pstm.executeQuery(sqlId);

        if (rs.next()) {
            parent = rs.getInt(1);
            indent = rs.getInt(2);
            step = rs.getInt(3);
        }

        count = sqlCount();
        String sqlUpdate = "UPDATE board SET step=step+1 where parent=" + parent + " and step>" + step;
        pstmUpdate = conn.prepareStatement(sqlUpdate);
        System.out.println(pstmUpdate);
        pstmUpdate.executeUpdate(sqlUpdate);

        System.out.println("Step: " + step);
        System.out.println("parent: " + parent);
        System.out.println("parent: " + parent);
        sqlReplyInsert(author, password, title, content, "comment", parent, indent, step);
        countAfter = sqlCount();
    } catch (SQLException e) {
        System.out.println(e);
    } finally {
        close(pstm, conn);
        resultClose(rs);
    }

    if (count + 1 == countAfter) {
%>
<script language=javascript>
    self.window.alert("입력한 글을 저장하였습니다.");
    location.href = "lists.jsp";
</script>
<%
    }
%>
