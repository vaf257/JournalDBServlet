<%--
  Created by IntelliJ IDEA.
  User: Vasya
  Date: 21.04.13
  Time: 4:02
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="myServlet.DataBaseConnection" %>
<%@ page contentType="text/html;charset=WINDOWS-1251" language="java" %>
<html>
<head>
    <title>About reviewer</title>
</head>
<body>
    <%
        request.setCharacterEncoding("WINDOWS-1251");

        int role = Integer.parseInt(request.getParameter("role"));
        int id  = Integer.parseInt(request.getParameter("id"));
        int reviewerId  = Integer.parseInt(request.getParameter("reviewer"));

        ResultSet rs, theme;
        ResultSet reviews, article;
        ResultSet reviewer = DataBaseConnection.getRecords("SELECT * FROM REVIEWER WHERE REVIEWER_ID = " + reviewerId);
        reviewer.next();
    %>
    <h1>О рецензенте <%=reviewer.getString("NAME")%></h1>
    <p>ФИО: <%=reviewer.getString("NAME")%><br>
    Возраст: <%=reviewer.getString("AGE")%><br>
    Город: <%=reviewer.getString("CITY")%></p>
    <p>Сфера знаний</p>
    <ul>
        <%
            rs = DataBaseConnection.getRecords("SELECT * FROM REVIEWER_THEMS WHERE "
                    + "REVIEWER_ID = " + Integer.parseInt(reviewer.getString("REVIEWER_ID")));
            while (rs.next()){
                theme = DataBaseConnection.getRecords("SELECT * FROM THEME "
                        + "WHERE THEME_ID = " + rs.getString("THEME_ID"));
                theme.next();
            %><li><%=theme.getString("LABEL")%></li><%
            }
        %>

    </ul>
    <p>Рецензии</p>
    <%
        reviews = DataBaseConnection.getRecords("SElECT * FROM REVISION WHERE REVIEWER_ID = " + reviewerId);
        if (!reviews.next()){
            %>Рецензии отсутствуют<%
        } else {
            %><table border="1">
                <tr>
                    <td>Тема</td><td>Статья</td><td>Авторы</td><td>Дата рецензии</td><td>Заметки</td><td>Заключение</td>
                </tr><%
                do {
                    article = DataBaseConnection.getRecords("SELECT * FROM ARTICLE WHERE ARTICLE_ID = " + reviews.getString("ARTICLE_ID"));
                    article.next();
                    %><tr>
                        <td><% rs = DataBaseConnection.getRecords("SELECT * FROM THEME "
                                + "WHERE THEME_ID=" + Integer.parseInt(article.getString("THEME_ID")));
                            rs.next();%>
                            <%=rs.getString("LABEL")%></td>
                        <td><a href="aboutArticle.jsp?id=<%=id%>&role=<%=role%>&article=<%=article.getString("ARTICLE_ID")%>"><%=article.getString("TITLE")%></a></td>
                        <td><% rs = DataBaseConnection.getRecords("SELECT * FROM ARTICLE_AUTHORS "
                                                                                + "WHERE ARTICLE_ID=" + Integer.parseInt(article.getString("ARTICLE_ID")));
                            while (rs.next()){
                                ResultSet nrs = DataBaseConnection.getRecords("SELECT * FROM AUTHOR "
                                        + "WHERE AUTHOR_ID=" + rs.getString("AUTHOR_ID"));
                                nrs.next();
                                %><a href="aboutAuthor.jsp?id=<%=id%>&role=<%=role%>&author=<%=nrs.getString("AUTHOR_ID")%>"><%=nrs.getString("NAME")%></a><br><%
                            } %>
                        <td><%=reviews.getString("REVISION_DATE")%></td>
                        <td><%=reviews.getString("NOTE")%></td>
                        <td><% rs = DataBaseConnection.getRecords("SELECT * FROM STATUS "
                                + "WHERE STATUS_ID=" + Integer.parseInt(reviews.getString("STATUS")));
                            rs.next();%>
                            <%=rs.getString("DESCRIPTION")%></td>
                        </td>
                    </tr><%
                } while (reviews.next());
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