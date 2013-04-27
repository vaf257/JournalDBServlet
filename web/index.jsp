<%--
  Created by IntelliJ IDEA.
  User: Vasya
  Date: 02.04.13
  Time: 16:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=WINDOWS-1251" language="java" %>
<html>
  <head>
    <title>Journal Edit Log-IN</title>
  </head>
  <body>

  <h1>¬ход в систему</h1>
  <form name="loginForm" id="loginForm" method="POST" action="index_servlet">
      <table >
          <tr>
              <td>login</td>
              <td><input type="text" name="login" id="login" size="35"></td>
          </tr>
          <tr>
              <td>password</td>
              <td><input type="password" name="passw" id="passw" size="35"></td>
          </tr>
          <tr>
              <td><input type="submit" id="loginSubmit"></td>
          </tr>
      </table>
  </form>

  </body>
</html>