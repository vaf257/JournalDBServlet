<%--
  Created by IntelliJ IDEA.
  User: Vasya
  Date: 21.04.13
  Time: 3:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="myServlet.DataBaseConnection" %>
<%@ page contentType="text/html;charset=WINDOWS-1251" language="java" %>
<html>
<head>
    <title>About Author</title>
</head>
<body>
    <%
        request.setCharacterEncoding("WINDOWS-1251");

        int role = Integer.parseInt(request.getParameter("role"));
        int id  = Integer.parseInt(request.getParameter("id"));
        int authorId  = Integer.parseInt(request.getParameter("author"));

        ResultSet rs;
        ResultSet article;
        ResultSet author = DataBaseConnection.getRecords("SELECT * FROM AUTHOR WHERE AUTHOR_ID = " + authorId);
        author.next();
    %>
    <h1>�� ������ <%=author.getString("NAME")%></h1>
    <p>���: <%=author.getString("NAME")%></p>
    <p>�������: <%=author.getString("AGE")%></p>
    <p>�����: <%=author.getString("CITY")%></p>
    <p>������</p>
    <%
        ResultSet articlesId = DataBaseConnection.getRecords("SELECT * FROM ARTICLE_AUTHORS WHERE AUTHOR_ID = " + authorId);
        if (!articlesId.next()){
            %><p>������ �����������</p><%
        } else {
        %><table border="1">
            <tr>
                <td>id</td><td>����</td><td>��������</td><td>������</td>
                <td>���� ���������</td><td>������</td>
            </tr><%
            do {
                article = DataBaseConnection.getRecords("SELECT * FROM ARTICLE WHERE ARTICLE_ID = " + articlesId.getString("ARTICLE_ID"));
                article.next();
            %><tr>
                <td><%=article.getString("ARTICLE_ID")%></td>
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
            </tr><%
            } while (articlesId.next());
        %></table><%
        }

        switch (role){
        case 0:
            %><a href="<%="/adminMain.jsp?role=" + role + "&id=" + id + "&mode=2"%>">�����</a> <%
            break;
        case 1:
            %><a href="<%="/editorMain.jsp?role=" + role + "&id=" + id%>">�����</a> <%
            break;
        case 2:
            %><a href="<%="/authorMain.jsp?role=" + role + "&id=" + id%>">�����</a> <%
            break;
        case 3:
            %><a href="<%="/reviewerMain.jsp?role=" + role + "&id=" + id%>">�����</a> <%
            break;
        default:
            %><a href="index.jsp">�����</a><%
        }
    %>


</body>
</html>