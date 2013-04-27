<%--
  Created by IntelliJ IDEA.
  User: Vasya
  Date: 05.04.13
  Time: 16:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="myServlet.DataBaseConnection"%>
<%@ page contentType="text/html;charset=WINDOWS-1251" language="java" %>
<html>
<head>
    <title>Editor main page</title>
</head>
<body>
    <%  request.setCharacterEncoding("WINDOWS-1251");
        int role = Integer.parseInt(request.getParameter("role"));
        int id  = Integer.parseInt(request.getParameter("id"));
        int w;
        ResultSet rs;
        ResultSet articles = DataBaseConnection.getRecords("SELECT * FROM ARTICLE WHERE STATUS = 3");
        if (request.getParameter("w")==null){
            w = 0;
        } else {
            w = Integer.parseInt(request.getParameter("w"));
        }
        String msg;

        switch (w){
            case 1:
                msg = "не все поля заполнены";
                break;
            case 2:
                msg = "wrong article_id";
                break;
            case 3:
                msg = "SQL Error";
                break;
            default:
                msg = "";
        }
    %>
    <h1>Личный кабинет редактора <%=id%></h1>
    <%
        if (!articles.next()){
            %>
            <p>Статьи допущенные к публикации отсутствуют</p>
            <%
        }else {
            %>
            <p>Статьи допущенные к публикации</p>
            <form name="newVolume" id="newVolume" method="POST" action="new_volume">
            <table border="1">
                <tr>
                    <td>Выбор</td><td>Тема</td><td>Название</td><td>Авторы</td>
                    <td>Дата написания</td><td>Статус</td>
                </tr>
                <%
                do {
                %>
                    <tr>
                        <td><input type="checkbox" name="articles" value="<%=articles.getString("ARTICLE_ID")%>"></td>
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
                            <%=rs.getString("DESCRIPTION")%>
                        </td>
                    </tr>
                <%
                } while (articles.next());
                %>
            </table>
            <input type="hidden" name="id" id="id" value="<%=id%>">
            <input type="hidden" name="role" id="role" value="<%=role%>">
            <br>
            <h1>Добавить новый выпуск</h1>
                <table>
                    <tr>
                        <td>Название</td><td>Дата публикации</td><td>Тираж</td>
                    </tr>
                    <tr>
                        <td><input type="text" name="title" id="titleField" size="35"></td>
                        <td><input type="date" name="date" id="dateField" size="35"></td>
                        <td><input type="text" pattern="^[ 0-9]+$" name="copies" id="copiesField" size="35"></td>
                    </tr>
                    <tr>
                        <td><p style="color: red"><%=msg%></p></td>
                        <td><input type="submit" id="loginSubmit"></td>
                    </tr>
                </table>
            </form>
            <%
        }
    %>

    <a href="index.jsp">Выход</a>
</body>
</html>