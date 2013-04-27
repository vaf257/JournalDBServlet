
<%--
  Created by IntelliJ IDEA.
  User: Vasya
  Date: 21.04.13
  Time: 1:16
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="myServlet.DataBaseConnection" %>
<%@ page contentType="text/html;charset=WINDOWS-1251" language="java" %>
<html>
<head>
    <title>About article</title>
</head>
<body>
    <%
        request.setCharacterEncoding("WINDOWS-1251");
        String msg;
        int w;
        int role = Integer.parseInt(request.getParameter("role"));
        int id  = Integer.parseInt(request.getParameter("id"));
        int articleId  = Integer.parseInt(request.getParameter("article"));
        boolean revExist = false;
        if (request.getParameter("w")==null){
            w = 0;
        } else {
            w = Integer.parseInt(request.getParameter("w"));
        }
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
        ResultSet rs;
        ResultSet revisions;
        ResultSet article = DataBaseConnection.getRecords("SELECT * FROM ARTICLE WHERE ARTICLE_ID =" + articleId);
        article.next();
    %>
    <h1>Описание статьи <%=article.getString("TITLE")%></h1>
    <table border="1">
        <tr>
            <td>id</td><td>Тема</td><td>Название</td><td>Авторы</td>
            <td>Дата написания</td><td>Статус</td>
        </tr>
        <tr>
            <td><%=article.getString("ARTICLE_ID")%></td>
            <td><% rs = DataBaseConnection.getRecords("SELECT * FROM THEME "
                    + "WHERE THEME_ID=" + Integer.parseInt(article.getString("THEME_ID")));
                rs.next();
                System.out.println(article.getString("TITLE"));%>
                <%=rs.getString("LABEL")%></td>
            <td><%=article.getString("TITLE")%></td>
            <td><% rs = DataBaseConnection.getRecords("SELECT * FROM ARTICLE_AUTHORS "
                            + "WHERE ARTICLE_ID=" + Integer.parseInt(article.getString("ARTICLE_ID")));
                while (rs.next()){
                    ResultSet nrs = DataBaseConnection.getRecords("SELECT * FROM AUTHOR "
                            + "WHERE AUTHOR_ID=" + rs.getString("AUTHOR_ID"));
                    nrs.next();
                %><a href="aboutAuthor.jsp?id=<%=id%>&role=<%=role%>&author=<%=nrs.getString("AUTHOR_ID")%>"><%=nrs.getString("NAME")%></a><br>
                    <% } %>
            <td><%=article.getString("WRITE_DATE")%></td>
            <td><% rs = DataBaseConnection.getRecords("SELECT * FROM STATUS "
                    + "WHERE STATUS_ID=" + Integer.parseInt(article.getString("STATUS")));
                rs.next();
                if (Integer.parseInt(article.getString("STATUS")) == 4){
                %><a href="aboutVolume.jsp?id=<%=id%>&role=<%=role%>&volume=<%=article.getString("VOLUME_ID")%>"><%=rs.getString("DESCRIPTION")%></a><%
                    } else{
                %><%=rs.getString("DESCRIPTION")%><%
                    }
                %>
            </td>
        </tr>
    </table>

    <h1>Рецензии на статью <%=article.getString("TITLE")%></h1>
    <table border="1">
        <tr>
            <td>id</td><td>Рецензент</td><td>Дата рецензии</td><td>Заметки</td><td>Заключение</td>
        </tr>
        <%
            revisions = DataBaseConnection.getRecords("SELECT * FROM REVISION WHERE ARTICLE_ID = " + articleId);
            while (revisions.next())
            {
                revExist = true;
                %>
                <tr>
                    <td><%=revisions.getString("REVISION_ID")%></td>
                    <td><% rs = DataBaseConnection.getRecords("SELECT * FROM REVIEWER "
                                    + "WHERE REVIEWER_ID=" + Integer.parseInt(revisions.getString("REVIEWER_ID")));
                            rs.next();%>
                        <a href="aboutReviewer.jsp?id=<%=id%>&role=<%=role%>&reviewer=<%=rs.getString("REVIEWER_ID")%>"><%=rs.getString("NAME")%></a></td>
                    <td><%=revisions.getString("REVISION_DATE")%></td>
                    <td><%=revisions.getString("NOTE")%></td>
                    <td><% rs = DataBaseConnection.getRecords("SELECT * FROM STATUS "
                            + "WHERE STATUS_ID=" + Integer.parseInt(revisions.getString("STATUS")));
                        rs.next();
                        %>
                        <%=rs.getString("DESCRIPTION")%>
                    </td>
                </tr>
                <%
            }
        %>
    </table>

    <%
        if (!revExist){
            %><p style="color: red">Ревизии отсутствуют</p><%
        }
        if (role == 3){
            %>
                <h1>Добавить рецензию</h1>
                <form name="newArticleForm" id="newArticleForm" method="POST" action="new_revision">
                    <table >
                        <tr>
                            <td>Заметки</td>
                            <td>Заключение</td>
                            <td>Дата</td>
                        </tr>
                        <tr>
                            <td>
                                <input type="hidden" name="id" id="id" value="<%=id%>">
                                <input type="hidden" name="articleId" id="articleId" value="<%=articleId%>">
                                <input type="hidden" name="role" id="role" value="<%=role%>">
                                <textarea rows="10" cols="45" name="note" id="note" size="35"></textarea></td>
                            </td>
                            <td>
                                <select id="conclusion" name="conclusion" >
                                    <option value = "2">Отклонено</option>
                                    <option value = "3">Принято</option>
                                </select>
                            <td><input type="date" name="date" id="dateField" size="35"></td>
                        </tr>
                        <tr>
                            <td><p style="color: red"><%=msg%></p></td>
                            <td><input type="submit" id="loginSubmit"></td>
                        </tr>
                    </table>
                </form>
            <%
        }
        switch (role){
            case 0:
                %><a href="<%="/adminMain.jsp?role=" + role + "&id=" + id + "&mode=0"%>">Назад</a> <%
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