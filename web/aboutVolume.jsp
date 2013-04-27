<%@ page import="java.sql.ResultSet" %>
<%@ page import="myServlet.DataBaseConnection" %>
<%--
  Created by IntelliJ IDEA.
  User: Vasya
  Date: 21.04.13
  Time: 22:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>About volume</title>
</head>
<body>
    <%
        request.setCharacterEncoding("WINDOWS-1251");

        int role = Integer.parseInt(request.getParameter("role"));
        int id  = Integer.parseInt(request.getParameter("id"));
        int volumeId  = Integer.parseInt(request.getParameter("volume"));

        ResultSet rs;
        ResultSet articles;
        ResultSet volume = DataBaseConnection.getRecords("SELECT * FROM VOLUME WHERE VOLUME_ID = " + volumeId);
        volume.next();
    %>
    <h1>Выпуск <%=volume.getString("TITLE")%></h1>
    <p>Дата выхода: <%=volume.getString("PUBLISH_DATE")%></p>
    <p>Тираж: <%=volume.getString("NUM_OF_COPIES")%></p>

    <h1>Статьи вошедшие в выпуск</h1>
    <%
    articles = DataBaseConnection.getRecords("SELECT * FROM ARTICLE "
            + "WHERE VOLUME_ID=" + volumeId);
    if (!articles.next()){
        %><p>Статьи отсутствуют</p><%
    } else {
    %>
        <table BORDER="1">
            <tr>
                <td>Тема</td><td>Название</td><td>Авторы</td>
                <td>Дата написания</td><td>Статус</td>
            </tr>
            <% do
            {
            %>
            <tr>
                <td><% rs = DataBaseConnection.getRecords("SELECT * FROM THEME "
                        + "WHERE THEME_ID=" + Integer.parseInt(articles.getString("THEME_ID")));
                        rs.next(); %>
                    <%=rs.getString("LABEL")%></td>
                <td><a href="aboutArticle.jsp?id=<%=id%>&role=<%=role%>&article=<%=articles.getString("ARTICLE_ID")%>"><%=articles.getString("TITLE")%></a></td>
                <td><% rs = DataBaseConnection.getRecords("SELECT * FROM ARTICLE_AUTHORS "
                                                + "WHERE ARTICLE_ID=" + Integer.parseInt(articles.getString("ARTICLE_ID")));
                    while (rs.next()){
                        ResultSet nrs = DataBaseConnection.getRecords("SELECT * FROM AUTHOR "
                                        + "WHERE AUTHOR_ID=" + rs.getString("AUTHOR_ID"));
                        nrs.next();
                        %><a href="aboutAuthor.jsp?id=<%=id%>&role=<%=role%>&author=<%=nrs.getString("AUTHOR_ID")%>"><%=nrs.getString("NAME")%></a><br><%
                    }
                    %>
                <td><%=articles.getString("WRITE_DATE")%></td>
                <td><% rs = DataBaseConnection.getRecords("SELECT * FROM STATUS "
                        + "WHERE STATUS_ID=" + Integer.parseInt(articles.getString("STATUS")));
                    rs.next();%>
                    <%=rs.getString("DESCRIPTION")%></td>
                </td>
            </tr><%
            } while (articles.next());
        %></table><%
        }
    %>

    <%
        switch (role){
            case 0:
            %><a href="<%="/adminMain.jsp?role=" + role + "&id=" + id + "&mode=3"%>">Назад</a> <%
            break;
        case 1:
             %><a href="<%="/editorMain.jsp?role=" + role + "&id=" + id%>">Назад</a> <%
            break;
        case 2:
            %><a href="<%="/authorMain.jsp?role=" + role + "&id=" + id%>">Назад</a> <%
            break;
        case 3:
            %><a href="<%="/reviewerMain.jsp?role=" + role + "&id=" + id%>">Назад</a> <%
            break;
        default:
            %><a href="index.jsp">Назад</a><%
        }
    %>
</body>
</html>