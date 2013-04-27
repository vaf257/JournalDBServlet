<%--
  Created by IntelliJ IDEA.
  User: Vasya
  Date: 05.04.13
  Time: 16:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="myServlet.DataBaseConnection"%>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=WINDOWS-1251" language="java" %>
<html>
<head>
    <title>Admin main page</title>
</head>
<body>
    <%
        //request.setCharacterEncoding("WINDOWS-1251");
        int role = Integer.parseInt(request.getParameter("role"));
        int id  = Integer.parseInt(request.getParameter("id"));
        int mode  = Integer.parseInt(request.getParameter("mode"));
        ResultSet rs;
    %>
    <h1>Личный кабинет администратора <%=id%></h1>
    <table>
        <tr>
            <td style="vertical-align: top">
                <h1>Меню</h1>
                <ul>
                    <li><a href="adminMain.jsp?role=<%=role%>&id=<%=id%>&mode=0">Все статьи</a></li>
                    <li><a href="adminMain.jsp?role=<%=role%>&id=<%=id%>&mode=1">Все выпуски</a></li>
                    <li><a href="adminMain.jsp?role=<%=role%>&id=<%=id%>&mode=2">Все авторы</a></li>
                    <li><a href="adminMain.jsp?role=<%=role%>&id=<%=id%>&mode=3">Все рецензенты</a></li>
                </ul>
            </td>
            <td style="vertical-align: top">
                <%
                    switch (mode){
                    case 0:
                        %><h1>Все статьи</h1><%
                        ResultSet articles = DataBaseConnection.getRecords("SELECT * FROM ARTICLE");
                        if (!articles.next()){
                            %><p>Статьи отсутствуют</p><%
                        } else {
                            %><table border="1">
                                <tr>
                                    <td>id</td><td>Тема</td><td>Название</td><td>Авторы</td>
                                    <td>Дата написания</td><td>Статус</td>
                                </tr><%
                                do {
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
                                            <% } %>
                                        <td><%=articles.getString("WRITE_DATE")%></td>
                                        <td><% rs = DataBaseConnection.getRecords("SELECT * FROM STATUS "
                                                + "WHERE STATUS_ID=" + Integer.parseInt(articles.getString("STATUS")));
                                            rs.next();
                                            if (Integer.parseInt(articles.getString("STATUS")) == 4){
                                                %><a href="aboutVolume.jsp?id=<%=id%>&role=<%=role%>&volume=<%=articles.getString("VOLUME_ID")%>"><%=rs.getString("DESCRIPTION")%></a><%
                                            } else{
                                                %><%=rs.getString("DESCRIPTION")%><%
                                            }
                                            %>
                                            </td>
                                        </td>
                                    </tr><%
                                } while (articles.next());


                            %></table><%
                        }
                        break;
                    case 1:
                        %><h1>Все выпуски</h1><%
                        ResultSet volumes = DataBaseConnection.getRecords("SELECT * FROM VOLUME");
                        if (!volumes.next()){
                            %><p>Выпуски отсутствуют</p><%
                        } else {
                            %><table border="1">
                            <tr>
                                <td>id</td><td>Заголовок</td><td>Дата выпуска</td><td>Тираж</td>
                            </tr><%
                            do {
                            %><tr>
                                <td><%=volumes.getString("VOLUME_ID")%></td>
                                <td><a href="aboutVolume.jsp?role=<%=role%>&id=<%=id%>&volume=<%=volumes.getString("VOLUME_ID")%>"><%=volumes.getString("TITLE")%></a></td>
                                <td><%=volumes.getString("PUBLISH_DATE")%></td>
                                <td><%=volumes.getString("NUM_OF_COPIES")%></td>
                            </tr><%
                            } while (volumes.next());
                            %></table><%
                        }
                        break;
                    case 2:
                        %><h1>Все авторы</h1><%
                        ResultSet authors = DataBaseConnection.getRecords("SELECT * FROM AUTHOR");
                        if (!authors.next()){
                            %><p>Авторы отсутствуют</p><%
                        } else {
                        %><table border="1">
                            <tr>
                                <td>id</td><td>Имя</td><td>Возраст</td><td>Город</td>
                            </tr><%
                            do {
                                %><tr>
                                    <td><%=authors.getString("AUTHOR_ID")%></td>
                                    <td><a href="aboutAuthor.jsp?id=<%=id%>&role=<%=role%>&author=<%=authors.getString("AUTHOR_ID")%>"><%=authors.getString("NAME")%></a></td>
                                    <td><%=authors.getString("AGE")%></td>
                                    <td><%=authors.getString("CITY")%></td>
                                </tr><%
                            } while (authors.next());
                        %></table><%
                        }
                        break;
                    case 3:
                        %><h1>Все рецензенты</h1><%
                        ResultSet reviewers = DataBaseConnection.getRecords("SELECT * FROM REVIEWER");
                        if (!reviewers.next()){
                            %><p>Авторы отсутствуют</p><%
                        } else {
                            %><table border="1">
                            <tr>
                                <td>id</td><td>Имя</td><td>Сфера знаний</td><td>Возраст</td><td>Город</td>
                            </tr><%
                            do {
                                %><tr>
                                    <td><%=reviewers.getString("REVIEWER_ID")%></td>
                                    <td><a href="aboutReviewer.jsp?id=<%=id%>&role=<%=role%>&reviewer=<%=reviewers.getString("REVIEWER_ID")%>"><%=reviewers.getString("NAME")%></a></td>
                                    <td>
                                        <%
                                        rs = DataBaseConnection.getRecords("SELECT * FROM REVIEWER_THEMS WHERE "
                                                + "REVIEWER_ID = " + Integer.parseInt(reviewers.getString("REVIEWER_ID")));
                                        while (rs.next()){
                                            ResultSet theme = DataBaseConnection.getRecords("SELECT * FROM THEME "
                                                    + "WHERE THEME_ID = " + rs.getString("THEME_ID"));
                                            theme.next();
                                            %><%=theme.getString("LABEL")%><br><%
                                        }
                                        %>
                                    </td>
                                    <td><%=reviewers.getString("AGE")%></td>
                                    <td><%=reviewers.getString("CITY")%></td>
                                </tr><%
                            } while (reviewers.next());
                            %></table><%
                        }
                        break;
                    default: %><h1>Неверный режим</h1><%
                    }
                %>
            </td>
        </tr>
    </table>
    <a href="index.jsp">Выход</a>
</body>
</html>