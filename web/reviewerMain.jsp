<%--
  Created by IntelliJ IDEA.
  User: Vasya
  Date: 05.04.13
  Time: 13:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="myServlet.DataBaseConnection"%>
<%@ page contentType="text/html;charset=WINDOWS-1251" language="java" %>
<html>
<head>
    <title>Reviewer main page</title>
</head>
<body>
    <%  request.setCharacterEncoding("WINDOWS-1251");

        ResultSet rs;
        ResultSet themes;
        ResultSet articles;
        boolean articleExist = false;
        int role = Integer.parseInt(request.getParameter("role"));
        int id  = Integer.parseInt(request.getParameter("id"));

        ResultSet reviewer = DataBaseConnection.getRecords("SELECT * FROM REVIEWER "
                + "WHERE REVIEWER_ID=" + id);
        reviewer.next();

    %>
    <h1>Личный кабинет рецензента <%=reviewer.getString("NAME")%></h1>
    <p>Статьи с подходящей вам тематикой:</p>
    <ul><%
    themes = DataBaseConnection.getRecords("SELECT * FROM REVIEWER_THEMS WHERE REVIEWER_ID = " + id);
    while (themes.next()){
        rs = DataBaseConnection.getRecords("SELECT * FROM THEME WHERE THEME_ID = " + themes.getString("THEME_ID"));
        rs.next();
        %><li><%=rs.getString("LABEL")%></li><%
    }
    %></ul>


    <table border="1">
    <tr>
        <td>id</td><td>Тема</td><td>Название</td><td>Авторы</td>
        <td>Дата написания</td><td>Статус</td>
    </tr><%
    themes = DataBaseConnection.getRecords("SELECT * FROM REVIEWER_THEMS WHERE REVIEWER_ID = " + id);
    while (themes.next()){
        articles = DataBaseConnection.getRecords("SELECT * FROM ARTICLE WHERE THEME_ID = "
                + themes.getString("THEME_ID") + " AND STATUS < 3");
        while (articles.next())
        {
            articleExist = true;
            %><tr>
            <td><%=articles.getString("ARTICLE_ID")%></td>
            <td><% rs = DataBaseConnection.getRecords("SELECT * FROM THEME "
                    + "WHERE THEME_ID=" + Integer.parseInt(articles.getString("THEME_ID")));
                rs.next();
                System.out.println(articles.getString("TITLE"));%>
                <%=rs.getString("LABEL")%></td>
            <td><a href="aboutArticle.jsp?id=<%=id%>&role=<%=role%>&article=<%=articles.getString("ARTICLE_ID")%>"><%=articles.getString("TITLE")%></a></td>
            <td><% rs = DataBaseConnection.getRecords("SELECT * FROM ARTICLE_AUTHORS "
                                                            + "WHERE ARTICLE_ID=" + Integer.parseInt(articles.getString("ARTICLE_ID")));
            while (rs.next()){
                ResultSet nrs = DataBaseConnection.getRecords("SELECT * FROM AUTHOR "
                        + "WHERE AUTHOR_ID=" + rs.getString("AUTHOR_ID"));
                nrs.next();
            %><a href="aboutAuthor.jsp?id=<%=id%>&role=<%=role%>&author=<%=nrs.getString("AUTHOR_ID")%>"><%=nrs.getString("NAME")%></a><br>
            <%}%>
            <td><%=articles.getString("WRITE_DATE")%></td>
            <td><% rs = DataBaseConnection.getRecords("SELECT * FROM STATUS "
                    + "WHERE STATUS_ID=" + Integer.parseInt(articles.getString("STATUS")));
                rs.next();%>
                <%=rs.getString("DESCRIPTION")%></td>
            </td>
            </tr><%
        }
    }
    %></table><%
        if (!articleExist){
            %><p style="color: red">Подходящие статьи отсутствуют</p><%
        }
    %>
    <a href="index.jsp">Выход</a>

</body>
</html>