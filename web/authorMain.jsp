
<%--
  Created by IntelliJ IDEA.
  User: Vasya
  Date: 05.04.13
  Time: 13:48
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="myServlet.DataBaseConnection"%>
<%@ page contentType="text/html;charset=WINDOWS-1251" language="java" %>
<html>
<head>
    <title>Author main page</title>
</head>
<body>
    <%  request.setCharacterEncoding("WINDOWS-1251");

        int w;
        int role = Integer.parseInt(request.getParameter("role"));
        int id  = Integer.parseInt(request.getParameter("id"));
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
        ResultSet rs = DataBaseConnection.getRecords("SELECT * FROM AUTHOR "
                + "WHERE AUTHOR_ID=" + id);
        rs.next();
    %>
    <h1>Личный кабинет автора <%=rs.getString("NAME")%></h1>
    <%
        ResultSet auth_art = DataBaseConnection.getRecords("SELECT * FROM ARTICLE_AUTHORS "
                + "WHERE AUTHOR_ID=" + id);
        if (!auth_art.next()){
            %><p>Статьи отсутствуют</p><%
        } else {
            %><p>Статьи автора</p>
            <table BORDER="1">
                <tr>
                    <td>id</td><td>Тема</td><td>Название</td><td>Авторы</td>
                    <td>Дата написания</td><td>Статус</td>
                </tr>
                <% do {
                    ResultSet articles = DataBaseConnection.getRecords("SELECT * FROM ARTICLE "
                                            + "WHERE ARTICLE_ID=" + auth_art.getString("ARTICLE_ID"));
                    articles.next();
                %>
                    <tr>
                    <td><%=articles.getString("ARTICLE_ID")%></td>
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
                            rs.next();
                            if (Integer.parseInt(articles.getString("STATUS")) == 4){
                            %><a href="aboutVolume.jsp?id=<%=id%>&role=<%=role%>&volume=<%=articles.getString("VOLUME_ID")%>"><%=rs.getString("DESCRIPTION")%></a><%
                                } else{
                            %><%=rs.getString("DESCRIPTION")%><%
                                }
                            %>
                        </td>
                    </tr><%
                } while (auth_art.next());
            %></table><%
        }
    %>
    <hr><br>
    <h1>Добавление новой статьи</h1>
    <form name="newArticleForm" id="newArticleForm" method="POST" action="new_article_servlet">
        <table >
            <tr>
                <td>Тема</td>
                <td>Заголовок</td>
                <td>Соавторы</td>
                <td>Дата</td>
            </tr>
            <tr>
                <td>
                    <input type="hidden" name="id" id="id" value="<%=id%>">
                    <input type="hidden" name="role" id="role" value="<%=role%>">
                    <select id="theme" name="themeValue" >
                        <%
                            rs = DataBaseConnection.getRecords("SELECT * FROM THEME");
                            while (rs.next()){
                                %><option value = "<%=rs.getString("THEME_ID")%>"><%=rs.getString("LABEL")%></option><%
                            }
                        %>
                    </select>
                </td>
                <td><input type="text" name="title" id="titleField" size="35"></td>
                <td>
                    <select id="author1" name="author1" >
                        <%
                            rs = DataBaseConnection.getRecords("SELECT * FROM AUTHOR");
                            %><option value = "0"></option><%
                            while (rs.next()){
                                %><option value = "<%=rs.getString("AUTHOR_ID")%>"><%=rs.getString("NAME")%></option><%
                            }
                        %>
                    </select>
                    <br>
                    <select id="author2" name="author2" >
                        <%
                            rs = DataBaseConnection.getRecords("SELECT * FROM AUTHOR");
                            %><option value = "0"></option><%
                            while (rs.next()){
                                %><option value = "<%=rs.getString("AUTHOR_ID")%>"><%=rs.getString("NAME")%></option><%
                            }
                        %>
                    </select>
                    <br>
                    <select id="author3" name="author3" >
                        <%
                            rs = DataBaseConnection.getRecords("SELECT * FROM AUTHOR");
                            %><option value = "0"></option><%
                            while (rs.next()){
                                %><option value = "<%=rs.getString("AUTHOR_ID")%>"><%=rs.getString("NAME")%></option><%
                            }
                    %>
                    </select>
                </td>
                <td><input type="date" name="date" id="dateField" size="35"></td>
            </tr>
            <tr>
                <td><p style="color: red"><%=msg%></p></td>
                <td><input type="submit" id="loginSubmit"></td>
            </tr>
        </table>
    </form>
    <a href="index.jsp">Выход</a>
</body>
</html>